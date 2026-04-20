import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/theme/app_colors.dart';

class CategoriesTopBar extends StatelessWidget {
  const CategoriesTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'categories'.tr(),
          style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        SizedBox(
          width: 340.w,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'search_global'.tr(),
              hintStyle: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
              prefixIcon: Icon(Icons.search_rounded, size: 18.sp),
              filled: true,
              fillColor: AppColors.card,
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24.r),
                borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.07)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24.r),
                borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.07)),
              ),
            ),
          ),
        ),
        SizedBox(width: 14.w),
        Container(
          width: 34.w,
          height: 34.w,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(Icons.notifications_none_rounded, size: 18.sp),
        ),
        SizedBox(width: 8.w),
        Container(
          width: 34.w,
          height: 34.w,
          decoration: BoxDecoration(
            color: const Color(0xFFE7F6EC),
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Icon(Icons.settings_outlined, size: 17.sp),
        ),
        SizedBox(width: 10.w),
        CircleAvatar(
          radius: 17.r,
          backgroundColor: const Color(0xFFCBD5E1),
          child: Icon(Icons.person, size: 17.sp, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
