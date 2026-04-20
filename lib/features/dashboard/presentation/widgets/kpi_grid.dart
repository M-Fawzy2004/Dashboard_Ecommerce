import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/theme/app_colors.dart';

class KpiGrid extends StatelessWidget {
  const KpiGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final kpis = <_KpiItem>[
      _KpiItem('total_sales', '\$84,250', Icons.payments_rounded, AppColors.electricBlue),
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
        childAspectRatio: 1.65,
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
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.slate,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(item.icon, color: item.accent, size: 21.sp),
          const Spacer(),
          Text(
            item.value,
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 6.h),
          Text(item.key.tr(), style: Theme.of(context).textTheme.bodyMedium),
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
