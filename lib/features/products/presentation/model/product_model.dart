import 'package:flutter/material.dart';

class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.brand,
    required this.price,
    this.originalPrice,
    required this.stock,
    required this.status,
    required this.color,
    this.mainImageUrl,
    this.imageUrls = const [],
    this.description,
    this.specs,
  });

  final String id;
  final String name;
  final String category;
  final String brand;
  final double price;
  final double? originalPrice;
  final int stock;
  final String status;
  final Color color;
  final String? mainImageUrl;
  final List<String> imageUrls;
  final String? description;
  final Map<String, dynamic>? specs;
}
