import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/theme/app_spacing.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

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
    return Container(
      width: 260.w,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border(right: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Branding
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: const Icon(Icons.dashboard, color: Colors.white, size: 20),
                ),
                SizedBox(width: 12.w),
                const Text(
                  'Dashboard',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
              ],
            ),
          ),
          AppSpacing.v25,
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection([
                    _NavItem(Icons.grid_view_rounded, 'Dashboard', 'home'),
                    _NavItem(Icons.shopping_cart_outlined, 'order_management'.tr(), 'orders'),
                    _NavItem(Icons.people_outline, 'customers'.tr(), 'customers'),
                    _NavItem(Icons.confirmation_number_outlined, 'coupon_code'.tr(), 'coupons'),
                    _NavItem(Icons.category_outlined, 'categories'.tr(), 'categories'),
                    _NavItem(Icons.swap_horiz_outlined, 'transaction'.tr(), 'transactions'),
                    _NavItem(Icons.workspace_premium_outlined, 'brand'.tr(), 'brands'),
                  ]),
                  
                  _buildHeader('product_list_title'.tr()),
                  _buildSection([
                    _NavItem(Icons.add_box_outlined, 'add_products'.tr(), 'add_products'),
                    _NavItem(Icons.perm_media_outlined, 'product_media'.tr(), 'product_media'),
                    _NavItem(Icons.list_alt_outlined, 'product_list'.tr(), 'product_list'),
                    _NavItem(Icons.rate_review_outlined, 'product_reviews'.tr(), 'product_reviews'),
                  ]),
                  
                  _buildHeader('admin_role'.tr()),
                  _buildSection([
                    _NavItem(Icons.admin_panel_settings_outlined, 'admin_role'.tr(), 'admin_role'),
                    _NavItem(Icons.security_outlined, 'control_authority'.tr(), 'control_authority'),
                  ]),
                ],
              ),
            ),
          ),
          
          const Divider(),
          AppSpacing.v10,
          // User Profile
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
            leading: CircleAvatar(
              radius: 18.r,
              backgroundColor: AppColors.background,
              child: const Icon(Icons.person_outline, color: AppColors.textSecondary),
            ),
            title: Text(
              'Dealport',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              'Mark@thedesigner...',
              style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.logout, size: 18),
              onPressed: () {
                context.read<AuthCubit>().logout();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ),
          AppSpacing.v10,
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.open_in_new, size: 16),
              label: Text('your_shop'.tr()),
              style: OutlinedButton.styleFrom(
                alignment: Alignment.centerLeft,
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: Color(0xFFD1D5DB)),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildSection(List<_NavItem> items) {
    return Column(
      children: items.map((item) => _SideNavTile(
        item: item,
        active: item.key == activeKey,
        onTap: () => onItemTap?.call(item.key),
      )).toList(),
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Icon(
                item.icon,
                size: 20.sp,
                color: active ? Colors.white : AppColors.textSecondary,
              ),
              SizedBox(width: 12.w),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                  color: active ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.icon, this.label, this.key);

  final IconData icon;
  final String label;
  final String key;
}
