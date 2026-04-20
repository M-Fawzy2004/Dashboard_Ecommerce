import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/theme/app_colors.dart';

class WeeklyRevenueCard extends StatelessWidget {
  const WeeklyRevenueCard({super.key});

  @override
  Widget build(BuildContext context) {
    final bars = <double>[0.45, 0.6, 0.35, 0.78, 0.88, 0.66, 0.74];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.slate,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('weekly_revenue'.tr(), style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 18.h),
          SizedBox(
            height: 180.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: bars
                  .map(
                    (value) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Align(
                          alignment: AlignmentDirectional.bottomCenter,
                          child: Container(
                            height: (value * 160).h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.r),
                              gradient: const LinearGradient(
                                colors: [AppColors.electricBlue, AppColors.metallicGold],
                                begin: AlignmentDirectional.bottomCenter,
                                end: AlignmentDirectional.topCenter,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
