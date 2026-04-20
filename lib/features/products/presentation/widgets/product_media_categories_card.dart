import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/theme/app_colors.dart';

class ProductMediaCategoriesCard extends StatelessWidget {
  const ProductMediaCategoriesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.slate,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'upload_product_image'.tr(),
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
            ),
            child: Column(
              children: [
                _fieldLabel('product_name'),
                SizedBox(height: 8.h),
                Container(
                  height: 132.h,
                  width: 130.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: const Color(0xFFF2F5FA),
                  ),
                  child: const Icon(Icons.phone_iphone_rounded, size: 64),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(child: _smallButton('browse', Icons.image_outlined)),
                    SizedBox(width: 8.w),
                    Expanded(child: _smallButton('replace', Icons.refresh_rounded)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(child: _thumbBox(Icons.phone_iphone_rounded)),
              SizedBox(width: 8.w),
              Expanded(child: _thumbBox(Icons.smartphone_rounded)),
              SizedBox(width: 8.w),
              Expanded(
                child: Container(
                  height: 58.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: AppColors.textSecondary.withValues(alpha: 0.45),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'add_image'.tr(),
                      style: TextStyle(fontSize: 12.sp, color: const Color(0xFF4CB87B)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Text(
            'category'.tr(),
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 10.h),
          _fieldLabel('product_categories'),
          _dropdownBox(),
          SizedBox(height: 10.h),
          _fieldLabel('product_tag'),
          _dropdownBox(),
          SizedBox(height: 10.h),
          _fieldLabel('select_your_color'),
          SizedBox(height: 8.h),
          Row(
            children: const [
              _ColorDot(Color(0xFFC8DEBB)),
              _ColorDot(Color(0xFFE0C9CD)),
              _ColorDot(Color(0xFFCCD6DB)),
              _ColorDot(Color(0xFFE1DBBE)),
              _ColorDot(Color(0xFF434A51)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String key) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text(
        key.tr(),
        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _smallButton(String key, IconData icon) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 14.sp),
      label: Text(key.tr(), style: TextStyle(fontSize: 12.sp)),
      style: OutlinedButton.styleFrom(
        minimumSize: Size(100.w, 34.h),
        side: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
      ),
    );
  }

  Widget _thumbBox(IconData icon) {
    return Container(
      height: 58.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F5FA),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(child: Icon(icon, size: 22.sp)),
    );
  }

  Widget _dropdownBox() {
    return Container(
      height: 42.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Text(
            'select_your_product'.tr(),
            style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
          ),
          const Spacer(),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
        ],
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot(this.color);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: 10.w),
      child: Container(
        width: 34.w,
        height: 34.w,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }
}
