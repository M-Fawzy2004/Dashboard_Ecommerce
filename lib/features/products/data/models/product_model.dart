import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    super.description,
    super.categoryId,
    super.categoryName,
    super.price,
    super.salePrice,
    super.currency,
    super.stockQty,
    super.unlimitedStock,
    super.stockStatus,
    super.sku,
    super.isFeatured,
    super.weightKg,
    super.weightUnit,
    super.lengthCm,
    super.widthCm,
    super.heightCm,
    super.dimensionUnit,
    super.specs,
    super.mainImageUrl,
    super.imageUrls,
    super.colorStocks,
    super.createdAt,
    super.updatedAt,
  });

  factory ProductModel.fromMap(
    Map<String, dynamic> map, {
    List<String> imageUrls = const [],
    List<ProductColorStock> colorStocks = const [],
  }) {
    return ProductModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      categoryId: map['category_id'] as String?,
      categoryName: map['category_name'] as String?,
      price: (map['price'] as num?)?.toDouble(),
      salePrice: (map['sale_price'] as num?)?.toDouble(),
      currency: map['currency'] as String?,
      stockQty: map['stock_qty'] as int?,
      unlimitedStock: map['unlimited_stock'] as bool? ?? false,
      stockStatus: map['stock_status'] as String?,
      sku: map['sku'] as String?,
      isFeatured: map['is_featured'] as bool? ?? false,
      weightKg: (map['weight_kg'] as num?)?.toDouble(),
      weightUnit: map['weight_unit'] as String?,
      lengthCm: (map['length_cm'] as num?)?.toDouble(),
      widthCm: (map['width_cm'] as num?)?.toDouble(),
      heightCm: (map['height_cm'] as num?)?.toDouble(),
      dimensionUnit: map['dimension_unit'] as String?,
      specs: map['specs'] as Map<String, dynamic>?,
      mainImageUrl: map['main_image_url'] as String?,
      imageUrls: imageUrls,
      colorStocks: colorStocks,
      createdAt: map['created_at'] == null
          ? null
          : DateTime.tryParse(map['created_at'] as String),
      updatedAt: map['updated_at'] == null
          ? null
          : DateTime.tryParse(map['updated_at'] as String),
    );
  }
}
