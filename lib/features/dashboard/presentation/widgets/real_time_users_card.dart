import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/theme/app_spacing.dart';

class RealTimeUsersCard extends StatelessWidget {
  const RealTimeUsersCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Users in last 30 minutes',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '21.5K',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontSize: 28.sp,
                          ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
                  onPressed: () {},
                ),
              ],
            ),
            AppSpacing.v10,
            Text(
              'Users per minute',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            AppSpacing.v10,
            SizedBox(
              height: 40.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(30, (index) {
                  final height = (index % 5 + 2) * 5.h;
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 1.w),
                      height: height,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
