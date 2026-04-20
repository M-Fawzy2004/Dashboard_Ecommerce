import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class EnhancedKpiCard extends StatelessWidget {
  const EnhancedKpiCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.value,
    this.trend,
    this.isPositive = true,
    this.previousValue,
    this.isMultiValue = false,
    this.multiValues,
    this.onDetailsPressed,
    this.showDetailsButton = true,
  });

  final String title;
  final String subtitle;
  final String? value;
  final String? trend;
  final bool isPositive;
  final String? previousValue;
  final bool isMultiValue;
  final List<Map<String, String>>? multiValues;
  final VoidCallback? onDetailsPressed;
  final bool showDetailsButton;

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
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.more_vert, color: AppColors.textSecondary, size: 20),
                  onPressed: () {},
                ),
              ],
            ),
            AppSpacing.v20,
            if (!isMultiValue) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    value!,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontSize: 28.sp,
                          color: AppColors.textPrimary,
                        ),
                  ),
                  SizedBox(width: 12.w),
                  if (trend != null)
                    Row(
                      children: [
                        Icon(
                          isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                          color: isPositive ? AppColors.success : AppColors.error,
                          size: 14.sp,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          trend!,
                          style: TextStyle(
                            color: isPositive ? AppColors.success : AppColors.error,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              if (previousValue != null) ...[
                SizedBox(height: 8.h),
                Text(
                  previousValue!,
                  style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                ),
              ],
            ] else ...[
              Row(
                children: multiValues!.map((mv) {
                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(mv['label']!, style: Theme.of(context).textTheme.bodySmall),
                        Row(
                          children: [
                            Text(
                              mv['value']!,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22.sp,
                                  ),
                            ),
                            if (mv.containsKey('trend')) ...[
                              SizedBox(width: 4.w),
                              Icon(
                                mv['trend'] == 'up' ? Icons.arrow_upward : Icons.arrow_downward,
                                color: mv['trend'] == 'up' ? AppColors.success : AppColors.error,
                                size: 14.sp,
                              ),
                              Text(
                                mv['sub']!,
                                style: TextStyle(
                                  color: mv['trend'] == 'up' ? AppColors.success : AppColors.error,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ] else if (mv.containsKey('sub')) ...[
                              SizedBox(width: 4.w),
                              Text(
                                mv['sub']!,
                                style: TextStyle(
                                  color: AppColors.success,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
            if (showDetailsButton) ...[
              AppSpacing.v20,
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  onPressed: onDetailsPressed,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    side: const BorderSide(color: Color(0xFFD1D5DB)),
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: const Text('Details'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
