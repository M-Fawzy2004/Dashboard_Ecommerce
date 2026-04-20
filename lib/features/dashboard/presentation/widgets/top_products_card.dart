import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/theme/app_spacing.dart';

class TopProductsCard extends StatelessWidget {
  const TopProductsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final products = [
      {'name': 'Apple iPhone 13', 'id': 'Item: #FKZ-4567', 'price': r'$999.00', 'image': Icons.phone_iphone},
      {'name': 'Nike Air Jordan', 'id': 'Item: #FKZ-4567', 'price': r'$72.40', 'image': Icons.shopping_bag},
      {'name': 'T-shirt', 'id': 'Item: #FKZ-4567', 'price': r'$35.40', 'image': Icons.checkroom},
      {'name': 'Assorted Cross Bag', 'id': 'Item: #FKZ-4567', 'price': r'$80.00', 'image': Icons.shopping_basket},
    ];

    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Top Products', style: Theme.of(context).textTheme.titleMedium),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'All product',
                    style: TextStyle(fontSize: 11.sp, color: AppColors.accent),
                  ),
                ),
              ],
            ),
            AppSpacing.v10,
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.background,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            AppSpacing.v20,
            ...products.map((p) => Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Row(
                    children: [
                      Container(
                        width: 48.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(p['image'] as IconData, color: AppColors.textSecondary),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p['name'] as String, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.sp)),
                            Text(p['id'] as String, style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                      Text(
                        p['price'] as String,
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
