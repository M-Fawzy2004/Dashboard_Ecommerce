import 'package:dashboard_ecommerce/features/products/presentation/widgets/product_images_card.dart';
import 'package:flutter/material.dart';
import '../../../../../shared/theme/app_spacing.dart';
import '../widgets/add_product_top_bar.dart';
import '../widgets/product_basic_form_card.dart'; // Contains ProductBasicDetailsCard
import '../widgets/product_category_selector_card.dart';
import '../model/category_config.dart';
import '../widgets/pricing/product_pricing_card.dart';
import '../widgets/inventory/product_inventory_card.dart';
import '../widgets/product_shipping_card.dart';
import '../widgets/product_specs_card.dart';
import '../widgets/product_colors_card.dart';
import '../widgets/add_product_action_buttons.dart';

class AddProductPageBody extends StatefulWidget {
  const AddProductPageBody({super.key});

  @override
  State<AddProductPageBody> createState() => _AddProductPageBodyState();
}

class _AddProductPageBodyState extends State<AddProductPageBody> {
  CategoryConfig? _selectedConfig;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AddProductTopBar(),
          AppSpacing.v20,
          ProductCategorySelectorCard(
            selectedConfig: _selectedConfig,
            onCategorySelected: (cfg) => setState(() => _selectedConfig = cfg),
          ),
          AppSpacing.v16,
          const ProductBasicDetailsCard(),
          AppSpacing.v16,
          const ProductImagesCard(),
          AppSpacing.v16,
          const ProductColorsCard(),
          AppSpacing.v16,
          const ProductPricingCard(),
          AppSpacing.v16,
          const ProductInventoryCard(),
          AppSpacing.v16,
          const ProductSpecsCard(),
          AppSpacing.v16,
          const ProductShippingCard(),
          AppSpacing.v25,
          const AddProductActionButtons(),
          AppSpacing.v30,
        ],
      ),
    );
  }
}
