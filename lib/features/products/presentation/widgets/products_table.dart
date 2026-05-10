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
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(Colors.white.withOpacity(0.02)),
          horizontalMargin: 20.w,
          columnSpacing: 40.w,
          headingTextStyle: TextStyle(
            color: Colors.white.withOpacity(0.3),
            fontSize: 11.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
          dataTextStyle: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.w500),
          columns: [
            DataColumn(label: Text('SKU'.toUpperCase())),
            DataColumn(label: Text('PRODUCT NAME'.toUpperCase())),
            DataColumn(label: Text('CATEGORY'.toUpperCase())),
            DataColumn(label: Text('STOCK'.toUpperCase())),
            DataColumn(label: Text('PRICE'.toUpperCase())),
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
        DataCell(Text(item.sku, style: TextStyle(color: Colors.white.withOpacity(0.5)))),
        DataCell(Text(item.name)),
        DataCell(Text(item.categoryKey.tr())),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: stockColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: stockColor.withOpacity(0.2)),
            ),
            child: Text(
              '${item.stock}', 
              style: TextStyle(color: stockColor, fontWeight: FontWeight.w800, fontSize: 12.sp),
            ),
          ),
        ),
        DataCell(Text(item.price, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700))),
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
