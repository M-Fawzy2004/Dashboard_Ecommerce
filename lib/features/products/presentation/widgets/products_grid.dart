import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../domain/entities/product_entity.dart';
import '../cubit/products_cubit.dart';
import '../model/category_config.dart';
import '../model/product_model.dart';
import 'grid_filter_dropdown.dart';
import 'product_card.dart';

class ProductsGrid extends StatefulWidget {
  const ProductsGrid({super.key, this.onEdit});
  final ValueChanged<ProductEntity>? onEdit;

  @override
  State<ProductsGrid> createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  String _searchQuery = '';
  String _selectedFilter = 'All';
  String _sortBy = 'Newest';
  CategoryConfig? _activeCategory;

  static const _filters = ['All', 'In Stock', 'Low Stock', 'Out of Stock'];
  static const _sorts = ['Newest', 'Price ↑', 'Price ↓', 'Stock ↑'];

  List<ProductModel> _filtered(List<ProductModel> source) {
    var list = source.where((p) {
      final matchSearch =
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.category.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchFilter =
          _selectedFilter == 'All' || p.status == _selectedFilter;
      final matchCategory =
          _activeCategory == null || p.category == _activeCategory!.label;
      return matchSearch && matchFilter && matchCategory;
    }).toList();

    if (_sortBy == 'Price ↑') list.sort((a, b) => a.price.compareTo(b.price));
    if (_sortBy == 'Price ↓') list.sort((a, b) => b.price.compareTo(a.price));
    if (_sortBy == 'Stock ↑') list.sort((a, b) => a.stock.compareTo(b.stock));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        final products = state.items.isNotEmpty
            ? _filtered(state.items.map(_toUiModel).toList())
            : <ProductModel>[];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategoryFilter(),
            SizedBox(height: 20.h),
            _buildToolbar(products.length),
            SizedBox(height: 20.h),
            if (state.status == ProductsStatus.loading)
              const Center(child: CircularProgressIndicator())
            else if (products.isEmpty)
              _buildEmpty()
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 4;
                  if (constraints.maxWidth < 600) {
                    crossAxisCount = 1;
                  } else if (constraints.maxWidth < 900) {
                    crossAxisCount = 2;
                  } else if (constraints.maxWidth < 1200) {
                    crossAxisCount = 3;
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                      mainAxisExtent: 400.h,
                    ),
                    itemCount: products.length,
                    itemBuilder: (_, i) => ProductCard(
                      product: products[i],
                      onEdit: () {
                        final entity = state.items.firstWhere(
                          (e) => e.id == products[i].id,
                        );
                        widget.onEdit?.call(entity);
                      },
                      onDelete: () => context
                          .read<ProductsCubit>()
                          .deleteProduct(products[i].id),
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }

  ProductModel _toUiModel(ProductEntity entity) {
    final basePrice = entity.price ?? 0;
    final salePrice = entity.salePrice ?? 0;

    // Valid sale only if salePrice is > 0 AND less than base price
    final hasSale = salePrice > 0 && salePrice < basePrice;

    final displayPrice = hasSale ? salePrice : basePrice;
    final originalPrice = hasSale ? basePrice : null;

    final status =
        entity.stockStatus ??
        ((entity.unlimitedStock || (entity.stockQty ?? 0) > 20)
            ? 'In Stock'
            : (entity.stockQty ?? 0) > 0
            ? 'Low Stock'
            : 'Out of Stock');
    return ProductModel(
      id: entity.id,
      name: entity.name,
      category: entity.categoryName ?? 'General',
      brand: entity.sku ?? 'N/A',
      price: displayPrice,
      originalPrice: originalPrice,
      stock: entity.unlimitedStock ? 999999 : (entity.stockQty ?? 0),
      status: status,
      color: const Color(0xFF1C1C1E),
      mainImageUrl: entity.mainImageUrl,
      imageUrls: entity.imageUrls,
      description: entity.description,
      specs: entity.specs,
    );
  }

  Widget _buildCategoryFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CATEGORIES',
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w800,
            color: Colors.white.withOpacity(0.3),
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: 14.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(vertical: 4.h),
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildCategoryChip(
                'All Products',
                Icons.apps_rounded,
                _activeCategory == null,
                () => setState(() => _activeCategory = null),
                activeColor: AppColors.primary,
              ),
              ...CategoryConfig.all.map(
                (cfg) => Padding(
                  padding: EdgeInsets.only(left: 12.w),
                  child: _buildCategoryChip(
                    cfg.label,
                    cfg.icon,
                    _activeCategory?.id == cfg.id,
                    () => setState(() => _activeCategory = cfg),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap, {
    Color? activeColor,
  }) {
    final themeColor = activeColor ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? themeColor.withOpacity(0.15) : AppColors.card,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected
                ? themeColor.withOpacity(0.5)
                : Colors.white.withOpacity(0.04),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: themeColor.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: isSelected ? themeColor : Colors.white.withOpacity(0.3),
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? themeColor : Colors.white.withOpacity(0.6),
                letterSpacing: 0.3,
              ),
            ),
            if (isSelected) ...[
              SizedBox(width: 8.w),
              Container(
                width: 6.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: themeColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: themeColor.withOpacity(0.5),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar(int count) {
    return Wrap(
      spacing: 16.w,
      runSpacing: 16.h,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          width: 320.w,
          height: 52.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                size: 18.sp,
                color: Colors.white.withOpacity(0.2),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search products by name or category...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.15)),
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                ),
              ),
            ],
          ),
        ),
        GridFilterDropdown(
          value: _selectedFilter,
          items: _filters,
          icon: Icons.filter_list_rounded,
          onChanged: (v) => setState(() => _selectedFilter = v),
        ),
        GridFilterDropdown(
          value: _sortBy,
          items: _sorts,
          icon: Icons.sort_rounded,
          onChanged: (v) => setState(() => _sortBy = v),
        ),
        const Spacer(),
        _buildCountBadge(count),
      ],
    );
  }

  Widget _buildCountBadge(int count) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Text(
        '$count ITEMS',
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w800,
          color: AppColors.primary,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 80.h),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.02),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 48.sp,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'No products found',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Try adjusting your filters or search query',
              style: TextStyle(
                color: Colors.white.withOpacity(0.2),
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
