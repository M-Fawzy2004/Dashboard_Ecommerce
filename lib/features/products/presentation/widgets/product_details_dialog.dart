import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/theme/app_spacing.dart';
import '../model/product_model.dart';
import 'product_details/product_details_sections.dart';
import 'product_details/product_details_widgets.dart';

class ProductDetailsDialog extends StatefulWidget {
  const ProductDetailsDialog({
    super.key,
    required this.product,
    this.onEdit,
    this.onDelete,
  });
  final ProductModel product;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  static void show(
    BuildContext context,
    ProductModel product, {
    VoidCallback? onEdit,
    VoidCallback? onDelete,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, _, _) => ProductDetailsDialog(
        product: product,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
      transitionBuilder: (ctx, anim, _, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(anim),
          child: child,
        );
      },
    );
  }

  @override
  State<ProductDetailsDialog> createState() => _ProductDetailsDialogState();
}

class _ProductDetailsDialogState extends State<ProductDetailsDialog> {
  @override
  Widget build(BuildContext context) {
    final allImages = {
      if (widget.product.mainImageUrl != null) widget.product.mainImageUrl!,
      ...widget.product.imageUrls,
    }.toList();

    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 500.w,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.horizontal(left: Radius.circular(24.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 40,
                offset: const Offset(-10, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              const ProductDetailsHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(28.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductDetailsImageGallery(images: allImages),
                      AppSpacing.v25,
                      ProductDetailsInfoSection(product: widget.product),
                      AppSpacing.v25,
                      const Divider(),
                      AppSpacing.v20,
                      ProductDetailsDescription(
                        description: widget.product.description,
                      ),
                      if (widget.product.specs != null &&
                          widget.product.specs!.isNotEmpty) ...[
                        AppSpacing.v30,
                        ProductDetailsSpecs(specs: widget.product.specs!),
                      ],
                      AppSpacing.v30,
                      ProductDetailsSummary(product: widget.product),
                      SizedBox(height: 100.h),
                    ],
                  ),
                ),
              ),
              ProductDetailsBottomActions(
                onEdit: _handleEdit,
                onDelete: _handleDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleEdit() {
    Navigator.pop(context);
    widget.onEdit?.call();
  }

  void _handleDelete() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text(
          'Are you sure you want to delete "${widget.product.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      Navigator.pop(context); // Close details panel
      widget.onDelete?.call();
    }
  }
}
