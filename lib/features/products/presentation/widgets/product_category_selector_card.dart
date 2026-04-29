import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../features/categories/presentation/cubit/categories_cubit.dart';
import '../../../../../shared/theme/app_colors.dart';
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
            return const Center(child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ));
          }
          
          final categories = state.categories;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose a category to see the relevant fields for your product.',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary.withValues(alpha: 0.6),
                ),
              ),
              AppSpacing.v16,
              if (categories.isEmpty)
                Text('No categories found. Add one in the Categories section.', 
                  style: TextStyle(fontSize: 12.sp, color: AppColors.error))
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 90.w,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.h,
                    childAspectRatio: 1.1,
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
                AppSpacing.v16,
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : Colors.black.withValues(alpha: 0.05),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              config.icon,
              size: 18.sp,
              color: isSelected
                  ? Colors.white
                  : AppColors.primary.withValues(alpha: 0.8),
            ),
            SizedBox(height: 4.h),
            Text(
              config.label.split(' ').first,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textPrimary,
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
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            Icon(config.icon, size: 16.sp, color: AppColors.primary),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                config.label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
            _ActiveFeatureChips(config: config),
          ],
        ),
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
      spacing: 4.w,
      children: features
          .take(4)
          .map((f) => Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Text(
                  f,
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ))
          .toList(),
    );
  }
}
