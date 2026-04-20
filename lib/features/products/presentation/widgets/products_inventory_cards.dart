import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/theme/app_colors.dart';

class ProductsInventoryCards extends StatelessWidget {
  const ProductsInventoryCards({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = <_InventoryCardItem>[
      _InventoryCardItem('total_products', '3,284', Icons.inventory_2_rounded, AppColors.accent),
      _InventoryCardItem('in_stock', '2,942', Icons.check_circle_rounded, AppColors.success),
      _InventoryCardItem('low_stock', '184', Icons.warning_amber_rounded, AppColors.warning),
      _InventoryCardItem('top_selling', '158', Icons.local_fire_department_rounded, AppColors.warning),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 14.w,
        mainAxisSpacing: 14.h,
        childAspectRatio: 1.7,
      ),
      itemBuilder: (_, i) => _InventoryCard(item: cards[i]),
    );
  }
}

class _InventoryCard extends StatelessWidget {
  const _InventoryCard({required this.item});

  final _InventoryCardItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: item.color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(item.icon, color: item.color, size: 22.sp),
          const Spacer(),
          Text(
            item.value,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 5.h),
          Text(item.label.tr(), style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _InventoryCardItem {
  const _InventoryCardItem(this.label, this.value, this.icon, this.color);

  final String label;
  final String value;
  final IconData icon;
  final Color color;
}
