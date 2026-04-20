import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/theme/app_colors.dart';

class OrdersTotalsRow extends StatelessWidget {
  const OrdersTotalsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = <_OrderTotal>[
      _OrderTotal('all_orders', '1,284', AppColors.electricBlue),
      _OrderTotal('processing', '146', AppColors.warning),
      _OrderTotal('completed', '1,032', AppColors.success),
      _OrderTotal('cancelled', '106', Colors.redAccent),
    ];
    return Row(
      children: cards
          .map(
            (item) => Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.only(end: 12.w),
                child: Container(
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: AppColors.slate,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: item.color.withValues(alpha: 0.35)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.label.tr(), style: Theme.of(context).textTheme.bodyMedium),
                      SizedBox(height: 6.h),
                      Text(
                        item.value,
                        style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700, color: item.color),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _OrderTotal {
  const _OrderTotal(this.label, this.value, this.color);

  final String label;
  final String value;
  final Color color;
}
