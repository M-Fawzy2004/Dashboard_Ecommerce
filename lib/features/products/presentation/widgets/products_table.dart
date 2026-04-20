import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/theme/app_colors.dart';

class ProductsTable extends StatelessWidget {
  const ProductsTable({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_ProductItem>[
      _ProductItem('PRD-2001', 'Noise Cancelling Headphones', 'electronics', 182, '\$199.00'),
      _ProductItem('PRD-1988', 'Sport Sneaker', 'fashion', 74, '\$89.00'),
      _ProductItem('PRD-1964', 'Leather Wallet', 'accessories', 36, '\$49.00'),
      _ProductItem('PRD-1941', 'Portable Speaker', 'electronics', 15, '\$129.00'),
      _ProductItem('PRD-1903', 'Denim Jacket', 'fashion', 9, '\$119.00'),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingTextStyle: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
          dataTextStyle: TextStyle(color: AppColors.textPrimary, fontSize: 13.sp),
          columns: [
            DataColumn(label: Text('sku'.tr())),
            DataColumn(label: Text('products'.tr())),
            DataColumn(label: Text('category'.tr())),
            DataColumn(label: Text('stock'.tr())),
            DataColumn(label: Text('price'.tr())),
          ],
          rows: items.map(_toDataRow).toList(),
        ),
      ),
    );
  }

  DataRow _toDataRow(_ProductItem item) {
    final stockColor = item.stock < 20 ? AppColors.warning : AppColors.success;
    return DataRow(
      cells: [
        DataCell(Text(item.sku)),
        DataCell(Text(item.name)),
        DataCell(Text(item.categoryKey.tr())),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: stockColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text('${item.stock}', style: TextStyle(color: AppColors.textPrimary)),
          ),
        ),
        DataCell(Text(item.price)),
      ],
    );
  }
}

class _ProductItem {
  const _ProductItem(this.sku, this.name, this.categoryKey, this.stock, this.price);

  final String sku;
  final String name;
  final String categoryKey;
  final int stock;
  final String price;
}
