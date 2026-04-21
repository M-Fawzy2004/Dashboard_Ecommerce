import 'package:flutter/material.dart';
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
