import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';

class OrdersHeader extends StatelessWidget {
  const OrdersHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Order List',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 24.sp,
              ),
        ),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_circle_outline, size: 20),
              label: const Text('Add Order'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
            ),
            SizedBox(width: 12.w),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.more_vert, size: 20),
              label: const Text('More Action'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: Color(0xFFD1D5DB)),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

