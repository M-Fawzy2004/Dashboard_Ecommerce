import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../model/product_model.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});
  final ProductModel product;

  Color get _statusColor {
    switch (product.status) {
      case 'In Stock':
        return const Color(0xFF10B981);
      case 'Low Stock':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFFEF4444);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasDiscount = product.originalPrice != null;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image / Color placeholder
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    color: product.color.withValues(alpha: 0.12),
                    child: Center(
                      child: Icon(
                        _categoryIcon(product.category),
                        size: 48.sp,
                        color: product.color.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    child: _StatusBadge(status: product.status, color: _statusColor),
                  ),
                  if (hasDiscount)
                    Positioned(
                      top: 10.h,
                      left: 10.w,
                      child: _DiscountBadge(
                        price: product.price,
                        originalPrice: product.originalPrice!,
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Info
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${product.brand} · ${product.category}',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.textSecondary.withValues(alpha: 0.6),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${product.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                            if (hasDiscount)
                              Text(
                                '\$${product.originalPrice!.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  decoration: TextDecoration.lineThrough,
                                  color: AppColors.textSecondary.withValues(alpha: 0.4),
                                ),
                              ),
                          ],
                        ),
                      ),
                      _StockIndicator(stock: product.stock, color: _statusColor),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  const _CardActionRow(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _categoryIcon(String cat) {
    switch (cat) {
      case 'Smartphones': return Icons.smartphone_rounded;
      case 'Laptops': return Icons.laptop_mac_rounded;
      case 'Tablets': return Icons.tablet_rounded;
      case 'Electronics': return Icons.electrical_services_rounded;
      case "Women's Fashion": return Icons.woman_2_rounded;
      case 'Sports & Fitness': return Icons.sports_soccer_rounded;
      default: return Icons.inventory_2_rounded;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status, required this.color});
  final String status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w800, color: color),
      ),
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  const _DiscountBadge({required this.price, required this.originalPrice});
  final double price;
  final double originalPrice;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        '-${(((originalPrice - price) / originalPrice) * 100).toStringAsFixed(0)}%',
        style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w800, color: Colors.white),
      ),
    );
  }
}

class _StockIndicator extends StatelessWidget {
  const _StockIndicator({required this.stock, required this.color});
  final int stock;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '$stock',
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w800, color: color),
        ),
        Text(
          'in stock',
          style: TextStyle(fontSize: 9.sp, color: AppColors.textSecondary.withValues(alpha: 0.5)),
        ),
      ],
    );
  }
}

class _CardActionRow extends StatelessWidget {
  const _CardActionRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 30.h,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text(
                'Edit',
                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          width: 30.w,
          height: 30.h,
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            Icons.delete_outline_rounded,
            size: 14.sp,
            color: AppColors.error.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
