import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/theme/app_colors.dart';

class AddProductTopBar extends StatelessWidget {
  const AddProductTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFF1F6FF)],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withValues(alpha: 0.08),
            blurRadius: 22.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: AppColors.electricBlue.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.add_box_rounded, color: AppColors.electricBlue, size: 22.sp),
          ),
          SizedBox(width: 10.w),
          Text(
            'add_new_product'.tr(),
            style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          SizedBox(
            width: 320.w,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'search_product_for_add'.tr(),
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: AppColors.slate,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
              backgroundColor: const Color(0xFF4CB87B),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
            ),
            child: Text('publish_product'.tr()),
          ),
          SizedBox(width: 8.w),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.description_outlined, size: 18),
            label: Text('save_to_draft'.tr()),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: BorderSide(color: Colors.black.withValues(alpha: 0.12)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColors.slate,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Colors.black.withValues(alpha: 0.12)),
            ),
            child: const Icon(Icons.add, size: 20),
          ),
        ],
      ),
    );
  }
}
