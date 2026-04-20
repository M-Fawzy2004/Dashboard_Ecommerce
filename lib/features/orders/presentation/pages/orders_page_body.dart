import 'package:flutter/material.dart';
import '../../../../../shared/theme/app_spacing.dart';
import '../widgets/orders_header.dart';
import '../widgets/orders_table.dart';
import '../widgets/orders_totals_row.dart';

class OrdersPageBody extends StatelessWidget {
  const OrdersPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const OrdersHeader(),
          AppSpacing.v25,
          // ── Orders Insight Row ──
          const OrdersTotalsRow(),
          AppSpacing.v25,
          // ── Detailed Orders Log ──
          const OrdersTable(),
          AppSpacing.v30,
        ],
      ),
    );
  }
}
