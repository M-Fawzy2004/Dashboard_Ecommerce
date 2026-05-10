import 'package:dashboard_ecommerce/shared/widgets/hover_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddProductTopBar extends StatelessWidget {
  const AddProductTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final titleBlock = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New Product',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Fill in the details to list a new product',
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.white.withOpacity(0.35),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );

        if (constraints.maxWidth < 600) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleBlock,
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: _PublishButton(),
              ),
            ],
          );
        }

        return Row(
          children: [
            titleBlock,
            const Spacer(),
            _PublishButton(),
          ],
        );
      },
    );
  }
}

class _PublishButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HoverButton(
      onTap: () {},
      borderRadius: 12.r,
      active: true,
      activeColor: Colors.white.withOpacity(0.08),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.rocket_launch_rounded, size: 16.sp, color: Colors.white),
            SizedBox(width: 10.w),
            Text(
              'Publish Product',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
