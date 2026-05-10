import 'package:dashboard_ecommerce/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../products/presentation/cubit/products_cubit.dart';

class QuickInventoryCard extends StatelessWidget {
  const QuickInventoryCard({super.key, this.onAddProduct, this.onSeeMore});
  final VoidCallback? onAddProduct;
  final VoidCallback? onSeeMore;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quick Inventory',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              _HoverButton(
                onTap: onAddProduct ?? () {},
                borderRadius: 20,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_rounded,
                        size: 12.sp,
                        color: Colors.white.withOpacity(0.4),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Add New',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),
          Divider(color: Colors.white.withOpacity(0.06)),
          SizedBox(height: 16.h),

          // ── Categories ──
          _SectionLabel(label: 'Categories'),
          SizedBox(height: 10.h),
          _buildCategoryList(),
          SizedBox(height: 6.h),
          Center(
            child: _HoverButton(
              onTap: onSeeMore ?? () {},
              borderRadius: 20,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                child: Text(
                  'See more',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.25),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 16.h),
          Divider(color: Colors.white.withOpacity(0.06)),
          SizedBox(height: 16.h),

          // ── Products ──
          _SectionLabel(label: 'Products'),
          SizedBox(height: 10.h),
          _buildProductList(context),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        if (state.isLoading) {
          return LinearProgressIndicator(
            backgroundColor: Colors.white.withOpacity(0.04),
            color: Colors.white.withOpacity(0.15),
          );
        }
        final categories = state.categories.take(3).toList();
        return Column(
          children: categories
              .map((cat) => _CategoryItem(name: cat.label, icon: cat.icon))
              .toList(),
        );
      },
    );
  }

  Widget _buildProductList(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state.status == ProductsStatus.loading) {
          return LinearProgressIndicator(
            backgroundColor: Colors.white.withOpacity(0.04),
            color: Colors.white.withOpacity(0.15),
          );
        }
        final products = state.items.take(3).toList();
        return Column(
          children: products
              .map(
                (prod) => _ProductItem(
                  name: prod.name,
                  price: '\$${prod.price}',
                  imageUrl:
                      prod.mainImageUrl ??
                      (prod.imageUrls.isNotEmpty ? prod.imageUrls.first : null),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w700,
        color: Colors.white.withOpacity(0.25),
        letterSpacing: 2,
      ),
    );
  }
}

// ─── Category Item ────────────────────────────────────────────────────────────

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({required this.name, required this.icon});
  final String name;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: _HoverButton(
        onTap: () {},
        borderRadius: 12,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(0.05)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Colors.white.withOpacity(0.4),
                  size: 16,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withOpacity(0.2),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Product Item ─────────────────────────────────────────────────────────────

class _ProductItem extends StatelessWidget {
  const _ProductItem({required this.name, required this.price, this.imageUrl});
  final String name;
  final String price;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: _HoverButton(
        onTap: () {},
        borderRadius: 12,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(10),
                  image: imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: imageUrl == null
                    ? Icon(
                        Icons.image_outlined,
                        color: Colors.white.withOpacity(0.2),
                        size: 18,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      price,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.35),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              _HoverButton(
                onTap: () {},
                borderRadius: 8,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.07),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.add_rounded,
                    color: Colors.white.withOpacity(0.5),
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Hover Button ─────────────────────────────────────────────────────────────

class _HoverButton extends StatefulWidget {
  const _HoverButton({
    required this.child,
    required this.onTap,
    this.borderRadius = 10,
  });

  final Widget child;
  final VoidCallback onTap;
  final double borderRadius;

  @override
  State<_HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<_HoverButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          transform: Matrix4.identity()..scale(_pressed ? 0.97 : 1.0),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            color: _hovered
                ? Colors.white.withOpacity(0.04)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
