import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/theme/app_spacing.dart';
import '../common/product_form_section.dart';

class ProductPricingCard extends StatefulWidget {
  const ProductPricingCard({
    super.key,
    this.initialPrice,
    this.initialSalePrice,
    this.initialCurrency,
    this.onChanged,
  });

  final double? initialPrice;
  final double? initialSalePrice;
  final String? initialCurrency;
  final void Function({
    required double? price,
    required double? salePrice,
    required String currency,
  })?
  onChanged;

  @override
  State<ProductPricingCard> createState() => _ProductPricingCardState();
}

class _ProductPricingCardState extends State<ProductPricingCard> {
  late final TextEditingController _priceCtrl;
  late final TextEditingController _salePriceCtrl;

  static final _currencies = [
    {'code': 'USD', 'flag': '🇺🇸', 'symbol': r'$'},
    {'code': 'EGP', 'flag': '🇪🇬', 'symbol': 'EGP'},
    {'code': 'EUR', 'flag': '🇪🇺', 'symbol': '€'},
    {'code': 'GBP', 'flag': '🇬🇧', 'symbol': '£'},
  ];

  late Map<String, String> _selectedCurrency;

  @override
  void initState() {
    super.initState();
    _priceCtrl = TextEditingController(text: widget.initialPrice?.toString());
    _salePriceCtrl = TextEditingController(
      text: widget.initialSalePrice?.toString(),
    );
    _selectedCurrency = _currencies.firstWhere(
      (c) => c['code'] == (widget.initialCurrency ?? 'USD'),
      orElse: () => _currencies[0],
    );
  }

  double get _discountPercent {
    final p = double.tryParse(_priceCtrl.text) ?? 0;
    final s = double.tryParse(_salePriceCtrl.text) ?? 0;
    if (p <= 0 || s <= 0 || s >= p) return 0;
    return ((p - s) / p) * 100;
  }

  @override
  void dispose() {
    _priceCtrl.dispose();
    _salePriceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProductFormSection(
      title: 'Pricing Strategy',
      icon: Icons.auto_graph_rounded,
      trailing: _discountPercent > 0
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.greenAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                '-${_discountPercent.toStringAsFixed(0)}% OFF',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            )
          : null,
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
                      const ProductFormLabel('Base Price'),
                      _PriceInput(
                        controller: _priceCtrl,
                        currency: _selectedCurrency,
                        onCurrencyTap: _showCurrencyPicker,
                        onChanged: (_) {
                          setState(() {});
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
                      const ProductFormLabel(
                        'Discounted Price',
                        isOptional: true,
                      ),
                      _PriceInput(
                        controller: _salePriceCtrl,
                        currency: _selectedCurrency,
                        hint: 'e.g. 89.00',
                        isSale: true,
                        onChanged: (_) {
                          setState(() {});
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
          if (_discountPercent > 0) ...[
            AppSpacing.v16,
            _DiscountInfoBar(
              currencySymbol: _selectedCurrency['symbol']!,
              discountAmount:
                  (double.tryParse(_priceCtrl.text) ?? 0) -
                  (double.tryParse(_salePriceCtrl.text) ?? 0),
            ),
          ],
        ],
      ),
    );
  }

  void _showCurrencyPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Currency',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            AppSpacing.v20,
            ..._currencies.map(
              (c) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 40.w,
                  height: 40.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Text(c['flag']!, style: TextStyle(fontSize: 18.sp)),
                ),
                title: Text(
                  c['code']!,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
                trailing: _selectedCurrency == c
                    ? Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.primary,
                        size: 20.sp,
                      )
                    : null,
                onTap: () {
                  setState(() => _selectedCurrency = c);
                  _notify();
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  void _notify() {
    widget.onChanged?.call(
      price: double.tryParse(_priceCtrl.text),
      salePrice: double.tryParse(_salePriceCtrl.text),
      currency: _selectedCurrency['code'] ?? 'USD',
    );
  }
}

class _PriceInput extends StatelessWidget {
  const _PriceInput({
    required this.controller,
    required this.currency,
    this.onCurrencyTap,
    this.hint = '0.00',
    this.isSale = false,
    this.onChanged,
  });

  final TextEditingController controller;
  final Map<String, String> currency;
  final VoidCallback? onCurrencyTap;
  final String hint;
  final bool isSale;
  final ValueChanged<String>? onChanged;

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
          GestureDetector(
            onTap: onCurrencyTap,
            child: Container(
              width: 50.w,
              margin: EdgeInsets.all(6.r),
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Text(
                  currency['symbol']!,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    color: isSale
                        ? Colors.greenAccent
                        : Colors.white.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              textAlignVertical: TextAlignVertical.center,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                isCollapsed: true,
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.15),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscountInfoBar extends StatelessWidget {
  const _DiscountInfoBar({
    required this.currencySymbol,
    required this.discountAmount,
  });
  final String currencySymbol;
  final double discountAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.greenAccent.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.greenAccent.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            color: Colors.greenAccent,
            size: 16.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'Customers will save $currencySymbol${discountAmount.toStringAsFixed(2)} on this purchase',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.greenAccent.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
