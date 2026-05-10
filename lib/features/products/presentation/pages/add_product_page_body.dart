// ignore_for_file: use_build_context_synchronously

import 'package:dashboard_ecommerce/features/categories/presentation/cubit/categories_cubit.dart';
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
import '../../../../../shared/utils/app_snack_bar.dart';

class AddProductPageBody extends StatefulWidget {
  const AddProductPageBody({super.key, this.initialProduct, this.onSuccess});
  final ProductEntity? initialProduct;
  final VoidCallback? onSuccess;

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

  bool get _isEditing => widget.initialProduct != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final p = widget.initialProduct!;
      final categories = context.read<CategoriesCubit>().state.categories;
      _selectedConfig = categories.firstWhere(
        (c) => c.id == p.categoryId,
        orElse: () => categories.firstWhere(
          (c) => c.label == p.categoryName,
          orElse: () => categories.isNotEmpty ? categories[0] : CategoryConfig.womensFashion,
        ),
      );
      _name = p.name;
      _description = p.description ?? '';
      _price = p.price;
      _salePrice = p.salePrice;
      _currency = p.currency ?? 'USD';
      _stockQty = p.stockQty;
      _unlimitedStock = p.unlimitedStock;
      _stockStatus = p.stockStatus ?? 'In Stock';
      _sku = p.sku;
      _isFeatured = p.isFeatured;
      _weightKg = p.weightKg;
      _lengthCm = p.lengthCm;
      _widthCm = p.widthCm;
      _heightCm = p.heightCm;
      _weightUnit = p.weightUnit ?? 'kg';
      _dimensionUnit = p.dimensionUnit ?? 'cm';
      _specs = p.specs?.map((k, v) => MapEntry(k, v.toString())) ?? {};
      _colorStocks = p.colorStocks;
      _images = [
        if (p.mainImageUrl != null) ProductImageItem.network(p.mainImageUrl!),
        ...p.imageUrls
            .where((url) => url != p.mainImageUrl)
            .map((url) => ProductImageItem.network(url)),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsCubit, ProductsState>(
      listenWhen: (previous, current) =>
          previous.actionInProgress && !current.actionInProgress,
      listener: (context, state) {
        if (state.error != null && state.error!.isNotEmpty) {
          AppSnackBar.showError(context, state.error!);
        } else {
          AppSnackBar.showSuccess(context, 'Product published successfully');
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
                onCategorySelected: (cfg) =>
                    setState(() => _selectedConfig = cfg),
              ),
              AppSpacing.v16,
              ProductBasicDetailsCard(
                initialName: _name,
                initialDescription: _description,
                onChanged: (name, description) {
                  _name = name;
                  _description = description;
                },
              ),
              AppSpacing.v16,
              ProductImagesCard(
                initialMainUrl: widget.initialProduct?.mainImageUrl,
                initialOtherUrls: widget.initialProduct?.imageUrls
                    .where((url) => url != widget.initialProduct?.mainImageUrl)
                    .toList(),
                onChanged: (images) => _images = images,
              ),
              AppSpacing.v16,
              ProductColorsCard(
                initialColors: _colorStocks,
                onChanged: (colorStocks) => _colorStocks = colorStocks,
              ),
              AppSpacing.v16,
              ProductPricingCard(
                initialPrice: _price,
                initialSalePrice: _salePrice,
                initialCurrency: _currency,
                onChanged:
                    ({required price, required salePrice, required currency}) {
                      _price = price;
                      _salePrice = salePrice;
                      _currency = currency;
                    },
              ),
              AppSpacing.v16,
              ProductInventoryCard(
                initialStockQty: _stockQty,
                initialUnlimitedStock: _unlimitedStock,
                initialStockStatus: _stockStatus,
                initialSku: _sku,
                initialIsFeatured: _isFeatured,
                onChanged:
                    ({
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
                initialSpecs: widget.initialProduct?.specs,
                onChanged: (specs) => _specs = specs,
              ),
              AppSpacing.v16,
              ProductShippingCard(
                initialWeightKg: _weightKg,
                initialLengthCm: _lengthCm,
                initialWidthCm: _widthCm,
                initialHeightCm: _heightCm,
                initialWeightUnit: _weightUnit,
                initialDimensionUnit: _dimensionUnit,
                onChanged:
                    ({
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
                label: _isEditing ? 'Update Product' : 'Publish Product',
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
      AppSnackBar.showError(context, 'Product name is required');
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
      id: widget.initialProduct?.id,
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

    if (_isEditing) {
      await context.read<ProductsCubit>().updateProduct(input);
    } else {
      await context.read<ProductsCubit>().createProduct(input);
    }

    if (mounted) {
      AppSnackBar.showSuccess(
        context,
        'Product ${_isEditing ? 'updated' : 'published'} successfully',
      );
      if (widget.onSuccess != null) {
        widget.onSuccess!();
      } else {
        Navigator.pop(context);
      }
    }
    await context.read<ProductsCubit>().loadProducts();
  }
}
