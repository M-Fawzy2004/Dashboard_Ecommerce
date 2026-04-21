import 'package:flutter/material.dart';
import '../../../../../shared/widgets/enhanced_kpi_card.dart';
import '../../../../../shared/theme/app_spacing.dart';

class KpiGrid extends StatelessWidget {
  const KpiGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;
        
        final cards = [
          EnhancedKpiCard(
            title: 'Total Sales',
            subtitle: 'Last 7 days',
            value: r'$350K',
            trend: '10.4%',
            isPositive: true,
            previousValue: r'Previous 7 days ($235K)',
            onDetailsPressed: () {},
          ),
          EnhancedKpiCard(
            title: 'Total Orders',
            subtitle: 'Last 7 days',
            value: '10.7K',
            trend: '14.4%',
            isPositive: true,
            previousValue: r'Previous 7 days (7.6k)',
            onDetailsPressed: () {},
          ),
          EnhancedKpiCard(
            title: 'Inventory Status',
            subtitle: 'Real-time',
            isMultiValue: true,
            multiValues: const [
              {'label': 'Pending', 'value': '509', 'sub': 'active products'},
              {'label': 'Canceled', 'value': '94', 'sub': '14.4%', 'trend': 'down'},
            ],
            onDetailsPressed: () {},
          ),
        ];

        if (isMobile) {
          return Column(
            children: [
              cards[0],
              AppSpacing.v16,
              cards[1],
              AppSpacing.v16,
              cards[2],
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: cards[0]),
            AppSpacing.h25,
            Expanded(child: cards[1]),
            AppSpacing.h25,
            Expanded(child: cards[2]),
          ],
        );
      },
    );
  }
}

