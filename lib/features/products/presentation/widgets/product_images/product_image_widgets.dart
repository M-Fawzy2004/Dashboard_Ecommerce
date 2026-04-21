import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../shared/theme/app_colors.dart';
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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.07)),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: mainImage == null ? onBrowse : null,
            child: Container(
              height: 210.h,
              width: 170.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.black.withValues(alpha: 0.07)),
              ),
              child: mainImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(11.r),
                      child: ImagePreview(item: mainImage!),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          size: 28.sp,
                          color: AppColors.textSecondary.withValues(alpha: 0.4),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'No image',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textSecondary.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              ImageActionButton(
                icon: Icons.folder_open_outlined,
                label: 'Browse',
                onTap: onBrowse,
              ),
              const Spacer(),
              ImageActionButton(
                icon: Icons.sync_outlined,
                label: 'Replace',
                onTap: onReplace,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 92.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...List.generate(thumbImages.length, (i) {
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: SizedBox(
                      width: 92.w,
                      child: ThumbImageTile(
                        imageItem: thumbImages[i],
                        onRemove: () => onRemoveThumb(i),
                      ),
                    ),
                  );
                }),
                if (thumbImages.length < 5)
                  SizedBox(width: 92.w, child: AddThumbTile(onTap: onAddThumb)),
              ],
            ),
          ),
        ],
      ),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18.sp, color: AppColors.primary),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700)),
                  SizedBox(height: 2.h),
                  Text(subtitle, style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary.withValues(alpha: 0.9))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageActionButton extends StatelessWidget {
  const ImageActionButton({super.key, required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), border: Border.all(color: Colors.black.withValues(alpha: 0.10))),
            child: Row(children: [Icon(icon, size: 14.sp, color: AppColors.textSecondary), SizedBox(width: 6.w), Text(label, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500))]),
          ),
        ),
      );
}

class ThumbImageTile extends StatelessWidget {
  const ThumbImageTile({super.key, required this.imageItem, required this.onRemove});
  final ProductImageItem imageItem;
  final VoidCallback onRemove;
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(5.r),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r), border: Border.all(color: Colors.black.withValues(alpha: 0.08))),
        child: Stack(children: [
          Positioned.fill(child: ClipRRect(borderRadius: BorderRadius.circular(7.r), child: ImagePreview(item: imageItem))),
          Positioned(
            top: -4.h,
            right: -4.w,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 16.w,
                height: 16.h,
                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.black.withValues(alpha: 0.10))),
                child: Icon(Icons.close, size: 9.sp, color: AppColors.textSecondary),
              ),
            ),
          ),
        ]),
      );
}

class ImagePreview extends StatelessWidget {
  const ImagePreview({super.key, required this.item});
  final ProductImageItem item;
  @override
  Widget build(BuildContext context) {
    if (item.bytes != null) return Image.memory(item.bytes!, fit: BoxFit.cover);
    return Image.network(item.url!, fit: BoxFit.cover, errorBuilder: (_, _, _) => Container(color: const Color(0xFFF1F1F1), alignment: Alignment.center, child: Icon(Icons.broken_image_outlined, color: AppColors.textSecondary.withValues(alpha: 0.5))));
  }
}

class AddThumbTile extends StatelessWidget {
  const AddThumbTile({super.key, required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r), border: Border.all(color: Colors.black.withValues(alpha: 0.12))),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
                  child: Icon(Icons.add, size: 13.sp, color: const Color(0xFF388E3C)),
                ),
                SizedBox(height: 5.h),
                Text('Add image', style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w500, color: const Color(0xFF388E3C))),
              ],
            ),
          ),
        ),
      );
}
