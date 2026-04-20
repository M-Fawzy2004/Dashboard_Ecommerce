import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/theme/app_colors.dart';

class RecentOrdersTable extends StatelessWidget {
  const RecentOrdersTable({super.key});

  @override
  Widget build(BuildContext context) {
    final rows = <_OrderRow>[
      _OrderRow('#ORD-9821', 'Sarah Ahmed', 'completed', '\$259.00'),
      _OrderRow('#ORD-9814', 'Omar Khaled', 'pending', '\$128.00'),
      _OrderRow('#ORD-9809', 'Nour Adel', 'completed', '\$396.00'),
      _OrderRow('#ORD-9802', 'Mona Hany', 'refunded', '\$74.00'),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.slate,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('recent_orders'.tr(), style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 14.h),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1.2),
              1: FlexColumnWidth(1.5),
              2: FlexColumnWidth(1.0),
              3: FlexColumnWidth(1.0),
            },
            children: [
              _buildHeader(context),
              ...rows.map((row) => _buildRow(context, row)),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildHeader(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        );
    return TableRow(
      children: [
        _cell('order_id'.tr(), style, true),
        _cell('customer'.tr(), style, true),
        _cell('status'.tr(), style, true),
        _cell('amount'.tr(), style, true),
      ],
    );
  }

  TableRow _buildRow(BuildContext context, _OrderRow row) {
    final style = TextStyle(fontSize: 13.sp, color: AppColors.textPrimary);
    return TableRow(
      children: [
        _cell(row.id, style, false),
        _cell(row.customer, style, false),
        _statusCell(row.statusKey),
        _cell(row.amount, style, false),
      ],
    );
  }

  Widget _cell(String value, TextStyle? style, bool heading) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: heading ? 8.h : 10.h),
      child: Text(value, style: style),
    );
  }

  Widget _statusCell(String key) {
    Color background;
    switch (key) {
      case 'completed':
        background = AppColors.success.withValues(alpha: 0.15);
        break;
      case 'pending':
        background = AppColors.warning.withValues(alpha: 0.15);
        break;
      default:
        background = Colors.red.withValues(alpha: 0.15);
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            key.tr(),
            style: TextStyle(fontSize: 12.sp, color: AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}

class _OrderRow {
  const _OrderRow(this.id, this.customer, this.statusKey, this.amount);

  final String id;
  final String customer;
  final String statusKey;
  final String amount;
}
