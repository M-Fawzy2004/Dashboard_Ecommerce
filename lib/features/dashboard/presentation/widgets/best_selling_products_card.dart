import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/theme/app_spacing.dart';

class BestSellingProductsCard extends StatelessWidget {
  const BestSellingProductsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final products = [
      {'name': 'Apple iPhone 13', 'total': '104', 'status': 'Stock', 'price': r'$999.00'},
      {'name': 'Nike Air Jordan', 'total': '56', 'status': 'Stock out', 'price': r'$999.00'},
      {'name': 'T-shirt', 'total': '266', 'status': 'Stock', 'price': r'$999.00'},
      {'name': 'Cross Bag', 'total': '506', 'status': 'Stock', 'price': r'$999.00'},
    ];

    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12.w,
              runSpacing: 12.h,
              children: [
                Text('Best selling product', style: Theme.of(context).textTheme.titleMedium),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Filter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                ),
              ],
            ),
            AppSpacing.v20,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: 650.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 650.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9).withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                      child: Row(
                        children: [
                          Expanded(flex: 3, child: Text('PRODUCT', style: _headerStyle)),
                          Expanded(flex: 2, child: Text('TOTAL ORDER', style: _headerStyle)),
                          Expanded(flex: 2, child: Text('STATUS', style: _headerStyle)),
                          Expanded(flex: 2, child: Text('PRICE', style: _headerStyle, textAlign: TextAlign.end)),
                        ],
                      ),
                    ),
                    ...products.map((p) => Container(
                          width: 650.w,
                          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 32.w,
                                      height: 32.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4.r),
                                        border: Border.all(color: AppColors.divider),
                                      ),
                                      child: Icon(Icons.image, size: 16.sp, color: AppColors.textSecondary),
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(child: Text(p['name']!, style: _cellStyle, overflow: TextOverflow.ellipsis)),
                                  ],
                                ),
                              ),
                              Expanded(flex: 2, child: Text(p['total']!, style: _cellStyle)),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 6.w,
                                      height: 6.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: p['status'] == 'Stock' ? AppColors.success : AppColors.error,
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(p['status']!, style: _cellStyle),
                                  ],
                                ),
                              ),
                              Expanded(flex: 2, child: Text(p['price']!, style: _cellStyle.copyWith(fontWeight: FontWeight.w700), textAlign: TextAlign.end)),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
            AppSpacing.v20,
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accent,
                  side: const BorderSide(color: Color(0xFFD1D5DB)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                child: const Text('Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle get _headerStyle => TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 0.5,
      );

  TextStyle get _cellStyle => TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );
}
