import 'package:flutter/material.dart';

/// Defines which fields are relevant for each store category.
class CategoryConfig {
  const CategoryConfig({
    required this.id,
    required this.label,
    required this.icon,
    required this.showSizes,
    required this.showColors,
    required this.showStorageOptions,
    required this.showRam,
    required this.showScreenSize,
    required this.showProcessor,
    required this.showEnergyRating,
    required this.showMaterial,
    this.sizeOptions = const [],
    this.brandOptions = const [],
  });

  final String id;
  final String label;
  final IconData icon;

  // ── Toggles ────────────────────────────────────────────────────────────────
  final bool showSizes;
  final bool showColors;
  final bool showStorageOptions;
  final bool showRam;
  final bool showScreenSize;
  final bool showProcessor;
  final bool showEnergyRating;
  final bool showMaterial;

  // ── Options ────────────────────────────────────────────────────────────────
  final List<String> sizeOptions;
  final List<String> brandOptions;

  static const all = [_womensFashion, _mensFashion, _mobile, _tablet, _electronics, _laptop, _fashion, _appliances, _sports];

  // ── Women's Fashion ────────────────────────────────────────────────────────
  static const _womensFashion = CategoryConfig(
    id: 'womens_fashion',
    label: 'Women\'s Fashion',
    icon: Icons.woman_2_rounded,
    showSizes: true,
    showColors: true,
    showStorageOptions: false,
    showRam: false,
    showScreenSize: false,
    showProcessor: false,
    showEnergyRating: false,
    showMaterial: true,
    sizeOptions: ['XS', 'S', 'M', 'L', 'XL', '2XL', '3XL'],
    brandOptions: ['Zara', 'H&M', 'SHEIN', 'Mango', 'LC Waikiki', 'Other'],
  );

  // ── Men's Fashion ──────────────────────────────────────────────────────────
  static const _mensFashion = CategoryConfig(
    id: 'mens_fashion',
    label: 'Men\'s Fashion',
    icon: Icons.man_2_rounded,
    showSizes: true,
    showColors: true,
    showStorageOptions: false,
    showRam: false,
    showScreenSize: false,
    showProcessor: false,
    showEnergyRating: false,
    showMaterial: true,
    sizeOptions: ['XS', 'S', 'M', 'L', 'XL', '2XL', '3XL'],
    brandOptions: ['Zara', 'H&M', 'Polo', 'Pull&Bear', 'LC Waikiki', 'Other'],
  );

  // ── Mobile ─────────────────────────────────────────────────────────────────
  static const _mobile = CategoryConfig(
    id: 'mobile',
    label: 'Smartphones',
    icon: Icons.smartphone_rounded,
    showSizes: false,
    showColors: true,
    showStorageOptions: true,
    showRam: true,
    showScreenSize: false,
    showProcessor: false,
    showEnergyRating: false,
    showMaterial: false,
    brandOptions: ['Apple', 'Samsung', 'Xiaomi', 'OPPO', 'Vivo', 'Huawei', 'Nokia', 'Other'],
  );

  // ── Tablet ─────────────────────────────────────────────────────────────────
  static const _tablet = CategoryConfig(
    id: 'tablet',
    label: 'Tablets',
    icon: Icons.tablet_rounded,
    showSizes: false,
    showColors: true,
    showStorageOptions: true,
    showRam: true,
    showScreenSize: true,
    showProcessor: false,
    showEnergyRating: false,
    showMaterial: false,
    brandOptions: ['Apple', 'Samsung', 'Huawei', 'Lenovo', 'Amazon', 'Other'],
  );

  // ── Electronics ────────────────────────────────────────────────────────────
  static const _electronics = CategoryConfig(
    id: 'electronics',
    label: 'Electronics',
    icon: Icons.electrical_services_rounded,
    showSizes: false,
    showColors: false,
    showStorageOptions: false,
    showRam: false,
    showScreenSize: false,
    showProcessor: false,
    showEnergyRating: false,
    showMaterial: false,
    brandOptions: ['Sony', 'LG', 'Philips', 'JBL', 'Bose', 'Other'],
  );

  // ── Laptop ─────────────────────────────────────────────────────────────────
  static const _laptop = CategoryConfig(
    id: 'laptop',
    label: 'Laptops',
    icon: Icons.laptop_mac_rounded,
    showSizes: false,
    showColors: true,
    showStorageOptions: true,
    showRam: true,
    showScreenSize: true,
    showProcessor: true,
    showEnergyRating: false,
    showMaterial: false,
    brandOptions: ['Apple', 'Dell', 'HP', 'Lenovo', 'ASUS', 'MSI', 'Acer', 'Other'],
  );

  // ── Fashion Accessories ────────────────────────────────────────────────────
  static const _fashion = CategoryConfig(
    id: 'fashion',
    label: 'Fashion & Accessories',
    icon: Icons.checkroom_rounded,
    showSizes: false,
    showColors: true,
    showStorageOptions: false,
    showRam: false,
    showScreenSize: false,
    showProcessor: false,
    showEnergyRating: false,
    showMaterial: true,
    brandOptions: ['Gucci', 'Dior', 'Chanel', 'Coach', 'Michael Kors', 'Other'],
  );

  // ── Home Appliances ────────────────────────────────────────────────────────
  static const _appliances = CategoryConfig(
    id: 'appliances',
    label: 'Home Appliances',
    icon: Icons.kitchen_rounded,
    showSizes: false,
    showColors: true,
    showStorageOptions: false,
    showRam: false,
    showScreenSize: false,
    showProcessor: false,
    showEnergyRating: true,
    showMaterial: false,
    brandOptions: ['Samsung', 'LG', 'Bosch', 'Whirlpool', 'Philips', 'Tefal', 'Other'],
  );

  // ── Sports ─────────────────────────────────────────────────────────────────
  static const _sports = CategoryConfig(
    id: 'sports',
    label: 'Sports & Fitness',
    icon: Icons.sports_soccer_rounded,
    showSizes: true,
    showColors: true,
    showStorageOptions: false,
    showRam: false,
    showScreenSize: false,
    showProcessor: false,
    showEnergyRating: false,
    showMaterial: true,
    sizeOptions: ['XS', 'S', 'M', 'L', 'XL', '2XL', '36', '38', '40', '42', '44'],
    brandOptions: ['Nike', 'Adidas', 'Puma', 'Under Armour', 'Reebok', 'Other'],
  );
}
