import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/theme/app_spacing.dart';
import '../../model/product_model.dart';
import 'product_details_widgets.dart';

class ProductDetailsInfoSection extends StatelessWidget {
  const ProductDetailsInfoSection({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ProductCategoryTag(label: product.category),
            const Spacer(),
            ProductStockStatusTag(status: product.status),
          ],
        ),
        AppSpacing.v16,
        Text(
          product.name,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w900,
            height: 1.2,
          ),
        ),
        AppSpacing.v10,
        Text(
          'SKU: ${product.brand}',
          style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
        ),
        AppSpacing.v20,
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.originalPrice != null)
                  Text(
                    'SALE PRICE',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            if (product.originalPrice != null) ...[
              AppSpacing.h20,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ORIGINAL',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    '\$${product.originalPrice!.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.lineThrough,
                      color: AppColors.textSecondary.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ProductDiscountBadge(
                original: product.originalPrice!,
                current: product.price,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class ProductDetailsDescription extends StatelessWidget {
  const ProductDetailsDescription({super.key, required this.description});
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800),
        ),
        AppSpacing.v10,
        Text(
          description ?? 'No description available.',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class ProductDetailsSpecs extends StatelessWidget {
  const ProductDetailsSpecs({super.key, required this.specs});
  final Map<String, dynamic> specs;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Specifications',
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800),
        ),
        AppSpacing.v12,
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: specs.entries
              .map(
                (e) => Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F3F5),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    '${e.key}: ${e.value}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class ProductDetailsSummary extends StatelessWidget {
  const ProductDetailsSummary({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Summary',
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800),
        ),
        AppSpacing.v15,
        Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F3F5),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              ProductSummaryRow(
                icon: Icons.inventory_2_rounded,
                label: 'Current Stock',
                value: '${product.stock} Units',
              ),
              const Divider(height: 24),
              ProductSummaryRow(
                icon: Icons.tag_rounded,
                label: 'SKU Code',
                value: product.brand,
              ),
              const Divider(height: 24),
              ProductSummaryRow(
                icon: Icons.category_rounded,
                label: 'Category',
                value: product.category,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
