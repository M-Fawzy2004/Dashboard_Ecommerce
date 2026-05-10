import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_spacing.dart';
import 'common/product_form_section.dart';

class ProductBasicDetailsCard extends StatefulWidget {
  const ProductBasicDetailsCard({
    super.key,
    this.initialName,
    this.initialDescription,
    this.onChanged,
  });

  final String? initialName;
  final String? initialDescription;
  final void Function(String name, String description)? onChanged;

  @override
  State<ProductBasicDetailsCard> createState() => _ProductBasicDetailsCardState();
}

class _ProductBasicDetailsCardState extends State<ProductBasicDetailsCard> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialName);
    _descCtrl = TextEditingController(text: widget.initialDescription);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProductFormSection(
      title: 'Basic Details',
      icon: Icons.article_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProductFormLabel('Product Name'),
          FormInputField(
            controller: _nameCtrl,
            hint: 'e.g. Premium Leather Jacket',
            onChanged: (_) => widget.onChanged?.call(_nameCtrl.text, _descCtrl.text),
          ),
          AppSpacing.v20,
          const ProductFormLabel('Product Description'),
          FormTextAreaField(
            controller: _descCtrl,
            hint: 'Describe features, specs and highlights...',
            onChanged: (_) => widget.onChanged?.call(_nameCtrl.text, _descCtrl.text),
          ),
        ],
      ),
    );
  }
}

// ─── Input Field ─────────────────────────────────────────────────────────────

class FormInputField extends StatelessWidget {
  const FormInputField({
    super.key,
    this.controller,
    required this.hint,
    this.keyboardType,
    this.onChanged,
    this.prefixIcon,
    this.suffix,
  });

  final TextEditingController? controller;
  final String hint;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final IconData? prefixIcon;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      textAlignVertical: TextAlignVertical.center,
      style: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 13.sp,
          color: Colors.white.withOpacity(0.15),
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 18.sp, color: Colors.white.withOpacity(0.2)) : null,
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white.withOpacity(0.03),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.04)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.04)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      ),
    );
  }
}

// ─── TextArea ────────────────────────────────────────────────────────────────

class FormTextAreaField extends StatelessWidget {
  const FormTextAreaField({
    super.key,
    this.controller,
    required this.hint,
    this.onChanged,
  });

  final TextEditingController? controller;
  final String hint;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: 5,
      style: TextStyle(
        fontSize: 13.sp,
        color: Colors.white,
        fontWeight: FontWeight.w400,
        height: 1.6,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 13.sp,
          color: Colors.white.withOpacity(0.15),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.03),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.04)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.04)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        contentPadding: EdgeInsets.all(16.r),
      ),
    );
  }
}
