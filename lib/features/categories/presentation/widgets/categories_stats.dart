import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/theme/app_colors.dart';

class CategoriesStats extends StatelessWidget {
  const CategoriesStats({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = <_CategoryStat>[
      _CategoryStat('total_categories', '26', Icons.category_rounded, AppColors.accent),
      _CategoryStat('active_categories', '22', Icons.check_circle_rounded, AppColors.success),
      _CategoryStat('empty_categories', '4', Icons.inbox_rounded, AppColors.warning),
    ];

    return Row(
      children: stats
          .map(
            (item) => Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.only(end: 12.w),
                child: Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: item.color.withValues(alpha: 0.25)),
                  ),
                  child: Row(
                    children: [
                      Icon(item.icon, color: item.color, size: 22.sp),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.value, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700)),
                          Text(item.label.tr(), style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _CategoryStat {
  const _CategoryStat(this.label, this.value, this.icon, this.color);

  final String label;
  final String value;
  final IconData icon;
  final Color color;
}
