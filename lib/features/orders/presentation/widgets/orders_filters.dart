import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/theme/app_colors.dart';

class OrdersFilters extends StatelessWidget {
  const OrdersFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final filters = ['all_orders', 'pending', 'processing', 'completed', 'cancelled'];
    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: filters
          .map(
            (key) => Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
              decoration: BoxDecoration(
                color: key == 'all_orders'
                    ? AppColors.electricBlue.withValues(alpha: 0.18)
                    : AppColors.slate,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                key.tr(),
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textPrimary,
                  fontWeight: key == 'all_orders' ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
