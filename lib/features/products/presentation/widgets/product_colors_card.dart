import 'package:dashboard_ecommerce/shared/widgets/hover_button.dart';
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
              fontSize: 13.sp,
              color: Colors.white.withOpacity(0.3),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 16.h),
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
          SizedBox(height: 24.h),
          if (_selected.isEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.02),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Text(
                'No colors selected yet.',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
            )
          else
            Column(
              children: _selected.map((name) {
                final option = _allColors.firstWhere((o) => o.name == name);
                final config = _colorStock.putIfAbsent(name, _ColorStockConfig.new);
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
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
    return HoverButton(
      onTap: onTap,
      borderRadius: 999.r,
      active: selected,
      activeColor: Colors.white.withOpacity(0.08),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: selected ? Colors.white.withOpacity(0.15) : Colors.white.withOpacity(0.04),
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
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              option.name,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? Colors.white : Colors.white.withOpacity(0.35),
              ),
            ),
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
  _ColorStockConfig({String qty = '0', this.unlimited = false}) : qtyCtrl = TextEditingController(text: qty);

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
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Row(
        children: [
          Container(
            width: 18.w,
            height: 18.h,
            decoration: BoxDecoration(
              color: option.color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              option.name,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            'Unlimited',
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.white.withOpacity(0.2),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 8.w),
          SizedBox(
            height: 24.h,
            child: Transform.scale(
              scale: 0.7,
              child: Switch(
                value: config.unlimited,
                onChanged: onUnlimitedChanged,
                activeTrackColor: AppColors.primary.withOpacity(0.3),
                activeColor: AppColors.primary,
                inactiveTrackColor: Colors.white.withOpacity(0.05),
                inactiveThumbColor: Colors.white.withOpacity(0.2),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            width: 80.w,
            height: 38.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: TextField(
              controller: config.qtyCtrl,
              onChanged: (_) => onUnlimitedChanged(config.unlimited),
              enabled: !config.unlimited,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: config.unlimited ? Colors.white.withOpacity(0.1) : Colors.white,
              ),
              decoration: const InputDecoration(
                hintText: '0',
                hintStyle: TextStyle(color: Colors.white10),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
