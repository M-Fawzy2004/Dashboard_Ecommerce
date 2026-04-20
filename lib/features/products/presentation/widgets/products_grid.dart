import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';

import '../model/category_config.dart';
import '../model/product_model.dart';
import 'product_card.dart';
import 'grid_filter_dropdown.dart';

class ProductsGrid extends StatefulWidget {
  const ProductsGrid({super.key});

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

  List<ProductModel> get _filtered {
    var list = _mockProducts.where((p) {
      final matchSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.category.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchFilter = _selectedFilter == 'All' || p.status == _selectedFilter;
      final matchCategory = _activeCategory == null || p.category == _activeCategory!.label;
      return matchSearch && matchFilter && matchCategory;
    }).toList();

    if (_sortBy == 'Price ↑') list.sort((a, b) => a.price.compareTo(b.price));
    if (_sortBy == 'Price ↓') list.sort((a, b) => b.price.compareTo(a.price));
    if (_sortBy == 'Stock ↑') list.sort((a, b) => a.stock.compareTo(b.stock));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final products = _filtered;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategoryFilter(),
        SizedBox(height: 20.h),
        _buildToolbar(),
        SizedBox(height: 20.h),
        products.isEmpty
            ? _buildEmpty()
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                  childAspectRatio: 0.72,
                ),
                itemCount: products.length,
                itemBuilder: (_, i) => ProductCard(product: products[i]),
              ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filter by Category',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
        SizedBox(height: 12.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildCategoryChip('All Products', Icons.grid_view_rounded, _activeCategory == null, () => setState(() => _activeCategory = null)),
              ...CategoryConfig.all.map((cfg) => Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: _buildCategoryChip(cfg.label, cfg.icon, _activeCategory?.id == cfg.id, () => setState(() => _activeCategory = cfg)),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String label, IconData icon, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.card,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: isSelected ? AppColors.primary : Colors.black.withValues(alpha: 0.06), width: 1.2),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16.sp, color: isSelected ? Colors.white : AppColors.primary),
            SizedBox(width: 8.w),
            Text(label, style: TextStyle(fontSize: 12.sp, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600, color: isSelected ? Colors.white : AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 44.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: Colors.black.withValues(alpha: 0.06))),
            child: Row(
              children: [
                Icon(Icons.search_rounded, size: 18.sp, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                SizedBox(width: 10.w),
                Expanded(child: TextField(onChanged: (v) => setState(() => _searchQuery = v), style: TextStyle(fontSize: 13.sp), decoration: const InputDecoration(hintText: 'Search products...', border: InputBorder.none))),
              ],
            ),
          ),
        ),
        SizedBox(width: 12.w),
        GridFilterDropdown(value: _selectedFilter, items: _filters, icon: Icons.filter_list_rounded, onChanged: (v) => setState(() => _selectedFilter = v)),
        SizedBox(width: 10.w),
        GridFilterDropdown(value: _sortBy, items: _sorts, icon: Icons.sort_rounded, onChanged: (v) => setState(() => _sortBy = v)),
        SizedBox(width: 10.w),
        _buildCountBadge(),
      ],
    );
  }

  Widget _buildCountBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10.r)),
      child: Text('${_filtered.length} products', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: AppColors.primary)),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 60.h),
        child: Column(
          children: [
            Icon(Icons.inventory_2_outlined, size: 48.sp, color: AppColors.textSecondary.withValues(alpha: 0.3)),
            SizedBox(height: 12.h),
            const Text('No products found', style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  static final _mockProducts = <ProductModel>[
    ProductModel(id: 'PRD-001', name: 'iPhone 15 Pro Max', category: 'Smartphones', brand: 'Apple', price: 1299.00, originalPrice: 1399.00, stock: 48, status: 'In Stock', color: const Color(0xFF1C1C1E)),
    ProductModel(id: 'PRD-002', name: 'Samsung Galaxy S24 Ultra', category: 'Smartphones', brand: 'Samsung', price: 1199.00, stock: 23, status: 'In Stock', color: const Color(0xFF1A237E)),
    ProductModel(id: 'PRD-003', name: 'MacBook Pro 14" M3', category: 'Laptops', brand: 'Apple', price: 1999.00, stock: 11, status: 'Low Stock', color: const Color(0xFF607D8B)),
    ProductModel(id: 'PRD-004', name: 'Nike Air Max 270', category: 'Sports & Fitness', brand: 'Nike', price: 149.00, originalPrice: 189.00, stock: 86, status: 'In Stock', color: const Color(0xFFE53935)),
    ProductModel(id: 'PRD-005', name: 'iPad Pro 12.9" M4', category: 'Tablets', brand: 'Apple', price: 1099.00, stock: 5, status: 'Low Stock', color: const Color(0xFF37474F)),
    ProductModel(id: 'PRD-006', name: 'Sony WH-1000XM5', category: 'Electronics', brand: 'Sony', price: 349.00, stock: 0, status: 'Out of Stock', color: const Color(0xFF263238)),
    ProductModel(id: 'PRD-007', name: 'Zara Linen Blazer', category: "Women's Fashion", brand: 'Zara', price: 89.00, stock: 34, status: 'In Stock', color: const Color(0xFF8D6E63)),
    ProductModel(id: 'PRD-008', name: 'Dell XPS 15 i9', category: 'Laptops', brand: 'Dell', price: 2499.00, stock: 7, status: 'Low Stock', color: const Color(0xFF546E7A)),
  ];
}
