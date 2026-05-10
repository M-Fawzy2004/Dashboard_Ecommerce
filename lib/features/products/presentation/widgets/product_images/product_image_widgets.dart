import 'package:dashboard_ecommerce/shared/widgets/hover_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'product_image_models.dart';

class MainImageUploadCard extends StatelessWidget {
  const MainImageUploadCard({
    super.key,
    required this.mainImage,
    required this.thumbImages,
    required this.onBrowse,
    required this.onReplace,
    required this.onAddThumb,
    required this.onRemoveThumb,
  });

  final ProductImageItem? mainImage;
  final List<ProductImageItem> thumbImages;
  final VoidCallback onBrowse;
  final VoidCallback onReplace;
  final VoidCallback onAddThumb;
  final void Function(int index) onRemoveThumb;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: mainImage == null ? onBrowse : null,
          child: Container(
            height: 240.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.white.withOpacity(0.04)),
            ),
            child: mainImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: Stack(
                      children: [
                        Positioned.fill(child: ImagePreview(item: mainImage!, fit: BoxFit.contain)),
                        Positioned(
                          top: 12.h,
                          right: 12.w,
                          child: HoverButton(
                            onTap: onReplace,
                            borderRadius: 10.r,
                            child: Container(
                              padding: EdgeInsets.all(8.r),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Icon(Icons.sync_outlined, size: 16.sp, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 32.sp,
                        color: Colors.white.withOpacity(0.1),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Click to upload main image',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.2),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Text(
              'GALLERY IMAGES',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white.withOpacity(0.2),
                letterSpacing: 1.5,
              ),
            ),
            const Spacer(),
            Text(
              '${thumbImages.length}/5',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 100.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              ...List.generate(thumbImages.length, (i) {
                return Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: SizedBox(
                    width: 100.w,
                    child: ThumbImageTile(
                      imageItem: thumbImages[i],
                      onRemove: () => onRemoveThumb(i),
                    ),
                  ),
                );
              }),
              if (thumbImages.length < 5)
                SizedBox(width: 100.w, child: AddThumbTile(onTap: onAddThumb)),
            ],
          ),
        ),
      ],
    );
  }
}

class SourceTile extends StatelessWidget {
  const SourceTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HoverButton(
      onTap: onTap,
      borderRadius: 12.r,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, size: 18.sp, color: Colors.white.withOpacity(0.6)),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 11.sp, color: Colors.white.withOpacity(0.3)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThumbImageTile extends StatelessWidget {
  const ThumbImageTile({super.key, required this.imageItem, required this.onRemove});
  final ProductImageItem imageItem;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11.r),
                child: ImagePreview(item: imageItem),
              ),
            ),
            Positioned(
              top: 4.h,
              right: 4.w,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, size: 12.sp, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
}

class ImagePreview extends StatelessWidget {
  const ImagePreview({super.key, required this.item, this.fit = BoxFit.cover});
  final ProductImageItem item;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (item.bytes != null) return Image.memory(item.bytes!, fit: fit);
    return Image.network(
      item.url!,
      fit: fit,
      errorBuilder: (_, _, _) => Container(
        color: Colors.white.withOpacity(0.05),
        alignment: Alignment.center,
        child: Icon(
          Icons.broken_image_outlined,
          color: Colors.white.withOpacity(0.1),
        ),
      ),
    );
  }
}

class AddThumbTile extends StatelessWidget {
  const AddThumbTile({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => HoverButton(
        onTap: onTap,
        borderRadius: 12.r,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.02),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.05),
              style: BorderStyle.solid,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_rounded, size: 24.sp, color: Colors.white.withOpacity(0.2)),
                SizedBox(height: 4.h),
                Text(
                  'Add',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
