import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    bool isError = false,
  }) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    // Clear previous snackbars
    scaffoldMessenger.removeCurrentSnackBar();

    scaffoldMessenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: const Duration(seconds: 4),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100.h,
          right: 24.w,
          left: MediaQuery.of(context).size.width > 600 
              ? MediaQuery.of(context).size.width - 344.w 
              : 24.w,
        ),
        content: Container(
          height: 64.h,
          width: 320.w,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A24), // Darker premium color
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isError 
                  ? AppColors.error.withOpacity(0.3) 
                  : AppColors.primary.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: (isError ? AppColors.error : AppColors.primary).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
                  color: isError ? AppColors.error : AppColors.primary,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: () => scaffoldMessenger.hideCurrentSnackBar(),
                icon: Icon(Icons.close_rounded, color: Colors.white.withOpacity(0.3), size: 18.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) => show(context, message: message, isError: false);
  static void showError(BuildContext context, String message) => show(context, message: message, isError: true);
}
