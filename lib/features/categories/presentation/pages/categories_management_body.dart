import 'package:dashboard_ecommerce/features/products/presentation/model/category_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard_ecommerce/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/theme/app_spacing.dart';
import '../widgets/add_category_dialog.dart';
import '../widgets/category_card.dart';
import '../widgets/category_stat_chip.dart';

class CategoriesManagementBody extends StatefulWidget {
  const CategoriesManagementBody({super.key});

  @override
  State<CategoriesManagementBody> createState() => _CategoriesManagementBodyState();
}

class _CategoriesManagementBodyState extends State<CategoriesManagementBody> {
  // ── Actions ────────────────────────────────────────────────────────────────

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (_) => AddCategoryDialog(
        onAdd: (config) {
          context.read<CategoriesCubit>().addCategory(config);
        },
      ),
    );
  }

  void _confirmDelete(CategoryConfig cat) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
          side: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20.sp),
            ),
            SizedBox(width: 12.w),
            Text('Delete Category', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: Colors.white)),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${cat.label}"? This cannot be undone.',
          style: TextStyle(fontSize: 13.sp, color: Colors.white.withOpacity(0.6)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.5))),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<CategoriesCubit>().deleteCategory(cat.id);
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
            ),
            child: Text('Delete', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        if (state.isLoading && state.categories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              AppSpacing.v25,
              _buildStats(state.categories),
              AppSpacing.v25,
              _buildGrid(state.categories),
              AppSpacing.v25,
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Categories',
                  style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w900, color: Colors.white)),
              SizedBox(height: 4.h),
              Text('Manage product categories used across the store',
                  style: TextStyle(fontSize: 13.sp, color: Colors.white.withOpacity(0.4))),
            ],
          ),
        ),
        FilledButton.icon(
          onPressed: _showAddDialog,
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('Add Category'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            textStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  Widget _buildStats(List<CategoryConfig> categories) {
    return Wrap(
      spacing: 14.w,
      runSpacing: 14.h,
      children: [
        CategoryStatChip(
          icon: Icons.category_rounded,
          label: 'Total Categories',
          value: '${categories.length}',
          color: AppColors.primary,
        ),
        CategoryStatChip(
          icon: Icons.add_box_outlined,
          label: 'Custom Added',
          value: '${categories.where((c) => c.id.startsWith('custom_')).length}',
          color: AppColors.success,
        ),
        CategoryStatChip(
          icon: Icons.lock_outlined,
          label: 'System Default',
          value: '${categories.where((c) => !c.id.startsWith('custom_')).length}',
          color: Colors.white.withOpacity(0.5),
        ),
      ],
    );
  }

  Widget _buildGrid(List<CategoryConfig> categories) {
    return LayoutBuilder(builder: (context, constraints) {
      int crossAxisCount = 4;
      if (constraints.maxWidth < 500) {
        crossAxisCount = 2;
      } else if (constraints.maxWidth < 800) {
        crossAxisCount = 3;
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 14.w,
          mainAxisSpacing: 14.h,
          mainAxisExtent: 150.h,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return CategoryCard(
            config: cat,
            isCustom: cat.id.startsWith('custom_'),
            onDelete: () => _confirmDelete(cat),
          );
        },
      );
    });
  }
}
