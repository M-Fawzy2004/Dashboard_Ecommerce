import 'package:dashboard_ecommerce/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_spacing.dart';
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add New Product',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900),
              ),
              TextButton.icon(
                onPressed: onAddProduct,
                icon: const Icon(Icons.add_circle_outline, size: 18),
                label: const Text(
                  'Add New',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          AppSpacing.v16,
          Text(
            'Categories',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.v12,
          _buildCategoryList(),
          Center(
            child: TextButton(
              onPressed: onSeeMore,
              child: Text(
                'See more',
                style: TextStyle(
                  color: Colors.indigo,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          AppSpacing.v16,
          Text(
            'Product',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.v12,
          _buildProductList(context),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        if (state.isLoading) return const LinearProgressIndicator();
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
          return const LinearProgressIndicator();
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

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({required this.name, required this.icon});
  final String name;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade100),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: Colors.blueGrey, size: 20),
          ),
          SizedBox(width: 16.w),
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp),
          ),
          const Spacer(),
          Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 18),
        ],
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  const _ProductItem({required this.name, required this.price, this.imageUrl});
  final String name;
  final String price;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8.r),
              image: imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageUrl == null
                ? const Icon(Icons.image_outlined, color: Colors.grey)
                : null,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 16),
          ),
        ],
      ),
    );
  }
}
