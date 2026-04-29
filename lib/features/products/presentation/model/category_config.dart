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

  static List<CategoryConfig> all = [];

  Map<String, dynamic> toMap() {
    return {
      'key': id,
      'name': label,
      'icon_name': _getIconName(icon),
      'show_sizes': showSizes,
      'show_colors': showColors,
      'show_storage_options': showStorageOptions,
      'show_ram': showRam,
      'show_screen_size': showScreenSize,
      'show_processor': showProcessor,
      'show_energy_rating': showEnergyRating,
      'show_material': showMaterial,
      'size_options': sizeOptions,
      'brand_options': brandOptions,
    };
  }

  factory CategoryConfig.fromMap(Map<String, dynamic> map) {
    return CategoryConfig(
      id: map['key'] ?? '',
      label: map['name'] ?? '',
      icon: _getIconFromName(map['icon_name'] as String?),
      showSizes: map['show_sizes'] ?? false,
      showColors: map['show_colors'] ?? false,
      showStorageOptions: map['show_storage_options'] ?? false,
      showRam: map['show_ram'] ?? false,
      showScreenSize: map['show_screen_size'] ?? false,
      showProcessor: map['show_processor'] ?? false,
      showEnergyRating: map['show_energy_rating'] ?? false,
      showMaterial: map['show_material'] ?? false,
      sizeOptions: List<String>.from(map['size_options'] ?? []),
      brandOptions: List<String>.from(map['brand_options'] ?? []),
    );
  }

  static String _getIconName(IconData icon) {
    if (icon == Icons.woman_2_rounded) return 'woman_2_rounded';
    if (icon == Icons.man_2_rounded) return 'man_2_rounded';
    if (icon == Icons.smartphone_rounded) return 'smartphone_rounded';
    if (icon == Icons.tablet_rounded) return 'tablet_rounded';
    if (icon == Icons.electrical_services_rounded) return 'electrical_services_rounded';
    if (icon == Icons.laptop_mac_rounded) return 'laptop_mac_rounded';
    if (icon == Icons.checkroom_rounded) return 'checkroom_rounded';
    if (icon == Icons.kitchen_rounded) return 'kitchen_rounded';
    if (icon == Icons.sports_soccer_rounded) return 'sports_soccer_rounded';
    if (icon == Icons.category_rounded) return 'category_rounded';
    return 'category_rounded';
  }

  static IconData _getIconFromName(String? name) {
    switch (name) {
      case 'woman_2_rounded': return Icons.woman_2_rounded;
      case 'man_2_rounded': return Icons.man_2_rounded;
      case 'smartphone_rounded': return Icons.smartphone_rounded;
      case 'tablet_rounded': return Icons.tablet_rounded;
      case 'electrical_services_rounded': return Icons.electrical_services_rounded;
      case 'laptop_mac_rounded': return Icons.laptop_mac_rounded;
      case 'checkroom_rounded': return Icons.checkroom_rounded;
      case 'kitchen_rounded': return Icons.kitchen_rounded;
      case 'sports_soccer_rounded': return Icons.sports_soccer_rounded;
      default: return Icons.category_rounded;
    }
  }

  // ── Predefined categories (for initial migration reference) ────────────────
  static const womensFashion = CategoryConfig(
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
  // ... (others omitted for brevity in file but I'll keep them if I can or just rely on DB)
}
