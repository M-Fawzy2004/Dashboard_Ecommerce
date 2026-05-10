import 'package:dashboard_ecommerce/shared/widgets/hover_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';
import 'common/product_form_section.dart';

class ProductSpecsCard extends StatefulWidget {
  const ProductSpecsCard({
    super.key,
    this.initialSpecs,
    this.onChanged,
  });

  final Map<String, dynamic>? initialSpecs;
  final ValueChanged<Map<String, String>>? onChanged;

  @override
  State<ProductSpecsCard> createState() => _ProductSpecsCardState();
}

class _ProductSpecsCardState extends State<ProductSpecsCard> {
  final List<MapEntry<TextEditingController, TextEditingController>> _specs = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialSpecs != null) {
      widget.initialSpecs!.forEach((k, v) {
        _specs.add(MapEntry(TextEditingController(text: k), TextEditingController(text: v?.toString())));
      });
    }
  }

  void _addSpec() {
    setState(() {
      _specs.add(MapEntry(TextEditingController(), TextEditingController()));
    });
    _notify();
  }

  void _removeSpec(int index) {
    setState(() {
      _specs[index].key.dispose();
      _specs[index].value.dispose();
      _specs.removeAt(index);
    });
    _notify();
  }

  @override
  void dispose() {
    for (final spec in _specs) {
      spec.key.dispose();
      spec.value.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProductFormSection(
      title: 'Technical Specifications',
      icon: Icons.settings_suggest_outlined,
      trailing: HoverButton(
        onTap: _addSpec,
        borderRadius: 8.r,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded, size: 14.sp, color: AppColors.primary),
              SizedBox(width: 4.w),
              Text(
                'Add Field',
                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
            ],
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_specs.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30.h),
                child: Text(
                  'No specifications added yet.\ne.g. RAM: 16GB, Material: Cotton',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.15),
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ...List.generate(_specs.length, (i) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _SpecInput(
                      controller: _specs[i].key,
                      hint: 'Feature',
                      onChanged: (_) => _notify(),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    flex: 3,
                    child: _SpecInput(
                      controller: _specs[i].value,
                      hint: 'Value',
                      onChanged: (_) => _notify(),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: () => _removeSpec(i),
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close_rounded, color: Colors.redAccent.withOpacity(0.4), size: 16.sp),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  void _notify() {
    final specs = <String, String>{};
    for (final entry in _specs) {
      final k = entry.key.text.trim();
      final v = entry.value.text.trim();
      if (k.isNotEmpty) specs[k] = v;
    }
    widget.onChanged?.call(specs);
  }
}

class _SpecInput extends StatelessWidget {
  const _SpecInput({
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
      height: 52.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 12.sp, color: Colors.white.withOpacity(0.1)),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
      ),
    );
  }
}
