import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';

class CategoryToggleChip extends StatelessWidget {
  const CategoryToggleChip({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: value ? AppColors.primary.withValues(alpha: 0.1) : const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: value
                ? AppColors.primary.withValues(alpha: 0.4)
                : Colors.black.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              value ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              size: 14.sp,
              color: value ? AppColors.primary : AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: value ? FontWeight.w700 : FontWeight.w500,
                color: value ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
