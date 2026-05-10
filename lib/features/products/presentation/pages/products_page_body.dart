import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_spacing.dart';
import '../widgets/products_header.dart';
import '../widgets/products_grid.dart';
import '../../domain/entities/product_entity.dart';

class ProductsPageBody extends StatelessWidget {
  const ProductsPageBody({super.key, this.onEdit});
  final ValueChanged<ProductEntity>? onEdit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProductsHeader(),
          AppSpacing.v25,
          ProductsGrid(onEdit: onEdit),
        ],
      ),
    );
  }
}
