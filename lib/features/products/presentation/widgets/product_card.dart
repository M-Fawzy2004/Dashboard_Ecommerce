import 'package:dashboard_ecommerce/shared/widgets/hover_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../model/product_model.dart';
import '../widgets/product_details_dialog.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onEdit,
    this.onDelete,
  });
  final ProductModel product;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  void _showDetails(BuildContext context) {
    ProductDetailsDialog.show(
      context,
      product,
      onEdit: onEdit,
      onDelete: onDelete,
    );
  }

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
    return HoverButton(
      onTap: () => _showDetails(context),
      borderRadius: 20.r,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.white.withOpacity(0.04)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Area
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.02),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.r),
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                        child: product.mainImageUrl != null
                            ? Image.network(
                                product.mainImageUrl!,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => _CategoryPlaceholder(
                                  category: product.category,
                                  color: product.color,
                                ),
                              )
                            : _CategoryPlaceholder(
                                category: product.category,
                                color: product.color,
                              ),
                      ),
                    ),
                  ),
                  // Gradient Overlay for better readability of badges
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.4),
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black.withOpacity(0.2),
                          ],
                          stops: const [0.0, 0.2, 0.8, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12.h,
                    right: 12.w,
                    child: _StatusBadge(status: product.status, color: _statusColor),
                  ),
                  if (hasDiscount)
                    Positioned(
                      top: 12.h,
                      left: 12.w,
                      child: _DiscountBadge(
                        price: product.price,
                        originalPrice: product.originalPrice!,
                      ),
                    ),
                ],
              ),
            ),
            // Content Area
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.category_outlined, size: 10.sp, color: Colors.white.withOpacity(0.3)),
                        SizedBox(width: 4.w),
                        Text(
                          '${product.brand} · ${product.category}',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white.withOpacity(0.3),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (hasDiscount)
                                Text(
                                  '\$${product.originalPrice!.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.white.withOpacity(0.2),
                                    height: 1,
                                  ),
                                ),
                              Text(
                                '\$${product.price.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _StockIndicator(stock: product.stock, color: _statusColor),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    _CardActionRow(
                      onEdit: onEdit,
                      onDelete: () => _confirmDelete(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
          side: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
        title: Text(
          'Delete Product?',
          style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w800),
        ),
        content: Text(
          'Are you sure you want to delete "${product.name}"? This action is permanent.',
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: Colors.white.withOpacity(0.4))),
          ),
          HoverButton(
            onTap: () {
              Navigator.pop(ctx);
              onDelete?.call();
            },
            borderRadius: 12.r,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                'Delete',
                style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 13.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryPlaceholder extends StatelessWidget {
  const _CategoryPlaceholder({required this.category, required this.color});
  final String category;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: color.withOpacity(0.03),
      child: Center(
        child: Icon(
          _categoryIcon(category),
          size: 42.sp,
          color: color.withOpacity(0.3),
        ),
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
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.w900, color: color, letterSpacing: 0.5),
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
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Text(
        '-${(((originalPrice - price) / originalPrice) * 100).toStringAsFixed(0)}%',
        style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w900, color: Colors.white),
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
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w900, color: Colors.white),
        ),
        Text(
          'UNIT',
          style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.w800, color: color.withOpacity(0.6), letterSpacing: 1),
        ),
      ],
    );
  }
}

class _CardActionRow extends StatelessWidget {
  const _CardActionRow({this.onEdit, this.onDelete});
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: HoverButton(
            onTap: onEdit ?? () {},
            borderRadius: 10.r,
            child: Container(
              height: 34.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Center(
                child: Text(
                  'Edit',
                  style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        HoverButton(
          onTap: onDelete ?? () {},
          borderRadius: 10.r,
          child: Container(
            width: 34.w,
            height: 34.h,
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.error.withOpacity(0.1)),
            ),
            child: Icon(
              Icons.delete_outline_rounded,
              size: 16.sp,
              color: AppColors.error.withOpacity(0.6),
            ),
          ),
        ),
      ],
    );
  }
}
