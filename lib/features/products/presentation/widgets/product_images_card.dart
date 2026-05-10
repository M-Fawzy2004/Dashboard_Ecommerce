import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../shared/theme/app_colors.dart';
import 'product_images/product_image_models.dart';
import 'product_images/product_image_widgets.dart';

class ProductImagesCard extends StatefulWidget {
  const ProductImagesCard({
    super.key,
    this.initialMainUrl,
    this.initialOtherUrls,
    this.onChanged,
  });

  final String? initialMainUrl;
  final List<String>? initialOtherUrls;
  final ValueChanged<List<ProductImageItem>>? onChanged;

  @override
  State<ProductImagesCard> createState() => _ProductImagesCardState();
}

class _ProductImagesCardState extends State<ProductImagesCard> {
  final ImagePicker _picker = ImagePicker();
  ProductImageItem? _mainImage;
  final List<ProductImageItem> _thumbImages = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialMainUrl != null) {
      _mainImage = ProductImageItem.network(widget.initialMainUrl!);
    }
    if (widget.initialOtherUrls != null) {
      _thumbImages.addAll(widget.initialOtherUrls!.map((url) => ProductImageItem.network(url)));
    }
  }

  Future<void> _pickMainImage() async {
    final ProductImageItem? selected = await _selectImageSource();
    if (!mounted || selected == null) return;
    setState(() => _mainImage = selected);
    _notify();
  }

  Future<void> _replaceMainImage() async {
    final ProductImageItem? selected = await _selectImageSource();
    if (!mounted || selected == null) return;
    setState(() => _mainImage = selected);
    _notify();
  }

  Future<void> _addThumbImage() async {
    final source = await showModalBottomSheet<PickSource>(
      context: context,
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose image source',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16.h),
              SourceTile(
                icon: Icons.link,
                title: 'From internet link',
                subtitle: 'Paste image URL then preview before adding',
                onTap: () => Navigator.pop(ctx, PickSource.network),
              ),
              SizedBox(height: 12.h),
              SourceTile(
                icon: Icons.photo_library_outlined,
                title: 'From device (Multi-select)',
                subtitle: 'Pick one or more images from your gallery',
                onTap: () => Navigator.pop(ctx, PickSource.device),
              ),
            ],
          ),
        ),
      ),
    );

    if (source == null) return;

    if (source == PickSource.device) {
      final List<XFile> picked = await _picker.pickMultiImage();
      if (picked.isEmpty) return;
      
      final List<ProductImageItem> newImages = [];
      for (var file in picked) {
        newImages.add(ProductImageItem.memory(await file.readAsBytes()));
      }
      
      setState(() => _thumbImages.addAll(newImages));
      _notify();
    } else {
      final selected = await _pickFromNetworkUrl();
      if (selected != null) {
        setState(() => _thumbImages.add(selected));
        _notify();
      }
    }
  }

  void _removeThumb(int index) {
    setState(() => _thumbImages.removeAt(index));
    _notify();
  }

  Future<ProductImageItem?> _selectImageSource() async {
    final PickSource? source = await showModalBottomSheet<PickSource>(
      context: context,
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose image source',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16.h),
              SourceTile(
                icon: Icons.link,
                title: 'From internet link',
                subtitle: 'Paste image URL then preview before adding',
                onTap: () => Navigator.pop(ctx, PickSource.network),
              ),
              SizedBox(height: 12.h),
              SourceTile(
                icon: Icons.photo_library_outlined,
                title: 'From device',
                subtitle: 'Pick image from your gallery',
                onTap: () => Navigator.pop(ctx, PickSource.device),
              ),
            ],
          ),
        ),
      ),
    );

    if (source == null) return null;
    if (source == PickSource.device) return _pickFromDevice();
    return _pickFromNetworkUrl();
  }

  Future<ProductImageItem?> _pickFromDevice() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return null;
    return ProductImageItem.memory(await picked.readAsBytes());
  }

  Future<ProductImageItem?> _pickFromNetworkUrl() async {
    final TextEditingController urlCtrl = TextEditingController();
    final String? url = await showDialog<String>(
      context: context,
      builder: (ctx) => Theme(
        data: Theme.of(ctx).copyWith(
          dialogBackgroundColor: AppColors.card,
        ),
        child: AlertDialog(
          backgroundColor: AppColors.card,
          title: Text('Add image from internet', style: TextStyle(color: Colors.white, fontSize: 16.sp)),
          content: TextField(
            controller: urlCtrl,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Image URL',
              labelStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
              hintText: 'https://example.com/image.jpg',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel', style: TextStyle(color: Colors.white.withOpacity(0.5))),
            ),
            TextButton(
              onPressed: () {
                final String value = urlCtrl.text.trim();
                if (value.isNotEmpty) Navigator.pop(ctx, value);
              },
              child: const Text('Preview', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
    urlCtrl.dispose();

    if (url == null || url.isEmpty) return null;
    final bool confirmed = await _confirmNetworkImage(url);
    if (!confirmed) return null;
    return ProductImageItem.network(url);
  }

  Future<bool> _confirmNetworkImage(String url) async {
    final bool? decision = await showDialog<bool>(
      context: context,
      builder: (ctx) => Theme(
        data: Theme.of(ctx).copyWith(dialogBackgroundColor: AppColors.card),
        child: AlertDialog(
          backgroundColor: AppColors.card,
          title: Text('Confirm image', style: TextStyle(color: Colors.white, fontSize: 16.sp)),
          contentPadding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 8.h),
          content: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 320.w, maxHeight: 320.h),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                      height: 170.h,
                      width: double.infinity,
                      color: Colors.white.withOpacity(0.05),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Center(
                          child: Text(
                            'Invalid image link',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Preview from URL',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    url,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('Reject', style: TextStyle(color: Colors.white.withOpacity(0.5))),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Confirm', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
    return decision ?? false;
  }

  void _notify() {
    final images = <ProductImageItem>[
      if (_mainImage != null) _mainImage!,
      ..._thumbImages,
    ];
    widget.onChanged?.call(images);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.image_outlined, size: 18.sp, color: Colors.white.withOpacity(0.4)),
              ),
              SizedBox(width: 12.w),
              Text(
                'Product Images',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Divider(color: Colors.white.withOpacity(0.06), height: 1),
          SizedBox(height: 20.h),
          Text(
            'Upload high-quality images of your product to attract more customers.',
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.white.withOpacity(0.3),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 24.h),
          MainImageUploadCard(
            mainImage: _mainImage,
            thumbImages: _thumbImages,
            onBrowse: _pickMainImage,
            onReplace: _replaceMainImage,
            onAddThumb: _addThumbImage,
            onRemoveThumb: _removeThumb,
          ),
        ],
      ),
    );
  }
}
