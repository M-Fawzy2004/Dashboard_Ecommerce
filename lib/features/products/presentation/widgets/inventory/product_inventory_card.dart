import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/theme/app_spacing.dart';
import '../common/product_form_section.dart';

class ProductInventoryCard extends StatefulWidget {
  const ProductInventoryCard({
    super.key,
    this.initialStockQty,
    this.initialUnlimitedStock = true,
    this.initialStockStatus = 'In Stock',
    this.initialSku,
    this.initialIsFeatured = false,
    this.onChanged,
  });

  final int? initialStockQty;
  final bool initialUnlimitedStock;
  final String initialStockStatus;
  final String? initialSku;
  final bool initialIsFeatured;
  final void Function({
    required int? stockQty,
    required bool unlimitedStock,
    required String stockStatus,
    required String? sku,
    required bool isFeatured,
  })?
  onChanged;

  @override
  State<ProductInventoryCard> createState() => _ProductInventoryCardState();
}

class _ProductInventoryCardState extends State<ProductInventoryCard> {
  late final TextEditingController _stockCtrl;
  late final TextEditingController _skuCtrl;

  late bool _unlimitedStock;
  late bool _isFeatured;
  late String _stockStatus;

  @override
  void initState() {
    super.initState();
    _stockCtrl = TextEditingController(
      text: widget.initialStockQty?.toString(),
    );
    _skuCtrl = TextEditingController(text: widget.initialSku);
    _unlimitedStock = widget.initialUnlimitedStock;
    _isFeatured = widget.initialIsFeatured;
    _stockStatus = widget.initialStockStatus;
  }

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
              final isWide = constraints.maxWidth > 600;
              final content = [
                Expanded(
                  flex: isWide ? 1 : 0,
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
                if (!isWide) AppSpacing.v16 else SizedBox(width: 20.w),
                Expanded(
                  flex: isWide ? 1 : 0,
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
              ];
              return isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: content,
                    )
                  : Column(children: content);
            },
          ),
          AppSpacing.v20,
          const ProductFormLabel('SKU / Serial', isOptional: true),
          _SimpleInput(
            controller: _skuCtrl,
            hint: 'e.g. IPH-15-PRO-BLK',
            onChanged: (_) => _notify(),
          ),
          AppSpacing.v25,
          Divider(height: 1, color: Colors.white.withOpacity(0.06)),
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
  const _StockInput({
    required this.controller,
    required this.unlimited,
    required this.onToggle,
  });
  final TextEditingController controller;
  final bool unlimited;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: unlimited
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      'Unlimited Stock',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.greenAccent.withOpacity(0.6),
                      ),
                    ),
                  )
                : TextField(
                    controller: controller,
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: '0',
                      hintStyle: TextStyle(color: Colors.white10),
                      border: InputBorder.none,
                      isCollapsed: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                    ),
                  ),
          ),
          Container(
            height: 24.h,
            width: 1,
            color: Colors.white.withOpacity(0.05),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Transform.scale(
              scale: 0.7,
              child: Switch(
                value: unlimited,
                onChanged: onToggle,
                activeTrackColor: AppColors.primary.withOpacity(0.3),
                activeColor: AppColors.primary,
                inactiveTrackColor: Colors.white.withOpacity(0.05),
                inactiveThumbColor: Colors.white.withOpacity(0.2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusSelector extends StatelessWidget {
  const _StatusSelector({
    required this.currentStatus,
    required this.options,
    required this.onChanged,
  });
  final String currentStatus;
  final List<Map<String, dynamic>> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final active = options.firstWhere((o) => o['label'] == currentStatus);
    return PopupMenuButton<String>(
      onSelected: onChanged,
      color: AppColors.card,
      elevation: 8,
      offset: const Offset(0, 56),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: Colors.white.withOpacity(0.05)),
      ),
      child: Container(
        height: 52.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Container(
              width: 8.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: active['color'] as Color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                currentStatus,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white.withOpacity(0.2),
              size: 18.sp,
            ),
          ],
        ),
      ),
      itemBuilder: (ctx) => options
          .map(
            (o) => PopupMenuItem(
              value: o['label'] as String,
              child: Row(
                children: [
                  Container(
                    width: 6.w,
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: o['color'] as Color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    o['label'] as String,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          )
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
      height: 60.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.15)),
          border: InputBorder.none,
          isCollapsed: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
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
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            Icons.star_rounded,
            color: Colors.amberAccent,
            size: 20.sp,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Featured Product',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                'Display this product in your homepage highlights',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 24.h,
          child: Transform.scale(
            scale: 0.7,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeTrackColor: AppColors.primary.withOpacity(0.3),
              activeColor: AppColors.primary,
              inactiveTrackColor: Colors.white.withOpacity(0.05),
              inactiveThumbColor: Colors.white.withOpacity(0.2),
            ),
          ),
        ),
      ],
    );
  }
}
