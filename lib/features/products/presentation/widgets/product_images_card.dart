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
    if (_thumbImages.length >= 5) return;
    final ProductImageItem? selected = await _selectImageSource();
    if (!mounted || selected == null) return;
    setState(() => _thumbImages.add(selected));
    _notify();
  }

  void _removeThumb(int index) {
    setState(() => _thumbImages.removeAt(index));
    _notify();
  }

  Future<ProductImageItem?> _selectImageSource() async {
    final PickSource? source = await showModalBottomSheet<PickSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose image source',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 12.h),
              SourceTile(
                icon: Icons.link,
                title: 'From internet link',
                subtitle: 'Paste image URL then preview before adding',
                onTap: () => Navigator.pop(ctx, PickSource.network),
              ),
              SizedBox(height: 10.h),
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
      builder: (ctx) => AlertDialog(
        title: const Text('Add image from internet'),
        content: TextField(
          controller: urlCtrl,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Image URL',
            hintText: 'https://example.com/image.jpg',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final String value = urlCtrl.text.trim();
              if (value.isNotEmpty) Navigator.pop(ctx, value);
            },
            child: const Text('Preview'),
          ),
        ],
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
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm image'),
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
                    color: const Color(0xFFF5F5F5),
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Center(
                        child: Text(
                          'Invalid image link',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
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
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  url,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Reject'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    return decision ?? false;
  }

  void _notify() {
    final images = <ProductImageItem>[
      ?_mainImage,
      ..._thumbImages,
    ];
    widget.onChanged?.call(images);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload product image',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'PRODUCT IMAGE',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              letterSpacing: 0.6,
            ),
          ),
          SizedBox(height: 10.h),
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
