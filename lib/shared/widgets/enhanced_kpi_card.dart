import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class EnhancedKpiCard extends StatefulWidget {
  const EnhancedKpiCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.value,
    this.trend,
    this.isPositive = true,
    this.previousValue,
    this.isMultiValue = false,
    this.multiValues,
    this.onDetailsPressed,
    this.showDetailsButton = true,
  });

  final String title;
  final String subtitle;
  final String? value;
  final String? trend;
  final bool isPositive;
  final String? previousValue;
  final bool isMultiValue;
  final List<Map<String, String>>? multiValues;
  final VoidCallback? onDetailsPressed;
  final bool showDetailsButton;

  @override
  State<EnhancedKpiCard> createState() => _EnhancedKpiCardState();
}

class _EnhancedKpiCardState extends State<EnhancedKpiCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: _hovered
                ? Colors.white.withOpacity(0.08)
                : Colors.white.withOpacity(0.04),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              AppSpacing.v20,
              widget.isMultiValue
                  ? _buildMultiValue(context)
                  : _buildSingleValue(),
              if (widget.showDetailsButton) ...[
                AppSpacing.v20,
                _buildDetailsButton(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.subtitle.toUpperCase(),
              style: TextStyle(
                color: Colors.white.withOpacity(0.25),
                fontSize: 9.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              widget.title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Container(
          width: 30.r,
          height: 30.r,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            Icons.more_horiz_rounded,
            color: Colors.white.withOpacity(0.3),
            size: 16.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildSingleValue() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              widget.value!,
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            if (widget.trend != null) ...[
              SizedBox(width: 10.w),
              Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: _buildTrendBadge(widget.trend!, widget.isPositive),
              ),
            ],
          ],
        ),
        if (widget.previousValue != null) ...[
          SizedBox(height: 6.h),
          Text(
            widget.previousValue!,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.white.withOpacity(0.25),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMultiValue(BuildContext context) {
    return Row(
      children: widget.multiValues!.map((mv) {
        final isLast = mv == widget.multiValues!.last;
        return Expanded(
          child: Container(
            padding: EdgeInsets.only(right: isLast ? 0 : 16.w),
            decoration: isLast
                ? null
                : BoxDecoration(
                    border: Border(
                      right: BorderSide(color: Colors.white.withOpacity(0.06)),
                    ),
                  ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mv['label']!,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.25),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      mv['value']!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    if (mv.containsKey('trend') || mv.containsKey('sub')) ...[
                      SizedBox(width: 6.w),
                      Padding(
                        padding: EdgeInsets.only(bottom: 3.h),
                        child: _buildTrendBadge(
                          mv['sub'] ?? '',
                          mv['trend'] == 'up',
                          small: true,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTrendBadge(String label, bool isPositive, {bool small = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6.w : 8.w,
        vertical: small ? 3.h : 4.h,
      ),
      decoration: BoxDecoration(
        color: isPositive
            ? AppColors.success.withOpacity(0.12)
            : AppColors.error.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive
                ? Icons.arrow_upward_rounded
                : Icons.arrow_downward_rounded,
            color: isPositive ? AppColors.success : AppColors.error,
            size: small ? 10.sp : 11.sp,
          ),
          SizedBox(width: 2.w),
          Text(
            label,
            style: TextStyle(
              color: isPositive ? AppColors.success : AppColors.error,
              fontSize: small ? 10.sp : 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: widget.onDetailsPressed,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Details',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.arrow_forward_rounded,
                size: 12.sp,
                color: Colors.white.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
