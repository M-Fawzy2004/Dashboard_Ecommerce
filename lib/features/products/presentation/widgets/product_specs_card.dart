import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';
import 'common/product_form_section.dart';

class ProductSpecsCard extends StatefulWidget {
  const ProductSpecsCard({super.key});

  @override
  State<ProductSpecsCard> createState() => _ProductSpecsCardState();
}

class _ProductSpecsCardState extends State<ProductSpecsCard> {
  final List<MapEntry<TextEditingController, TextEditingController>> _specs = [];

  void _addSpec() {
    setState(() {
      _specs.add(MapEntry(TextEditingController(), TextEditingController()));
    });
  }

  void _removeSpec(int index) {
    setState(() {
      _specs[index].key.dispose();
      _specs[index].value.dispose();
      _specs.removeAt(index);
    });
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
                    child: _SpecInput(controller: _specs[i].key, hint: 'Feature (e.g. RAM)'),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    flex: 3,
                    child: _SpecInput(controller: _specs[i].value, hint: 'Value (e.g. 16GB)'),
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
}

class _SpecInput extends StatelessWidget {
  const _SpecInput({required this.controller, required this.hint});
  final TextEditingController controller;
  final String hint;

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
