import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';
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
      width: _isCollapsed ? 70 : 260,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: _isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
              children: [
                if (!_isCollapsed)
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.dashboard, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Flexible(
                          child: Text(
                            'Dashboard',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
          const SizedBox(height: 25),
          
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
                    _NavItem(Icons.category_rounded, 'Categories', 'categories'),
                    _NavItem(Icons.rate_review_outlined, 'Product Reviews', 'reviews'),
                  ]),
                ],
              ),
            ),
          ),
          
          const Divider(),
          const SizedBox(height: 10),
          // User Profile
          _buildUserInfo(),
          const SizedBox(height: 10),
          if (!_isCollapsed)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: Color(0xFFD1D5DB)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.open_in_new, size: 16),
                    SizedBox(width: 8),
                    Expanded(child: Text('Your Shop', maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ],
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
      return const Center(
        child: CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.background,
          child: Icon(Icons.person_outline, color: AppColors.textSecondary),
        ),
      );
    }
    return Row(
      children: [
        const CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.background,
          child: Icon(Icons.person_outline, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Dealport',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.logout, size: 18),
          onPressed: () {
            context.read<AuthCubit>().logout();
            Navigator.of(context).pushReplacementNamed('/login');
          },
        ),
      ],
    );
  }

  Widget _buildHeader(String title) {
    if (_isCollapsed) return const SizedBox(height: 20);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 11,
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
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Stack(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 0 : 16, vertical: 13),
                alignment: isCollapsed ? Alignment.center : Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: active ? AppColors.primary.withValues(alpha: 0.12) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      size: 20,
                      color: active ? AppColors.primary : AppColors.textSecondary,
                    ),
                    if (!isCollapsed) ...[
                      const SizedBox(width: 14),
                      Flexible(
                        child: Text(
                          item.label,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
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
