import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/theme/app_spacing.dart';
import 'common/product_form_section.dart';

class ProductShippingCard extends StatefulWidget {
  const ProductShippingCard({super.key, this.onChanged});

  final void Function({
    required double? weightKg,
    required double? lengthCm,
    required double? widthCm,
    required double? heightCm,
    required String? weightUnit,
    required String? dimensionUnit,
  })? onChanged;

  @override
  State<ProductShippingCard> createState() => _ProductShippingCardState();
}

class _ProductShippingCardState extends State<ProductShippingCard> {
  static const List<String> _weightUnits = [
    'mg',
    'g',
    'kg',
    'lb',
    'oz',
    'ton',
  ];
  static const List<String> _dimensionUnits = [
    'mm',
    'cm',
    'm',
    'in',
    'ft',
    'yd',
  ];

  final _weightCtrl = TextEditingController();
  final _lengthCtrl = TextEditingController();
  final _widthCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  String? _weightUnit = 'kg';
  String? _dimensionUnit = 'cm';

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
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
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
          SizedBox(height: 8.h),
          _ShippingInput(
            controller: _weightCtrl,
            hint: '0.00',
            suffix: _weightUnit ?? 'kg',
            onChanged: (_) => _notify(),
          ),
          AppSpacing.v20,
          Row(
            children: [
              Text(
                'Dimensions',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                '(optional)',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textSecondary.withValues(alpha: 0.75),
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
          SizedBox(height: 8.h),
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
            style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary.withValues(alpha: 0.6)),
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
      padding: EdgeInsets.all(3.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((option) {
          final selected = option == (value ?? options.first);
          return GestureDetector(
            onTap: () => onChanged(option),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: selected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: selected ? AppColors.primary : AppColors.textSecondary,
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
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.black26),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 18.h),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Text(
              suffix,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: AppColors.textSecondary.withValues(alpha: 0.4)),
            ),
          ),
        ],
      ),
    );
  }
}
