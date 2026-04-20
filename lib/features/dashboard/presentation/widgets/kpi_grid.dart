import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/theme/app_colors.dart';

class KpiGrid extends StatelessWidget {
  const KpiGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final kpis = <_KpiItem>[
      _KpiItem('total_sales', r'$84,250', Icons.payments_rounded, AppColors.electricBlue),
      _KpiItem('total_orders', '1,284', Icons.shopping_bag_rounded, AppColors.metallicGold),
      _KpiItem('conversion_rate', '12.7%', Icons.trending_up_rounded, AppColors.success),
      _KpiItem('new_customers', '+324', Icons.group_add_rounded, AppColors.warning),
    ];

    return GridView.builder(
      itemCount: kpis.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, 
        crossAxisSpacing: 14.w,
        mainAxisSpacing: 14.h,
        childAspectRatio: 2.5,
      ),
      itemBuilder: (_, index) => _KpiCard(item: kpis[index]),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.item});

  final _KpiItem item;

  @override
  Widget build(BuildContext context) {
    final accentBg = item.accent.withValues(alpha: 0.1);

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Container(
            padding: EdgeInsets.all(30.r),
            decoration: BoxDecoration(
              color: accentBg,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(item.icon, color: item.accent, size: 18.sp),
          ),

          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon badge
            
          
              // Value
              Text(
                item.value,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
          
              SizedBox(height: 4.h),
          
              // Label
              Text(
                item.key.tr(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 11.sp,
                ),
              ),
          
              SizedBox(height: 6.h),
          
              // Trend badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: accentBg,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_upward_rounded, size: 10.sp, color: item.accent),
                    SizedBox(width: 3.w),
                    Text(
                      '+2.4%',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: item.accent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KpiItem {
  const _KpiItem(this.key, this.value, this.icon, this.accent);

  final String key;
  final String value;
  final IconData icon;
  final Color accent;
}