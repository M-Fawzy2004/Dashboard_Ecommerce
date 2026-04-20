import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/theme/app_spacing.dart';
import 'common/product_form_section.dart';

class ProductShippingCard extends StatefulWidget {
  const ProductShippingCard({super.key});

  @override
  State<ProductShippingCard> createState() => _ProductShippingCardState();
}

class _ProductShippingCardState extends State<ProductShippingCard> {
  final _weightCtrl = TextEditingController();
  final _lengthCtrl = TextEditingController();
  final _widthCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();

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
      title: 'Shipping & Dimensions',
      icon: Icons.local_shipping_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProductFormLabel('Product Weight (kg)'),
          _ShippingInput(controller: _weightCtrl, hint: '0.00', suffix: 'kg'),
          AppSpacing.v20,
          const ProductFormLabel('Dimensions (cm)', isOptional: true),
          Row(
            children: [
              Expanded(child: _ShippingInput(controller: _lengthCtrl, hint: 'L', suffix: 'cm')),
              SizedBox(width: 12.w),
              Expanded(child: _ShippingInput(controller: _widthCtrl, hint: 'W', suffix: 'cm')),
              SizedBox(width: 12.w),
              Expanded(child: _ShippingInput(controller: _heightCtrl, hint: 'H', suffix: 'cm')),
            ],
          ),
          AppSpacing.v16,
          Text(
            'Used to calculate shipping rates and box sizes during fulfillment.',
            style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary.withValues(alpha: 0.6)),
          ),
        ],
      ),
    );
  }
}

class _ShippingInput extends StatelessWidget {
  const _ShippingInput({required this.controller, required this.hint, required this.suffix});
  final TextEditingController controller;
  final String hint;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.black26),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              suffix,
              style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w800, color: AppColors.textSecondary.withValues(alpha: 0.4)),
            ),
          ),
        ],
      ),
    );
  }
}
