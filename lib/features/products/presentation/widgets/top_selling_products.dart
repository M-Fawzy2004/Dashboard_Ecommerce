import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/theme/app_colors.dart';

class TopSellingProducts extends StatelessWidget {
  const TopSellingProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final products = <_TopProduct>[
      _TopProduct('Wireless Headphones', 'electronics', 92),
      _TopProduct('Cotton Hoodie', 'fashion', 84),
      _TopProduct('Smart Watch Strap', 'accessories', 76),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('top_selling'.tr(), style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 14.h),
          ...products.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    item.categoryKey.tr(),
                    style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                  ),
                  SizedBox(width: 12.w),
                  SizedBox(
                    width: 140.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: LinearProgressIndicator(
                        minHeight: 8.h,
                        value: item.score / 100,
                        backgroundColor: AppColors.background,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text('${item.score}%'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopProduct {
  const _TopProduct(this.name, this.categoryKey, this.score);

  final String name;
  final String categoryKey;
  final int score;
}
