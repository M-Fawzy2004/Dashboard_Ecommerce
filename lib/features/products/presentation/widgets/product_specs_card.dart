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
      trailing: TextButton.icon(
        onPressed: _addSpec,
        icon: Icon(Icons.add_circle_outline, size: 16.sp, color: AppColors.primary),
        label: Text('Add Field', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: AppColors.primary)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_specs.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Text(
                  'No specifications added yet.\nE.g. RAM: 16GB, Material: Cotton',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary.withValues(alpha: 0.5), height: 1.5),
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
                      hint: 'Feature (e.g. RAM)',
                      onChanged: (_) => _notify(),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    flex: 3,
                    child: _SpecInput(
                      controller: _specs[i].value,
                      hint: 'Value (e.g. 16GB)',
                      onChanged: (_) => _notify(),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: () => _removeSpec(i),
                    child: Icon(Icons.remove_circle_outline, color: AppColors.error.withValues(alpha: 0.6), size: 20.sp),
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
      height: 60.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 12.sp, color: Colors.black26),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
        ),
      ),
    );
  }
}
