import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/theme/app_colors.dart';

class OrdersTable extends StatelessWidget {
  const OrdersTable({super.key});

  @override
  Widget build(BuildContext context) {
    final rows = <_OrderItem>[
      _OrderItem('#ORD-9931', 'Layla Hassan', 'completed', '\$642.00', 'Visa', 'Express'),
      _OrderItem('#ORD-9924', 'Karim Adel', 'processing', '\$284.00', 'PayPal', 'Standard'),
      _OrderItem('#ORD-9918', 'Rana Emad', 'pending', '\$98.00', 'Cash', 'Standard'),
      _OrderItem('#ORD-9906', 'Hany Mostafa', 'cancelled', '\$176.00', 'Visa', 'Cancelled'),
      _OrderItem('#ORD-9891', 'Maha Nabil', 'completed', '\$352.00', 'Mastercard', 'Express'),
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
          Text('orders'.tr(), style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 14.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingTextStyle: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
              dataTextStyle: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13.sp,
              ),
              columns: [
                DataColumn(label: Text('order_id'.tr())),
                DataColumn(label: Text('customer'.tr())),
                DataColumn(label: Text('status'.tr())),
                DataColumn(label: Text('amount'.tr())),
                DataColumn(label: Text('payment_method'.tr())),
                DataColumn(label: Text('delivery'.tr())),
              ],
              rows: rows.map(_toDataRow).toList(),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _toDataRow(_OrderItem item) {
    return DataRow(
      cells: [
        DataCell(Text(item.id)),
        DataCell(Text(item.customer)),
        DataCell(_StatusBadge(status: item.status)),
        DataCell(Text(item.amount)),
        DataCell(Text(item.paymentMethod)),
        DataCell(Text(item.delivery)),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'completed' => AppColors.success,
      'processing' => AppColors.warning,
      'pending' => AppColors.electricBlue,
      _ => Colors.redAccent,
    };
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Text(
        status.tr(),
        style: TextStyle(color: AppColors.textPrimary, fontSize: 12.sp),
      ),
    );
  }
}

class _OrderItem {
  const _OrderItem(
    this.id,
    this.customer,
    this.status,
    this.amount,
    this.paymentMethod,
    this.delivery,
  );

  final String id;
  final String customer;
  final String status;
  final String amount;
  final String paymentMethod;
  final String delivery;
}
