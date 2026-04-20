import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/theme/app_colors.dart';

class CategoriesTable extends StatelessWidget {
  const CategoriesTable({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = <_CategoryItem>[
      _CategoryItem('electronics', 184),
      _CategoryItem('fashion', 129),
      _CategoryItem('accessories', 77),
      _CategoryItem('category', 42),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.slate,
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
          dataTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13.sp,
          ),
          columns: [
            DataColumn(label: Text('category_name'.tr())),
            DataColumn(label: Text('items_count'.tr())),
            DataColumn(label: Text('status'.tr())),
          ],
          rows: categories
              .map(
                (item) => DataRow(
                  cells: [
                    DataCell(Text(item.nameKey.tr())),
                    DataCell(Text('${item.count}')),
                    DataCell(
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text('active_categories'.tr(), style: TextStyle(fontSize: 12.sp)),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _CategoryItem {
  const _CategoryItem(this.nameKey, this.count);

  final String nameKey;
  final int count;
}
