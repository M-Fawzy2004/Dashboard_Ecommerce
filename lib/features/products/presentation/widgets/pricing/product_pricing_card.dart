import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/theme/app_spacing.dart';
import '../common/product_form_section.dart';

class ProductPricingCard extends StatefulWidget {
  const ProductPricingCard({super.key});

  @override
  State<ProductPricingCard> createState() => _ProductPricingCardState();
}

class _ProductPricingCardState extends State<ProductPricingCard> {
  final _priceCtrl = TextEditingController();
  final _salePriceCtrl = TextEditingController();

  static final _currencies = [
    {'code': 'USD', 'flag': '🇺🇸', 'symbol': r'$'},
    {'code': 'EGP', 'flag': '🇪🇬', 'symbol': 'EGP'},
    {'code': 'EUR', 'flag': '🇪🇺', 'symbol': '€'},
    {'code': 'GBP', 'flag': '🇬🇧', 'symbol': '£'},
  ];

  Map<String, String> _selectedCurrency = _currencies[0];

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
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                '-${_discountPercent.toStringAsFixed(0)}% OFF',
                style: TextStyle(
                  color: AppColors.success,
                  fontSize: 11.sp,
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
              if (constraints.maxWidth < 600) {
                return Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ProductFormLabel('Base Price'),
                        _PriceInput(
                          controller: _priceCtrl,
                          currency: _selectedCurrency,
                          onCurrencyTap: _showCurrencyPicker,
                          onChanged: (_) => setState(() {}),
                        ),
                      ],
                    ),
                    AppSpacing.v16,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ProductFormLabel('Discounted Price', isOptional: true),
                        _PriceInput(
                          controller: _salePriceCtrl,
                          currency: _selectedCurrency,
                          hint: 'E.g. 899',
                          isSale: true,
                          onChanged: (_) => setState(() {}),
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
                        const ProductFormLabel('Base Price'),
                        _PriceInput(
                          controller: _priceCtrl,
                          currency: _selectedCurrency,
                          onCurrencyTap: _showCurrencyPicker,
                          onChanged: (_) => setState(() {}),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ProductFormLabel('Discounted Price', isOptional: true),
                        _PriceInput(
                          controller: _salePriceCtrl,
                          currency: _selectedCurrency,
                          hint: 'E.g. 899',
                          isSale: true,
                          onChanged: (_) => setState(() {}),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          if (_discountPercent > 0) ...[
            AppSpacing.v16,
            _DiscountInfoBar(
              currencySymbol: _selectedCurrency['symbol']!,
              discountAmount: (double.tryParse(_priceCtrl.text) ?? 0) -
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
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (context) => Container(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select Currency', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800)),
            AppSpacing.v16,
            ..._currencies.map((c) => ListTile(
                  leading: Text(c['flag']!, style: TextStyle(fontSize: 20.sp)),
                  title: Text(c['code']!, style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: _selectedCurrency == c ? Icon(Icons.check_circle, color: AppColors.primary) : null,
                  onTap: () {
                    setState(() => _selectedCurrency = c);
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
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
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onCurrencyTap,
            child: Container(
              width: 65.w,
              margin: EdgeInsets.all(6.r),
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 4)],
              ),
              child: Center(
                child: Text(
                  currency['symbol']!,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    color: isSale ? AppColors.success : AppColors.primary,
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
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(fontSize: 14.sp, color: Colors.black26),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class _DiscountInfoBar extends StatelessWidget {
  const _DiscountInfoBar({required this.currencySymbol, required this.discountAmount});
  final String currencySymbol;
  final double discountAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(Icons.stars_rounded, color: AppColors.success, size: 16.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'Customers will save $currencySymbol${discountAmount.toStringAsFixed(2)} on this purchase',
              style: TextStyle(fontSize: 12.sp, color: AppColors.success, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
