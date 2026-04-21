// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../domain/entities/product_entity.dart';
import 'common/product_form_section.dart';

class ProductColorsCard extends StatefulWidget {
  const ProductColorsCard({
    super.key,
    this.initialColors,
    this.onChanged,
  });

  final List<ProductColorStock>? initialColors;
  final ValueChanged<List<ProductColorStock>>? onChanged;

  @override
  State<ProductColorsCard> createState() => _ProductColorsCardState();
}

class _ProductColorsCardState extends State<ProductColorsCard> {
  final Set<String> _selected = {};
  final Map<String, _ColorStockConfig> _colorStock = {};

  static const List<_ColorOption> _allColors = [
    _ColorOption('White', Color(0xFFFFFFFF)),
    _ColorOption('Black', Color(0xFF111111)),
    _ColorOption('Blue', Color(0xFF1E88E5)),
    _ColorOption('Orange', Color(0xFFFF9800)),
    _ColorOption('Red', Color(0xFFE53935)),
    _ColorOption('Green', Color(0xFF43A047)),
    _ColorOption('Yellow', Color(0xFFFDD835)),
    _ColorOption('Purple', Color(0xFF8E24AA)),
    _ColorOption('Pink', Color(0xFFD81B60)),
    _ColorOption('Gray', Color(0xFF9E9E9E)),
    _ColorOption('Silver', Color(0xFFB0BEC5)),
    _ColorOption('Gold', Color(0xFFFFC107)),
  ];

  void _toggleColor(String name) {
    setState(() {
      if (_selected.contains(name)) {
        _selected.remove(name);
        _colorStock.remove(name)?.dispose();
      } else {
        _selected.add(name);
        _colorStock.putIfAbsent(name, () => _ColorStockConfig());
      }
    });
    _notify();
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialColors != null && widget.initialColors!.isNotEmpty) {
      for (final stock in widget.initialColors!) {
        _selected.add(stock.colorName);
        _colorStock[stock.colorName] = _ColorStockConfig(
          qty: stock.quantity.toString(),
          unlimited: stock.unlimited,
        );
      }
    } else {
      // Default initial colors for new products
      final defaults = {'White', 'Black', 'Blue', 'Orange'};
      for (final color in defaults) {
        _selected.add(color);
        _colorStock[color] = _ColorStockConfig();
      }
    }
  }

  @override
  void dispose() {
    for (final entry in _colorStock.values) {
      entry.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProductFormSection(
      title: 'Available Colors',
      icon: Icons.palette_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose colors, then set quantity per color or mark it as unlimited',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary.withValues(alpha: 0.8),
            ),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: _allColors.map((option) {
              final isSelected = _selected.contains(option.name);
              return _ColorChoiceChip(
                option: option,
                selected: isSelected,
                onTap: () => _toggleColor(option.name),
              );
            }).toList(),
          ),
          SizedBox(height: 16.h),
          if (_selected.isEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
              ),
              child: Text(
                'No colors selected yet.',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary.withValues(alpha: 0.8),
                ),
              ),
            )
          else
            Column(
              children: _selected.map((name) {
                final option = _allColors.firstWhere((o) => o.name == name);
                final config = _colorStock.putIfAbsent(name, _ColorStockConfig.new);
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: _ColorStockRow(
                    option: option,
                    config: config,
                    onUnlimitedChanged: (value) {
                      setState(() {
                        config.unlimited = value;
                        if (value) config.qtyCtrl.text = '0';
                      });
                      _notify();
                    },
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  void _notify() {
    final result = _selected.map((name) {
      final option = _allColors.firstWhere((e) => e.name == name);
      final config = _colorStock[name] ?? _ColorStockConfig();
      return ProductColorStock(
        colorName: name,
        colorHex: '#${option.color.value.toRadixString(16).substring(2).toUpperCase()}',
        quantity: int.tryParse(config.qtyCtrl.text) ?? 0,
        unlimited: config.unlimited,
      );
    }).toList();
    widget.onChanged?.call(result);
  }
}

class _ColorChoiceChip extends StatelessWidget {
  const _ColorChoiceChip({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _ColorOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.10)
              : const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : Colors.black.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14.w,
              height: 14.h,
              decoration: BoxDecoration(
                color: option.color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black.withValues(alpha: 0.15)),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              option.name,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            if (selected) ...[
              SizedBox(width: 6.w),
              Icon(Icons.check_circle, size: 14.sp, color: AppColors.primary),
            ],
          ],
        ),
      ),
    );
  }
}

class _ColorOption {
  const _ColorOption(this.name, this.color);
  final String name;
  final Color color;
}

class _ColorStockConfig {
  _ColorStockConfig({String qty = '0', this.unlimited = false})
      : qtyCtrl = TextEditingController(text: qty);

  final TextEditingController qtyCtrl;
  bool unlimited;

  void dispose() {
    qtyCtrl.dispose();
  }
}

class _ColorStockRow extends StatelessWidget {
  const _ColorStockRow({
    required this.option,
    required this.config,
    required this.onUnlimitedChanged,
  });

  final _ColorOption option;
  final _ColorStockConfig config;
  final ValueChanged<bool> onUnlimitedChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 16.w,
            height: 16.h,
            decoration: BoxDecoration(
              color: option.color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black.withValues(alpha: 0.2)),
            ),
          ),
          SizedBox(width: 8.w),
          SizedBox(
            width: 70.w,
            child: Text(
              option.name,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const Spacer(),
          Text(
            'Unlimited',
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textSecondary.withValues(alpha: 0.9),
            ),
          ),
          SizedBox(width: 6.w),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: config.unlimited,
              onChanged: onUnlimitedChanged,
              activeTrackColor: AppColors.success.withValues(alpha: 0.2),
              activeThumbColor: AppColors.success,
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            width: 92.w,
            height: 42.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
            ),
            child: TextField(
              controller: config.qtyCtrl,
              onChanged: (_) => onUnlimitedChanged(config.unlimited),
              enabled: !config.unlimited,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
              decoration: InputDecoration(
                hintText: '0',
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
