import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/theme/app_colors.dart';

class ProductBasicFormCard extends StatelessWidget {
  const ProductBasicFormCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.slate,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: AppColors.electricBlue.withValues(alpha: 0.06),
            blurRadius: 24.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('basic_details', Icons.article_outlined),
          SizedBox(height: 12.h),
          _fieldLabel('product_name'),
          _inputBox('iPhone 15'),
          SizedBox(height: 12.h),
          _fieldLabel('product_description'),
          _multiInputBox(
            'The iPhone 15 delivers cutting-edge performance with the A16 Bionic chip, an immersive display, and advanced dual-camera system.',
          ),
          SizedBox(height: 16.h),
          _sectionTitle('pricing', Icons.payments_outlined),
          SizedBox(height: 12.h),
          _fieldLabel('product_price'),
          _priceRow(),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('discounted_price'),
                    _inputBox('\$99'),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('tax_included'),
                    _radioArea(),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _fieldLabel('expiration'),
          Row(
            children: [
              Expanded(child: _inputBox('start'.tr(), icon: Icons.calendar_today_outlined)),
              SizedBox(width: 10.w),
              Expanded(child: _inputBox('end'.tr(), icon: Icons.calendar_today_outlined)),
            ],
          ),
          SizedBox(height: 16.h),
          _sectionTitle('inventory', Icons.inventory_2_outlined),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('stock_quantity'),
                    _inputBox('unlimited'.tr()),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('stock_status'),
                    _inputBox('in_stock_status'.tr(), icon: Icons.keyboard_arrow_down_rounded),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Switch(value: true, onChanged: (_) {}),
              Text('unlimited'.tr(), style: TextStyle(fontSize: 13.sp)),
            ],
          ),
          Row(
            children: [
              Icon(Icons.check_box, color: const Color(0xFF4CB87B), size: 18.sp),
              SizedBox(width: 6.w),
              Text(
                'highlight_featured'.tr(),
                style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                  side: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
                ),
                child: Text('save_to_draft'.tr()),
              ),
              SizedBox(width: 8.w),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CB87B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                ),
                child: Text('publish_product'.tr()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String key, IconData icon) {
    return Row(
      children: [
        Container(
          width: 30.w,
          height: 30.w,
          decoration: BoxDecoration(
            color: AppColors.electricBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, size: 16.sp, color: AppColors.electricBlue),
        ),
        SizedBox(width: 8.w),
        Text(
          key.tr(),
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
        ),
      ],
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

  Widget _inputBox(String value, {IconData? icon}) {
    return Container(
      height: 42.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 13.sp, color: AppColors.textPrimary),
            ),
          ),
          if (icon != null) Icon(icon, size: 16.sp, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  Widget _multiInputBox(String value) {
    return Container(
      height: 92.h,
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Text(value, style: TextStyle(fontSize: 12.sp, height: 1.4)),
    );
  }

  Widget _priceRow() {
    return Container(
      height: 42.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          const Text('\$999.89'),
          const Spacer(),
          const Text('🇺🇸'),
          SizedBox(width: 4.w),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
        ],
      ),
    );
  }

  Widget _radioArea() {
    return Container(
      height: 42.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Icon(Icons.radio_button_checked, size: 16.sp, color: AppColors.electricBlue),
          SizedBox(width: 4.w),
          Text('yes'.tr(), style: TextStyle(fontSize: 12.sp)),
          SizedBox(width: 10.w),
          Icon(Icons.radio_button_off, size: 16.sp, color: AppColors.textSecondary),
          SizedBox(width: 4.w),
          Text('no'.tr(), style: TextStyle(fontSize: 12.sp)),
        ],
      ),
    );
  }
}
