import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/theme/app_spacing.dart';

class AddNewProductCard extends StatelessWidget {
  const AddNewProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Electronic', 'icon': Icons.devices},
      {'name': 'Fashion', 'icon': Icons.checkroom},
      {'name': 'Home', 'icon': Icons.home},
    ];

    final recentItems = [
      {'name': 'Smart Fitness Tracker', 'price': r'$39.99'},
      {'name': 'Leather Wallet', 'price': r'$19.99'},
      {'name': 'Electric Hair Trimmer', 'price': r'$34.99'},
    ];

    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Add New Product', style: Theme.of(context).textTheme.titleMedium),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_circle_outline, size: 16),
                  label: Text('Add New', style: TextStyle(fontSize: 12.sp)),
                  style: TextButton.styleFrom(foregroundColor: AppColors.accent),
                ),
              ],
            ),
            Text('Categories', style: Theme.of(context).textTheme.bodySmall),
            AppSpacing.v10,
            ...categories.map((c) => Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.divider),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: ListTile(
                    visualDensity: VisualDensity.compact,
                    leading: Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Icon(c['icon'] as IconData, size: 20.sp, color: AppColors.textSecondary),
                    ),
                    title: Text(c['name'] as String, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () {},
                  ),
                )),
            Center(
              child: TextButton(
                onPressed: () {},
                child: Text('See more', style: TextStyle(fontSize: 11.sp, color: AppColors.accent)),
              ),
            ),
            AppSpacing.v10,
            Text('Product', style: Theme.of(context).textTheme.bodySmall),
            AppSpacing.v10,
            ...recentItems.map((item) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Row(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: const Icon(Icons.image, color: AppColors.textSecondary),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['name']!, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600)),
                            Text(item['price']!, style: TextStyle(fontSize: 11.sp, color: AppColors.primary, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0),
                          minimumSize: Size(40.w, 24.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
                        ),
                        child: const Icon(Icons.add, size: 14),
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
