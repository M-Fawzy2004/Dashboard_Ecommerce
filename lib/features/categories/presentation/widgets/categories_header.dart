import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/theme/app_colors.dart';

class CategoriesHeader extends StatelessWidget {
  const CategoriesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          colors: [AppColors.background, Color(0xFFE8F0FF)],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('categories_title'.tr(), style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: 8.h),
          Text('categories_subtitle'.tr(), style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
