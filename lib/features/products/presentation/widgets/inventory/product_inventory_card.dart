import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/theme/app_spacing.dart';
import '../common/product_form_section.dart';

class ProductInventoryCard extends StatefulWidget {
  const ProductInventoryCard({super.key, this.onChanged});

  final void Function({
    required int? stockQty,
    required bool unlimitedStock,
    required String stockStatus,
    required String? sku,
    required bool isFeatured,
  })? onChanged;

  @override
  State<ProductInventoryCard> createState() => _ProductInventoryCardState();
}

class _ProductInventoryCardState extends State<ProductInventoryCard> {
  final _stockCtrl = TextEditingController();
  final _skuCtrl = TextEditingController();

  bool _unlimitedStock = true;
  bool _isFeatured = false;
  String _stockStatus = 'In Stock';

  static const _statusOptions = [
    {'label': 'In Stock', 'color': Color(0xFF10B981)},
    {'label': 'Out of Stock', 'color': Color(0xFFEF4444)},
    {'label': 'Pre-order', 'color': Color(0xFFF59E0B)},
  ];

  @override
  void dispose() {
    _stockCtrl.dispose();
    _skuCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProductFormSection(
      title: 'Inventory & Stock',
      icon: Icons.inventory_2_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                return Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ProductFormLabel('Stock Quantity'),
                        _StockInput(
                          controller: _stockCtrl,
                          unlimited: _unlimitedStock,
                          onToggle: (v) {
                            setState(() => _unlimitedStock = v);
                            _notify();
                          },
                        ),
                      ],
                    ),
                    AppSpacing.v16,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ProductFormLabel('Stock Status'),
                        _StatusSelector(
                          currentStatus: _stockStatus,
                          options: _statusOptions,
                          onChanged: (v) {
                            setState(() => _stockStatus = v);
                            _notify();
                          },
                        ),
                      ],
                    ),
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ProductFormLabel('Stock Quantity'),
                        _StockInput(
                          controller: _stockCtrl,
                          unlimited: _unlimitedStock,
                          onToggle: (v) {
                            setState(() => _unlimitedStock = v);
                            _notify();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ProductFormLabel('Stock Status'),
                        _StatusSelector(
                          currentStatus: _stockStatus,
                          options: _statusOptions,
                          onChanged: (v) {
                            setState(() => _stockStatus = v);
                            _notify();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          AppSpacing.v20,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ProductFormLabel('SKU / Serial', isOptional: true),
                    _SimpleInput(
                      controller: _skuCtrl,
                      hint: 'E.g. IPH-15-PRO-BLK',
                      onChanged: (_) => _notify(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.v25,
          Divider(height: 1, color: Colors.black.withValues(alpha: 0.05)),
          AppSpacing.v20,
          _FeatureToggle(
            value: _isFeatured,
            onChanged: (v) {
              setState(() => _isFeatured = v);
              _notify();
            },
          ),
        ],
      ),
    );
  }

  void _notify() {
    widget.onChanged?.call(
      stockQty: int.tryParse(_stockCtrl.text),
      unlimitedStock: _unlimitedStock,
      stockStatus: _stockStatus,
      sku: _skuCtrl.text.trim().isEmpty ? null : _skuCtrl.text.trim(),
      isFeatured: _isFeatured,
    );
  }
}

class _StockInput extends StatelessWidget {
  const _StockInput({required this.controller, required this.unlimited, required this.onToggle});
  final TextEditingController controller;
  final bool unlimited;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: unlimited
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 18.h),
                    child: Text('Unlimited Stock', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.success)),
                  )
                : TextField(
                    controller: controller,
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
                    decoration: InputDecoration(
                      hintText: '0',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 18.h),
                    ),
                  ),
          ),
          Container(height: 30.h, width: 1, color: Colors.black12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Transform.scale(
              scale: 0.8,
              child: Switch(
                value: unlimited,
                onChanged: onToggle,
                activeTrackColor: AppColors.success.withValues(alpha: 0.2),
                activeThumbColor: AppColors.success,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusSelector extends StatelessWidget {
  const _StatusSelector({required this.currentStatus, required this.options, required this.onChanged});
  final String currentStatus;
  final List<Map<String, dynamic>> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final active = options.firstWhere((o) => o['label'] == currentStatus);
    return PopupMenuButton<String>(
      onSelected: onChanged,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        height: 60.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            Container(width: 8.w, height: 8.h, decoration: BoxDecoration(color: active['color'] as Color, shape: BoxShape.circle)),
            SizedBox(width: 10.w),
            Expanded(child: Text(currentStatus, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700))),
            Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black38, size: 20.sp),
          ],
        ),
      ),
      itemBuilder: (ctx) => options
          .map((o) => PopupMenuItem(
                value: o['label'] as String,
                child: Row(
                  children: [
                    Container(width: 6.w, height: 6.h, decoration: BoxDecoration(color: o['color'] as Color, shape: BoxShape.circle)),
                    SizedBox(width: 12.w),
                    Text(o['label'] as String, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

class _SimpleInput extends StatelessWidget {
  const _SimpleInput({
    required this.controller,
    required this.hint,
    this.onChanged,
  });
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black26),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        ),
      ),
    );
  }
}

class _FeatureToggle extends StatelessWidget {
  const _FeatureToggle({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10.r)),
              child: Icon(Icons.star_rounded, color: AppColors.primary, size: 20.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Featured Product', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700)),
                  Text('Display this product in your homepage highlights', style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary)),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeTrackColor: AppColors.primary.withValues(alpha: 0.2),
              activeThumbColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
