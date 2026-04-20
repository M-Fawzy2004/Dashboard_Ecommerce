import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/theme/app_colors.dart';

class CategoriesProductsPanel extends StatelessWidget {
  const CategoriesProductsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final products = <_ProductRow>[
      _ProductRow('wireless_bluetooth_headphones', '01-01-2025', 25),
      _ProductRow('mens_t_shirt', '01-01-2025', 20),
      _ProductRow('mens_leather_wallet', '01-01-2025', 35),
      _ProductRow('memory_foam_pillow', '01-01-2025', 40),
      _ProductRow('coffee_maker', '01-01-2025', 45),
      _ProductRow('casual_baseball_cap', '01-01-2025', 55),
      _ProductRow('full_hd_webcam', '01-01-2025', 20),
      _ProductRow('smart_led_color_bulb', '01-01-2025', 16),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _tab('all_product_with_count', true),
              SizedBox(width: 8.w),
              _tab('featured_products', false),
              SizedBox(width: 8.w),
              _tab('on_sale', false),
              SizedBox(width: 8.w),
              _tab('out_of_stock', false),
              const Spacer(),
              SizedBox(
                width: 240.w,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'search_product'.tr(),
                    hintStyle: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                    prefixIcon: Icon(Icons.search_rounded, size: 18.sp),
                    filled: true,
                    fillColor: const Color(0xFFF7FAFF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              _iconBtn(Icons.filter_alt_outlined),
              SizedBox(width: 8.w),
              _iconBtn(Icons.add),
              SizedBox(width: 8.w),
              _iconBtn(Icons.more_horiz_rounded),
            ],
          ),
          SizedBox(height: 12.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(const Color(0xFFEDF6EA)),
              headingTextStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
              dataTextStyle: TextStyle(fontSize: 12.sp, color: AppColors.textPrimary),
              columns: [
                DataColumn(label: Text('no_label'.tr())),
                DataColumn(label: Text('product_list_title'.tr())),
                DataColumn(label: Text('created_date'.tr())),
                DataColumn(label: Text('order'.tr())),
                DataColumn(label: Text('action'.tr())),
              ],
              rows: List<DataRow>.generate(products.length, (index) {
                final item = products[index];
                return DataRow(
                  cells: [
                    DataCell(Text('${index + 1}')),
                    DataCell(
                      Row(
                        children: [
                          Container(
                            width: 24.w,
                            height: 24.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF1FF),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Icon(Icons.inventory_2_outlined, size: 14.sp),
                          ),
                          SizedBox(width: 8.w),
                          SizedBox(width: 170.w, child: Text(item.productKey.tr())),
                        ],
                      ),
                    ),
                    DataCell(Text(item.date)),
                    DataCell(Text('${item.order}')),
                    DataCell(
                      Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 16.sp, color: AppColors.textSecondary),
                          SizedBox(width: 8.w),
                          Icon(Icons.delete_outline, size: 16.sp, color: AppColors.textSecondary),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab(String key, bool selected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFE8F4E9) : const Color(0xFFF4F7FC),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        key.tr(),
        style: TextStyle(fontSize: 12.sp, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _iconBtn(IconData icon) {
    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
      ),
      child: Icon(icon, size: 16.sp),
    );
  }
}

class _ProductRow {
  const _ProductRow(this.productKey, this.date, this.order);

  final String productKey;
  final String date;
  final int order;
}
