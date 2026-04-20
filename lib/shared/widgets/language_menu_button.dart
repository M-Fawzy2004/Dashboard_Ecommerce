import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

class LanguageMenuButton extends StatelessWidget {
  const LanguageMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      tooltip: 'Language',
      onSelected: context.setLocale,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      icon: Container(
        width: 46.w,
        height: 46.w,
        decoration: BoxDecoration(
          color: AppColors.slate,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.electricBlue.withValues(alpha: 0.22)),
          boxShadow: [
            BoxShadow(
              color: AppColors.electricBlue.withValues(alpha: 0.10),
              blurRadius: 16.r,
              offset: Offset(0, 6.h),
            ),
          ],
        ),
        child: Icon(Icons.language_rounded, size: 22.sp, color: AppColors.electricBlue),
      ),
      itemBuilder: (_) => const [
        PopupMenuItem(value: Locale('en'), child: Text('English')),
        PopupMenuItem(value: Locale('ar'), child: Text('العربية')),
      ],
    );
  }
}
