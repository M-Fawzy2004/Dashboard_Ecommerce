import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';

class AddProductActionButtons extends StatelessWidget {
  const AddProductActionButtons({
    super.key,
    required this.onPublish,
    this.isLoading = false,
  });

  final VoidCallback onPublish;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h),
      child: SizedBox(
        width: double.infinity,
        height: 60.h,
        child: ElevatedButton.icon(
          onPressed: isLoading ? null : onPublish,
          icon: isLoading
              ? SizedBox(
                  width: 18.w,
                  height: 18.h,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: Colors.white,
                  ),
                )
              : Icon(Icons.rocket_launch_rounded, size: 18.sp),
          label: Text(
            isLoading ? 'Publishing...' : 'Publish Product',
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
