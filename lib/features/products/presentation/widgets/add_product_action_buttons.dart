import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';

class AddProductActionButtons extends StatelessWidget {
  const AddProductActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h),
      child: SizedBox(
        width: double.infinity,
        height: 60.h,
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.rocket_launch_rounded, size: 18.sp),
          label: Text(
            'Publish Product',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: AppColors.primary.withValues(alpha: 0.3),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ),
      ),
    );
  }
}
