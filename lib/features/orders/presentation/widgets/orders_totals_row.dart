import 'package:flutter/material.dart';
import '../../../../../shared/theme/app_spacing.dart';
import '../../../../../shared/widgets/enhanced_kpi_card.dart';

class OrdersTotalsRow extends StatelessWidget {
  const OrdersTotalsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: EnhancedKpiCard(
            title: 'Total Orders',
            subtitle: 'Last 7 days',
            value: '1,240',
            trend: '14.4%',
            isPositive: true,
            showDetailsButton: false,
          ),
        ),
        AppSpacing.h15,
        Expanded(
          child: EnhancedKpiCard(
            title: 'New Orders',
            subtitle: 'Last 7 days',
            value: '240',
            trend: '20%',
            isPositive: true,
            showDetailsButton: false,
          ),
        ),
        AppSpacing.h15,
        Expanded(
          child: EnhancedKpiCard(
            title: 'Completed Orders',
            subtitle: 'Last 7 days',
            value: '960',
            trend: '85%',
            isPositive: true,
            showDetailsButton: false,
          ),
        ),
        AppSpacing.h15,
        Expanded(
          child: EnhancedKpiCard(
            title: 'Canceled Orders',
            subtitle: 'Last 7 days',
            value: '87',
            trend: '5%',
            isPositive: false,
            showDetailsButton: false,
          ),
        ),
      ],
    );
  }
}

