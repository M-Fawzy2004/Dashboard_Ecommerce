import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dashboard_ecommerce/features/products/presentation/model/category_config.dart';
import '../../../../../shared/theme/app_colors.dart';

class CategoryCard extends StatefulWidget {
  const CategoryCard({
    super.key,
    required this.config,
    required this.isCustom,
    required this.onDelete,
  });

  final CategoryConfig config;
  final bool isCustom;
  final VoidCallback onDelete;

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: _hovered
                ? AppColors.primary.withOpacity(0.3)
                : Colors.white.withOpacity(0.04),
          ),
          boxShadow: [
            BoxShadow(
              color: _hovered
                  ? AppColors.primary.withOpacity(0.08)
                  : Colors.black.withOpacity(0.2),
              blurRadius: _hovered ? 20 : 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            _buildContent(),
            _buildDeleteButton(),
            if (widget.isCustom) _buildNewBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Icon(widget.config.icon, size: 22.sp, color: AppColors.primary),
          ),
          SizedBox(height: 10.h),
          Text(
            widget.config.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w800, color: Colors.white),
          ),
          SizedBox(height: 4.h),
          Text(
            widget.isCustom ? 'Custom' : 'System',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: widget.isCustom ? AppColors.success : Colors.white.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Positioned(
      top: 8.h,
      right: 8.w,
      child: AnimatedOpacity(
        opacity: _hovered ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: GestureDetector(
          onTap: widget.onDelete,
          child: Container(
            width: 26.w,
            height: 26.h,
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.error.withOpacity(0.2)),
            ),
            child: Icon(Icons.delete_outline_rounded, size: 14.sp, color: AppColors.error),
          ),
        ),
      ),
    );
  }

  Widget _buildNewBadge() {
    return Positioned(
      top: 8.h,
      left: 8.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: AppColors.success.withOpacity(0.2)),
        ),
        child: Text(
          'NEW',
          style: TextStyle(
            fontSize: 8.sp,
            fontWeight: FontWeight.w900,
            color: AppColors.success,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
