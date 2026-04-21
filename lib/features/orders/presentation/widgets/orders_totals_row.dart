import 'package:flutter/material.dart';
import '../../../../../shared/theme/app_spacing.dart';
import '../../../../../shared/widgets/enhanced_kpi_card.dart';

class OrdersTotalsRow extends StatelessWidget {
  const OrdersTotalsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;
        
        final cards = [
          const EnhancedKpiCard(
            title: 'Total Orders',
            subtitle: 'Last 7 days',
            value: '1,240',
            trend: '14.4%',
            isPositive: true,
            showDetailsButton: false,
          ),
          const EnhancedKpiCard(
            title: 'New Orders',
            subtitle: 'Last 7 days',
            value: '240',
            trend: '20%',
            isPositive: true,
            showDetailsButton: false,
          ),
          const EnhancedKpiCard(
            title: 'Completed Orders',
            subtitle: 'Last 7 days',
            value: '960',
            trend: '85%',
            isPositive: true,
            showDetailsButton: false,
          ),
          const EnhancedKpiCard(
            title: 'Canceled Orders',
            subtitle: 'Last 7 days',
            value: '87',
            trend: '5%',
            isPositive: false,
            showDetailsButton: false,
          ),
        ];

        if (isMobile) {
          return Column(
            children: [
              Row(children: [Expanded(child: cards[0]), AppSpacing.h15, Expanded(child: cards[1])]),
              AppSpacing.v16,
              Row(children: [Expanded(child: cards[2]), AppSpacing.h15, Expanded(child: cards[3])]),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: cards[0]),
            AppSpacing.h15,
            Expanded(child: cards[1]),
            AppSpacing.h15,
            Expanded(child: cards[2]),
            AppSpacing.h15,
            Expanded(child: cards[3]),
          ],
        );
      },
    );
  }
}

