import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.deepNavy,
      colorScheme: const ColorScheme.light(
        primary: AppColors.electricBlue,
        secondary: AppColors.metallicGold,
        surface: AppColors.surface,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ).copyWith(
        headlineSmall: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      cardColor: AppColors.slate,
    );
  }
}
