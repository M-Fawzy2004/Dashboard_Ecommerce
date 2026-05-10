import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';

class ProductFormSection extends StatelessWidget {
  const ProductFormSection({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.trailing,
  });

  final String title;
  final IconData icon;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, size: 18.sp, color: Colors.white.withOpacity(0.4)),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          SizedBox(height: 20.h),
          Divider(color: Colors.white.withOpacity(0.06), height: 1),
          SizedBox(height: 20.h),
          child,
        ],
      ),
    );
  }
}

class ProductFormLabel extends StatelessWidget {
  const ProductFormLabel(this.text, {super.key, this.isOptional = false});
  final String text;
  final bool isOptional;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Text(
            text.toUpperCase(),
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white.withOpacity(0.25),
              letterSpacing: 1.5,
            ),
          ),
          if (isOptional) ...[
            SizedBox(width: 6.w),
            Text(
              '(OPTIONAL)',
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.15),
                letterSpacing: 1,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
