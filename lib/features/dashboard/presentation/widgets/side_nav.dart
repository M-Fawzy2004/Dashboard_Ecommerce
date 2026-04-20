import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/theme/app_colors.dart';

class SideNav extends StatelessWidget {
  const SideNav({
    super.key,
    required this.activeKey,
    this.onItemTap,
  });

  final String activeKey;
  final ValueChanged<String>? onItemTap;

  @override
  Widget build(BuildContext context) {
    final items = <_NavItem>[
      _NavItem(Icons.home_rounded, 'home'),
      _NavItem(Icons.category_rounded, 'categories'),
      _NavItem(Icons.receipt_long_rounded, 'orders'),
      _NavItem(Icons.group_rounded, 'customers'),
      _NavItem(Icons.settings_rounded, 'settings'),
      _NavItem(Icons.inventory_2_rounded, 'products'),
      _NavItem(Icons.add_box_rounded, 'add_products'),
    ];

    return Container(
      width: 240.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColors.slate.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Text(
            'app_title'.tr(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.metallicGold,
                ),
          ),
          SizedBox(height: 24.h),
          ...items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: _SideNavTile(
                item: item,
                active: item.labelKey == activeKey,
                onTap: () => onItemTap?.call(item.labelKey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SideNavTile extends StatelessWidget {
  const _SideNavTile({
    required this.item,
    required this.active,
    required this.onTap,
  });

  final _NavItem item;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          color: active ? AppColors.electricBlue.withValues(alpha: 0.15) : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              color: active ? AppColors.electricBlue : AppColors.textSecondary,
              size: 20.sp,
            ),
            SizedBox(width: 10.w),
            Text(
              item.labelKey.tr(),
              style: TextStyle(
                fontSize: 14.sp,
                color: active ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.icon, this.labelKey);

  final IconData icon;
  final String labelKey;
}
