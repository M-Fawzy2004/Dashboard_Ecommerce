import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_spacing.dart';
import 'common/product_form_section.dart';

class ProductShippingCard extends StatefulWidget {
  const ProductShippingCard({
    super.key,
    this.initialWeightKg,
    this.initialLengthCm,
    this.initialWidthCm,
    this.initialHeightCm,
    this.initialWeightUnit = 'kg',
    this.initialDimensionUnit = 'cm',
    this.onChanged,
  });

  final double? initialWeightKg;
  final double? initialLengthCm;
  final double? initialWidthCm;
  final double? initialHeightCm;
  final String? initialWeightUnit;
  final String? initialDimensionUnit;
  final void Function({
    required double? weightKg,
    required double? lengthCm,
    required double? widthCm,
    required double? heightCm,
    required String? weightUnit,
    required String? dimensionUnit,
  })?
  onChanged;

  @override
  State<ProductShippingCard> createState() => _ProductShippingCardState();
}

class _ProductShippingCardState extends State<ProductShippingCard> {
  static const List<String> _weightUnits = ['mg', 'g', 'kg', 'lb', 'oz', 'ton'];
  static const List<String> _dimensionUnits = [
    'mm',
    'cm',
    'm',
    'in',
    'ft',
    'yd',
  ];

  late final TextEditingController _weightCtrl;
  late final TextEditingController _lengthCtrl;
  late final TextEditingController _widthCtrl;
  late final TextEditingController _heightCtrl;
  late String? _weightUnit;
  late String? _dimensionUnit;

  @override
  void initState() {
    super.initState();
    _weightCtrl = TextEditingController(
      text: widget.initialWeightKg?.toString(),
    );
    _lengthCtrl = TextEditingController(
      text: widget.initialLengthCm?.toString(),
    );
    _widthCtrl = TextEditingController(text: widget.initialWidthCm?.toString());
    _heightCtrl = TextEditingController(
      text: widget.initialHeightCm?.toString(),
    );
    _weightUnit = widget.initialWeightUnit ?? 'kg';
    _dimensionUnit = widget.initialDimensionUnit ?? 'cm';
  }

  @override
  void dispose() {
    _weightCtrl.dispose();
    _lengthCtrl.dispose();
    _widthCtrl.dispose();
    _heightCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProductFormSection(
      title: 'Product Measurements',
      icon: Icons.straighten_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Product Weight',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              _UnitSelector(
                value: _weightUnit,
                options: _weightUnits,
                onChanged: (value) {
                  setState(() => _weightUnit = value);
                  _notify();
                },
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _ShippingInput(
            controller: _weightCtrl,
            hint: '0.00',
            suffix: _weightUnit ?? 'kg',
            onChanged: (_) => _notify(),
          ),
          AppSpacing.v25,
          Row(
            children: [
              Text(
                'Dimensions',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '(optional)',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              const Spacer(),
              _UnitSelector(
                value: _dimensionUnit,
                options: _dimensionUnits,
                onChanged: (value) {
                  setState(() => _dimensionUnit = value);
                  _notify();
                },
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _ShippingInput(
                  controller: _lengthCtrl,
                  hint: 'L',
                  suffix: _dimensionUnit ?? 'cm',
                  onChanged: (_) => _notify(),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _ShippingInput(
                  controller: _widthCtrl,
                  hint: 'W',
                  suffix: _dimensionUnit ?? 'cm',
                  onChanged: (_) => _notify(),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _ShippingInput(
                  controller: _heightCtrl,
                  hint: 'H',
                  suffix: _dimensionUnit ?? 'cm',
                  onChanged: (_) => _notify(),
                ),
              ),
            ],
          ),
          AppSpacing.v16,
          Text(
            'Used for product size details and logistics calculations.',
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.white.withOpacity(0.25),
            ),
          ),
        ],
      ),
    );
  }

  void _notify() {
    widget.onChanged?.call(
      weightKg: double.tryParse(_weightCtrl.text),
      lengthCm: double.tryParse(_lengthCtrl.text),
      widthCm: double.tryParse(_widthCtrl.text),
      heightCm: double.tryParse(_heightCtrl.text),
      weightUnit: _weightUnit ?? 'kg',
      dimensionUnit: _dimensionUnit ?? 'cm',
    );
  }
}

class _UnitSelector extends StatelessWidget {
  const _UnitSelector({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String? value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((option) {
          final selected = option == (value ?? options.first);
          return GestureDetector(
            onTap: () => onChanged(option),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withOpacity(0.05)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(7.r),
              ),
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected
                      ? Colors.white
                      : Colors.white.withOpacity(0.3),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ShippingInput extends StatelessWidget {
  const _ShippingInput({
    required this.controller,
    required this.hint,
    required this.suffix,
    this.onChanged,
  });
  final TextEditingController controller;
  final String hint;
  final String suffix;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              textAlignVertical: TextAlignVertical.center,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                isCollapsed: true,
                hintText: hint,
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.15)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Text(
              suffix,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
