import 'package:dashboard_ecommerce/shared/widgets/hover_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddProductActionButtons extends StatelessWidget {
  const AddProductActionButtons({
    super.key,
    required this.onPublish,
    this.isLoading = false,
    this.label = 'Publish Product',
  });

  final VoidCallback onPublish;
  final bool isLoading;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: HoverButton(
        onTap: isLoading ? () {} : onPublish,
        borderRadius: 16.r,
        active: true,
        activeColor: Colors.white.withOpacity(0.08),
        child: Container(
          width: double.infinity,
          height: 56.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.08),
                Colors.white.withOpacity(0.04),
              ],
            ),
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        label.contains('Update') ? Icons.check_circle_outline_rounded : Icons.rocket_launch_rounded,
                        size: 20.sp,
                        color: Colors.white,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
