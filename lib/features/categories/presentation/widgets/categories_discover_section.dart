import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/theme/app_colors.dart';

class CategoriesDiscoverSection extends StatelessWidget {
  const CategoriesDiscoverSection({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = <String>[
      'electronics_category',
      'fashion_category',
      'accessories_category',
      'home_kitchen_category',
      'sports_outdoors_category',
      'toys_games_category',
      'health_fitness_category',
      'books_category',
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('discover'.tr(), style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700)),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.add_circle_outline_rounded, size: 16.sp),
                label: Text('add_product'.tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CB87B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
              ),
              SizedBox(width: 8.w),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  side: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
                ),
                child: Text('more_action'.tr()),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          GridView.builder(
            itemCount: categories.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 10.h,
              childAspectRatio: 2.4,
            ),
            itemBuilder: (_, index) => _CategoryCard(titleKey: categories[index]),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.titleKey});

  final String titleKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBFF),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1FF),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.image_outlined, size: 20.sp, color: AppColors.accent),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              titleKey.tr(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
