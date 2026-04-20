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
}
