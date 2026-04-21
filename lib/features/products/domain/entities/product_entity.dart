import 'dart:typed_data';
import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  const ProductEntity({
    required this.id,
    required this.name,
    this.description,
    this.categoryId,
    this.categoryName,
    this.price,
    this.salePrice,
    this.currency,
    this.stockQty,
    this.unlimitedStock = false,
    this.stockStatus,
    this.sku,
    this.isFeatured = false,
    this.weightKg,
    this.weightUnit,
    this.lengthCm,
    this.widthCm,
    this.heightCm,
    this.dimensionUnit,
    this.specs,
    this.mainImageUrl,
    this.imageUrls = const [],
    this.colorStocks = const [],
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String? description;
  final String? categoryId;
  final String? categoryName;
  final double? price;
  final double? salePrice;
  final String? currency;
  final int? stockQty;
  final bool unlimitedStock;
  final String? stockStatus;
  final String? sku;
  final bool isFeatured;
  final double? weightKg;
  final String? weightUnit;
  final double? lengthCm;
  final double? widthCm;
  final double? heightCm;
  final String? dimensionUnit;
  final Map<String, dynamic>? specs;
  final String? mainImageUrl;
  final List<String> imageUrls;
  final List<ProductColorStock> colorStocks;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        categoryId,
        categoryName,
        price,
        salePrice,
        currency,
        stockQty,
        unlimitedStock,
        stockStatus,
        sku,
        isFeatured,
        weightKg,
        weightUnit,
        lengthCm,
        widthCm,
        heightCm,
        dimensionUnit,
        specs,
        mainImageUrl,
        imageUrls,
        colorStocks,
        createdAt,
        updatedAt,
      ];
}

class ProductColorStock extends Equatable {
  const ProductColorStock({
    required this.colorName,
    this.colorHex,
    this.quantity = 0,
    this.unlimited = false,
  });

  final String colorName;
  final String? colorHex;
  final int quantity;
  final bool unlimited;

  @override
  List<Object?> get props => [colorName, colorHex, quantity, unlimited];
}

class ProductImageInput extends Equatable {
  const ProductImageInput({
    this.bytes,
    this.externalUrl,
    this.isPrimary = false,
  });

  final Uint8List? bytes;
  final String? externalUrl;
  final bool isPrimary;

  @override
  List<Object?> get props => [bytes, externalUrl, isPrimary];
}

class ProductUpsertInput extends Equatable {
  const ProductUpsertInput({
    this.id,
    required this.name,
    this.description,
    this.categoryId,
    this.categoryName,
    this.price,
    this.salePrice,
    this.currency,
    this.stockQty,
    this.unlimitedStock = false,
    this.stockStatus,
    this.sku,
    this.isFeatured = false,
    this.weightKg,
    this.weightUnit,
    this.lengthCm,
    this.widthCm,
    this.heightCm,
    this.dimensionUnit,
    this.specs,
    this.images = const [],
    this.colorStocks = const [],
  });

  final String? id;
  final String name;
  final String? description;
  final String? categoryId;
  final String? categoryName;
  final double? price;
  final double? salePrice;
  final String? currency;
  final int? stockQty;
  final bool unlimitedStock;
  final String? stockStatus;
  final String? sku;
  final bool isFeatured;
  final double? weightKg;
  final String? weightUnit;
  final double? lengthCm;
  final double? widthCm;
  final double? heightCm;
  final String? dimensionUnit;
  final Map<String, dynamic>? specs;
  final List<ProductImageInput> images;
  final List<ProductColorStock> colorStocks;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        categoryId,
        categoryName,
        price,
        salePrice,
        currency,
        stockQty,
        unlimitedStock,
        stockStatus,
        sku,
        isFeatured,
        weightKg,
        weightUnit,
        lengthCm,
        widthCm,
        heightCm,
        dimensionUnit,
        specs,
        images,
        colorStocks,
      ];
}
