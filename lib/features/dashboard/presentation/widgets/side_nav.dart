import 'package:dashboard_ecommerce/shared/widgets/hover_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class SideNav extends StatefulWidget {
  const SideNav({super.key, required this.activeKey, this.onItemTap});

  final String activeKey;
  final ValueChanged<String>? onItemTap;

  @override
  State<SideNav> createState() => _SideNavState();
}

class _SideNavState extends State<SideNav> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260.w,
      decoration: BoxDecoration(
        color: Color(0xFF0A0A0F),
        border: Border(right: BorderSide(color: Color(0xFF1C1C24))),
        borderRadius: BorderRadius.all(Radius.circular(25.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBrandHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection([
                    _NavItem(Icons.grid_view_rounded, 'Dashboard', 'home'),
                    _NavItem(
                      Icons.shopping_cart_outlined,
                      'Order Management',
                      'orders',
                    ),
                  ]),
                  _buildSectionHeader('PRODUCT MANAGEMENT'),
                  _buildSection([
                    _NavItem(
                      Icons.add_box_outlined,
                      'Add Products',
                      'add_products',
                    ),
                    _NavItem(
                      Icons.list_alt_outlined,
                      'Product List',
                      'product_list',
                    ),
                    _NavItem(
                      Icons.category_rounded,
                      'Categories',
                      'categories',
                    ),
                    _NavItem(
                      Icons.rate_review_outlined,
                      'Product Reviews',
                      'reviews',
                    ),
                  ]),
                ],
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildBrandHeader() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF1C1C24))),
      ),
      child: Row(
        children: [
          _BrandIcon(),
          const SizedBox(width: 12),
          const Text(
            'DEALPORT',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 24, 12, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: Color(0xFF3F3F4A),
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildSection(List<_NavItem> items) {
    return Column(
      children: items
          .map(
            (item) => _SideNavTile(
              item: item,
              active: item.key == widget.activeKey,
              onTap: () {
                if (item.key == widget.activeKey) return;
                widget.onItemTap?.call(item.key);
              },
            ),
          )
          .toList(),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF1C1C24))),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _UserAvatar(),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Dealport',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Admin',
                      style: TextStyle(color: Color(0xFF555560), fontSize: 11),
                    ),
                  ],
                ),
              ),
              HoverButton(
                onTap: () {
                  context.read<AuthCubit>().logout();
                  Navigator.of(context).pushReplacementNamed('/login');
                },
                borderRadius: 8,
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Icon(
                    Icons.logout_rounded,
                    size: 15,
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          HoverButton(
            onTap: () {},
            borderRadius: 8,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF1C1C24)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.open_in_new_rounded,
                    size: 14,
                    color: Colors.white.withOpacity(0.35),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Your Shop',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.35),
                      fontWeight: FontWeight.w500,
                    ),
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
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: HoverButton(
        onTap: onTap,
        borderRadius: 16,
        active: active,
        activeColor: Colors.white.withOpacity(0.07),
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: active
                ? Border.all(color: Colors.white.withOpacity(0.08))
                : null,
          ),
          child: Row(
            children: [
              Icon(
                item.icon,
                size: 18,
                color: active ? Colors.white : Colors.white.withOpacity(0.3),
              ),
              const SizedBox(width: 12),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  color: active ? Colors.white : Colors.white.withOpacity(0.35),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.shopping_bag_rounded,
        color: Colors.white,
        size: 16,
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.person_outline,
        color: Colors.white.withOpacity(0.6),
        size: 18,
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
