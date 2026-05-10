import 'package:dashboard_ecommerce/shared/widgets/hover_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../features/categories/presentation/cubit/categories_cubit.dart';
import '../../../../../shared/theme/app_spacing.dart';
import '../model/category_config.dart';
import 'common/product_form_section.dart';

class ProductCategorySelectorCard extends StatelessWidget {
  const ProductCategorySelectorCard({
    super.key,
    required this.selectedConfig,
    required this.onCategorySelected,
  });

  final CategoryConfig? selectedConfig;
  final ValueChanged<CategoryConfig> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return ProductFormSection(
      title: 'Product Category',
      icon: Icons.category_outlined,
      child: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(40.r),
                child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ),
            );
          }

          final categories = state.categories;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose a category to see the relevant fields for your product.',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.white.withOpacity(0.3),
                  fontWeight: FontWeight.w400,
                ),
              ),
              AppSpacing.v20,
              if (categories.isEmpty)
                Text(
                  'No categories found. Add one in the Categories section.',
                  style: TextStyle(fontSize: 12.sp, color: Colors.redAccent.withOpacity(0.6)),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 100.w,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final isSelected = selectedConfig?.id == cat.id;
                    return _CategoryTile(
                      config: cat,
                      isSelected: isSelected,
                      onTap: () => onCategorySelected(cat),
                    );
                  },
                ),
              if (selectedConfig != null) ...[
                AppSpacing.v20,
                _ActiveCategoryBadge(config: selectedConfig!),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.config,
    required this.isSelected,
    required this.onTap,
  });

  final CategoryConfig config;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HoverButton(
      onTap: onTap,
      borderRadius: 14.r,
      active: isSelected,
      activeColor: Colors.white.withOpacity(0.08),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? Colors.white.withOpacity(0.15) : Colors.white.withOpacity(0.04),
            width: isSelected ? 1.2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              config.icon,
              size: 20.sp,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
            ),
            SizedBox(height: 8.h),
            Text(
              config.label.split(' ').first,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveCategoryBadge extends StatelessWidget {
  const _ActiveCategoryBadge({required this.config});
  final CategoryConfig config;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(config.icon, size: 16.sp, color: Colors.white.withOpacity(0.6)),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Category',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.25),
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  config.label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          _ActiveFeatureChips(config: config),
        ],
      ),
    );
  }
}

class _ActiveFeatureChips extends StatelessWidget {
  const _ActiveFeatureChips({required this.config});
  final CategoryConfig config;

  @override
  Widget build(BuildContext context) {
    final features = <String>[];
    if (config.showSizes) features.add('Sizes');
    if (config.showColors) features.add('Colors');
    if (config.showStorageOptions) features.add('Storage');
    if (config.showRam) features.add('RAM');
    if (config.showScreenSize) features.add('Screen');
    if (config.showProcessor) features.add('CPU');
    if (config.showEnergyRating) features.add('Energy');
    if (config.showMaterial) features.add('Material');

    return Wrap(
      spacing: 6.w,
      children: features
          .take(3)
          .map((f) => Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Text(
                  f,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ))
          .toList(),
    );
  }
}
