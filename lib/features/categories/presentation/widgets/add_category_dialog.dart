import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dashboard_ecommerce/features/products/presentation/model/category_config.dart';
import '../../../../../shared/theme/app_colors.dart';
import 'category_toggle_chip.dart';

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({super.key, required this.onAdd});

  final ValueChanged<CategoryConfig> onAdd;

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _nameCtrl = TextEditingController();
  IconData _selectedIcon = Icons.category_rounded;
  bool _showColors = false;
  bool _showSizes = false;
  bool _showMaterial = false;

  static final _iconOptions = [
    Icons.category_rounded, Icons.checkroom_rounded, Icons.smartphone_rounded,
    Icons.laptop_mac_rounded, Icons.kitchen_rounded, Icons.sports_soccer_rounded,
    Icons.toys_rounded, Icons.book_outlined, Icons.local_grocery_store_rounded,
    Icons.directions_car_rounded, Icons.favorite_rounded, Icons.home_rounded,
    Icons.pets_rounded, Icons.music_note_rounded, Icons.camera_alt_rounded,
    Icons.headphones_rounded, Icons.watch_rounded, Icons.shopping_bag_rounded,
    Icons.baby_changing_station_rounded, Icons.grade_outlined,
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    widget.onAdd(CategoryConfig(
      id: 'custom_${name.toLowerCase().replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}',
      label: name,
      icon: _selectedIcon,
      showSizes: _showSizes,
      showColors: _showColors,
      showStorageOptions: false,
      showRam: false,
      showScreenSize: false,
      showProcessor: false,
      showEnergyRating: false,
      showMaterial: _showMaterial,
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(maxWidth: 480.w),
        padding: EdgeInsets.all(28.r),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 40, offset: const Offset(0, 20))],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 24.h),
              _buildNameField(),
              SizedBox(height: 20.h),
              _buildIconPicker(),
              SizedBox(height: 20.h),
              _buildToggles(),
              SizedBox(height: 28.h),
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 40.w, height: 40.h,
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12.r), border: Border.all(color: AppColors.primary.withOpacity(0.2))),
          child: Icon(Icons.add_rounded, color: AppColors.primary, size: 20.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('New Category', style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w800, color: Colors.white)),
            Text('Add a custom product category', style: TextStyle(fontSize: 12.sp, color: Colors.white.withOpacity(0.4))),
          ]),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded),
          style: IconButton.styleFrom(foregroundColor: Colors.white.withOpacity(0.5)),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category Name', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: Colors.white)),
        SizedBox(height: 8.h),
        TextField(
          controller: _nameCtrl,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(fontSize: 14.sp, color: Colors.white),
          decoration: InputDecoration(
            hintText: 'e.g. Garden & Outdoor',
            hintStyle: TextStyle(fontSize: 13.sp, color: Colors.white.withOpacity(0.3)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.02),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: Colors.white.withOpacity(0.05))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: Colors.white.withOpacity(0.05))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: AppColors.primary, width: 1.5)),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          ),
        ),
      ],
    );
  }

  Widget _buildIconPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choose Icon', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: Colors.white)),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.01),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: Colors.white.withOpacity(0.04)),
          ),
          child: Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _iconOptions.map((icon) {
              final isSelected = _selectedIcon == icon;
              return GestureDetector(
                onTap: () => setState(() => _selectedIcon = icon),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: 38.w, height: 38.h,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withOpacity(0.15) : Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: isSelected ? AppColors.primary.withOpacity(0.5) : Colors.white.withOpacity(0.05)),
                    boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 8)] : null,
                  ),
                  child: Icon(icon, size: 18.sp, color: isSelected ? AppColors.primary : Colors.white.withOpacity(0.4)),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildToggles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Product Fields', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: Colors.white)),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 8.h,
          children: [
            CategoryToggleChip(label: 'Colors', value: _showColors, onChanged: (v) => setState(() => _showColors = v)),
            CategoryToggleChip(label: 'Sizes', value: _showSizes, onChanged: (v) => setState(() => _showSizes = v)),
            CategoryToggleChip(label: 'Material', value: _showMaterial, onChanged: (v) => setState(() => _showMaterial = v)),
          ],
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white.withOpacity(0.7),
              side: BorderSide(color: Colors.white.withOpacity(0.1)),
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            child: Text('Cancel', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: FilledButton(
            onPressed: _submit,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            child: Text('Add Category', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }
}
