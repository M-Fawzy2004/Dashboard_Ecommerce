import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/theme/app_spacing.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class SideNav extends StatefulWidget {
  const SideNav({
    super.key,
    required this.activeKey,
    this.onItemTap,
  });

  final String activeKey;
  final ValueChanged<String>? onItemTap;

  @override
  State<SideNav> createState() => _SideNavState();
}

class _SideNavState extends State<SideNav> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      width: _isCollapsed ? 80.w : 260.w,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border(right: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Branding & Toggle
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: _isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
              children: [
                if (!_isCollapsed)
                  Expanded(
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
                        const Flexible(
                          child: Text(
                            'Dashboard',
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.clip,
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                IconButton(
                  icon: Icon(_isCollapsed ? Icons.menu_open_rounded : Icons.menu_rounded),
                  color: AppColors.textPrimary,
                  onPressed: () => setState(() => _isCollapsed = !_isCollapsed),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          AppSpacing.v25,
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: _isCollapsed ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                children: [
                  _buildSection([
                    _NavItem(Icons.grid_view_rounded, 'Dashboard', 'home'),
                    _NavItem(Icons.shopping_cart_outlined, 'Order Management', 'orders'),
                  ]),
                  
                  _buildHeader('PRODUCT MANAGEMENT'),
                  _buildSection([
                    _NavItem(Icons.add_box_outlined, 'Add Products', 'add_products'),
                    _NavItem(Icons.list_alt_outlined, 'Product List', 'product_list'),
                    _NavItem(Icons.rate_review_outlined, 'Product Reviews', 'product_reviews'),
                  ]),
                ],
              ),
            ),
          ),
          
          const Divider(),
          AppSpacing.v10,
          // User Profile
          _buildUserInfo(),
          AppSpacing.v10,
          if (!_isCollapsed)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.open_in_new, size: 16),
                label: const Text('Your Shop'),
                style: OutlinedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: Color(0xFFD1D5DB)),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
              ),
            )
          else
            Center(
              child: IconButton(
                icon: const Icon(Icons.open_in_new, size: 20),
                onPressed: () {},
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    if (_isCollapsed) {
      return Center(
        child: CircleAvatar(
          radius: 18.r,
          backgroundColor: AppColors.background,
          child: const Icon(Icons.person_outline, color: AppColors.textSecondary),
        ),
      );
    }
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
      leading: CircleAvatar(
        radius: 18.r,
        backgroundColor: AppColors.background,
        child: const Icon(Icons.person_outline, color: AppColors.textSecondary),
      ),
      title: Text(
        'Dealport',
        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.logout, size: 18),
        onPressed: () {
          context.read<AuthCubit>().logout();
          Navigator.of(context).pushReplacementNamed('/login');
        },
      ),
    );
  }

  Widget _buildHeader(String title) {
    if (_isCollapsed) return const SizedBox(height: 20);
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w800,
          color: AppColors.textSecondary.withValues(alpha: 0.5),
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildSection(List<_NavItem> items) {
    return Column(
      children: items.map((item) => _SideNavTile(
        item: item,
        active: item.key == widget.activeKey,
        isCollapsed: _isCollapsed,
        onTap: () {
          if (item.key == widget.activeKey) return; 
          widget.onItemTap?.call(item.key);
        },
      )).toList(),
    );
  }
}

class _SideNavTile extends StatelessWidget {
  const _SideNavTile({
    required this.item,
    required this.active,
    required this.onTap,
    required this.isCollapsed,
  });

  final _NavItem item;
  final bool active;
  final VoidCallback onTap;
  final bool isCollapsed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Stack(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(10.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 0 : 16.w, vertical: 13.h),
                alignment: isCollapsed ? Alignment.center : Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: active ? AppColors.primary.withValues(alpha: 0.12) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
                  children: [
                    Icon(
                      item.icon,
                      size: 20.sp,
                      color: active ? AppColors.primary : AppColors.textSecondary,
                    ),
                    if (!isCollapsed) ...[
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Text(
                          item.label,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                            color: active ? AppColors.primary : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (active)
            Positioned(
              left: 2.w,
              top: 12.h,
              bottom: 12.h,
              child: Container(
                width: 4.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 4,
                      offset: const Offset(1, 0),
                    ),
                  ],
                ),
              ),
            ),
        ],
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
