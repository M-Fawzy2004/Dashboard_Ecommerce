import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/theme/app_spacing.dart';

class SalesByCountryCard extends StatelessWidget {
  const SalesByCountryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final countries = [
      {'name': 'US', 'sales': '30k', 'trend': '25.8%', 'isUp': true},
      {'name': 'Brazil', 'sales': '30k', 'trend': '15.0%', 'isUp': false},
      {'name': 'Australia', 'sales': '25k', 'trend': '35.3%', 'isUp': true},
    ];

    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sales by Country', style: Theme.of(context).textTheme.titleMedium),
                Text('Sales', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            AppSpacing.v20,
            ...countries.map((c) => Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Row(
                    children: [
                      Container(
                        width: 32.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Icon(Icons.flag, size: 16.sp, color: AppColors.textSecondary),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c['sales'] as String, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp)),
                            Text(c['name'] as String, style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 6.h,
                          decoration: BoxDecoration(
                            color: AppColors.divider,
                            borderRadius: BorderRadius.circular(3.r),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: 0.6,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(3.r),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Row(
                        children: [
                          Icon(
                            (c['isUp'] as bool) ? Icons.arrow_upward : Icons.arrow_downward,
                            color: (c['isUp'] as bool) ? AppColors.success : AppColors.error,
                            size: 12.sp,
                          ),
                          Text(
                            c['trend'] as String,
                            style: TextStyle(
                              color: (c['isUp'] as bool) ? AppColors.success : AppColors.error,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
            AppSpacing.v10,
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accent,
                  side: const BorderSide(color: Color(0xFFD1D5DB)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                child: const Text('View Insight'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
