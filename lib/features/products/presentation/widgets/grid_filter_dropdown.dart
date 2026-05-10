import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GridFilterDropdown extends StatelessWidget {
  const GridFilterDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.icon,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onChanged,
      color: const Color(0xFF1A1A24),
      elevation: 10,
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: Colors.white.withOpacity(0.05)),
      ),
      child: Container(
        height: 52.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16.sp, color: Colors.white.withOpacity(0.3)),
            SizedBox(width: 10.w),
            Text(
              value,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10.w),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18.sp,
              color: Colors.white.withOpacity(0.2),
            ),
          ],
        ),
      ),
      itemBuilder: (_) => items
          .map(
            (item) => PopupMenuItem(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
