import 'package:dashboard_ecommerce/features/products/presentation/widgets/product_images_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../shared/theme/app_spacing.dart';
import '../../domain/entities/product_entity.dart';
import '../cubit/products_cubit.dart';
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
import '../widgets/product_images/product_image_models.dart';

class AddProductPageBody extends StatefulWidget {
  const AddProductPageBody({super.key});

  @override
  State<AddProductPageBody> createState() => _AddProductPageBodyState();
}

class _AddProductPageBodyState extends State<AddProductPageBody> {
  CategoryConfig? _selectedConfig;
  String _name = '';
  String _description = '';
  double? _price;
  double? _salePrice;
  String _currency = 'USD';
  int? _stockQty;
  bool _unlimitedStock = false;
  String _stockStatus = 'In Stock';
  String? _sku;
  bool _isFeatured = false;
  double? _weightKg;
  double? _lengthCm;
  double? _widthCm;
  double? _heightCm;
  String? _weightUnit = 'kg';
  String? _dimensionUnit = 'cm';
  Map<String, String> _specs = {};
  List<ProductColorStock> _colorStocks = [];
  List<ProductImageItem> _images = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsCubit, ProductsState>(
      listenWhen: (previous, current) =>
          previous.actionInProgress && !current.actionInProgress,
      listener: (context, state) {
        if (state.error != null && state.error!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product published successfully')),
          );
        }
      },
      builder: (context, state) {
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
              ProductBasicDetailsCard(
                onChanged: (name, description) {
                  _name = name;
                  _description = description;
                },
              ),
              AppSpacing.v16,
              ProductImagesCard(
                onChanged: (images) => _images = images,
              ),
              AppSpacing.v16,
              ProductColorsCard(
                onChanged: (colorStocks) => _colorStocks = colorStocks,
              ),
              AppSpacing.v16,
              ProductPricingCard(
                onChanged: ({required price, required salePrice, required currency}) {
                  _price = price;
                  _salePrice = salePrice;
                  _currency = currency;
                },
              ),
              AppSpacing.v16,
              ProductInventoryCard(
                onChanged: ({
                  required stockQty,
                  required unlimitedStock,
                  required stockStatus,
                  required sku,
                  required isFeatured,
                }) {
                  _stockQty = stockQty;
                  _unlimitedStock = unlimitedStock;
                  _stockStatus = stockStatus;
                  _sku = sku;
                  _isFeatured = isFeatured;
                },
              ),
              AppSpacing.v16,
              ProductSpecsCard(
                onChanged: (specs) => _specs = specs,
              ),
              AppSpacing.v16,
              ProductShippingCard(
                onChanged: ({
                  required weightKg,
                  required lengthCm,
                  required widthCm,
                  required heightCm,
                  required weightUnit,
                  required dimensionUnit,
                }) {
                  _weightKg = weightKg;
                  _lengthCm = lengthCm;
                  _widthCm = widthCm;
                  _heightCm = heightCm;
                  _weightUnit = weightUnit ?? 'kg';
                  _dimensionUnit = dimensionUnit ?? 'cm';
                },
              ),
              AppSpacing.v25,
              AddProductActionButtons(
                isLoading: state.actionInProgress,
                onPublish: () => _publish(context),
              ),
              AppSpacing.v30,
            ],
          ),
        );
      },
    );
  }

  Future<void> _publish(BuildContext context) async {
    if (_name.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product name is required')),
      );
      return;
    }

    final imageInputs = _images.asMap().entries.map((entry) {
      final i = entry.key;
      final image = entry.value;
      return ProductImageInput(
        bytes: image.bytes,
        externalUrl: image.url,
        isPrimary: i == 0,
      );
    }).toList();

    final input = ProductUpsertInput(
      name: _name.trim(),
      description: _description.trim().isEmpty ? null : _description.trim(),
      categoryId: _selectedConfig?.id,
      categoryName: _selectedConfig?.label,
      price: _price,
      salePrice: _salePrice,
      currency: _currency,
      stockQty: _unlimitedStock ? null : _stockQty,
      unlimitedStock: _unlimitedStock,
      stockStatus: _stockStatus,
      sku: _sku,
      isFeatured: _isFeatured,
      weightKg: _weightKg,
      lengthCm: _lengthCm,
      widthCm: _widthCm,
      heightCm: _heightCm,
      weightUnit: _weightUnit ?? 'kg',
      dimensionUnit: _dimensionUnit ?? 'cm',
      specs: _specs.isEmpty ? null : _specs,
      images: imageInputs,
      colorStocks: _colorStocks,
    );

    await context.read<ProductsCubit>().createProduct(input);
    await context.read<ProductsCubit>().loadProducts();
  }
}
