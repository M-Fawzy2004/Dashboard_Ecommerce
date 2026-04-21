import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/theme/app_spacing.dart';

class ProductCategoryTag extends StatelessWidget {
  const ProductCategoryTag({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w800,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class ProductStockStatusTag extends StatelessWidget {
  const ProductStockStatusTag({super.key, required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final isSuccess = status == 'In Stock';
    final color = isSuccess ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        AppSpacing.h10,
        Text(
          status,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

class ProductDiscountBadge extends StatelessWidget {
  const ProductDiscountBadge({super.key, required this.original, required this.current});
  final double original;
  final double current;

  @override
  Widget build(BuildContext context) {
    if (original <= 0 || current >= original) return const SizedBox();
    final percent = ((original - current) / original * 100).toStringAsFixed(0);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        '$percent% OFF',
        style: TextStyle(
          color: AppColors.success,
          fontSize: 12.sp,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class ProductSummaryRow extends StatelessWidget {
  const ProductSummaryRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: AppColors.textSecondary.withValues(alpha: 0.5),
        ),
        AppSpacing.h10,
        Text(
          label,
          style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class ProductDetailsHeader extends StatelessWidget {
  const ProductDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black.withValues(alpha: 0.05)),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              color: AppColors.primary,
              size: 20.sp,
            ),
          ),
          AppSpacing.h12,
          Text(
            'Product Details',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded),
            style: IconButton.styleFrom(
              backgroundColor: Colors.black.withValues(alpha: 0.04),
              foregroundColor: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductDetailsBottomActions extends StatelessWidget {
  const ProductDetailsBottomActions({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(28.w, 20.h, 28.w, 32.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.black.withValues(alpha: 0.05)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline_rounded),
              label: const Text('Delete'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: BorderSide(color: AppColors.error.withValues(alpha: 0.3)),
                padding: EdgeInsets.symmetric(vertical: 18.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
            ),
          ),
          AppSpacing.h16,
          Expanded(
            flex: 2,
            child: FilledButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_document),
              label: const Text('Edit Product'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 18.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductDetailsImageGallery extends StatefulWidget {
  const ProductDetailsImageGallery({super.key, required this.images});
  final List<String> images;

  @override
  State<ProductDetailsImageGallery> createState() => _ProductDetailsImageGalleryState();
}

class _ProductDetailsImageGalleryState extends State<ProductDetailsImageGallery> {
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 320.h,
          width: double.infinity,
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: widget.images.isNotEmpty
              ? Image.network(widget.images[_activeIndex], fit: BoxFit.contain)
              : Icon(
                  Icons.image_outlined,
                  size: 60.sp,
                  color: Colors.grey.shade300,
                ),
        ),
        if (widget.images.length > 1) ...[
          AppSpacing.v15,
          SizedBox(
            height: 60.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.images.length,
              separatorBuilder: (_, _) => AppSpacing.h10,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => setState(() => _activeIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 60.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: _activeIndex == index
                          ? AppColors.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                    image: DecorationImage(
                      image: NetworkImage(widget.images[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
