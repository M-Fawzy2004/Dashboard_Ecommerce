import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../shared/widgets/enhanced_kpi_card.dart';
import '../../../../../shared/theme/app_spacing.dart';

class KpiGrid extends StatelessWidget {
  const KpiGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: EnhancedKpiCard(
            title: 'total_sales'.tr(),
            subtitle: 'Last 7 days',
            value: r'$350K',
            trend: '10.4%',
            isPositive: true,
            previousValue: r'Previous 7 days ($235)',
            onDetailsPressed: () {},
          ),
        ),
        AppSpacing.h25,
        Expanded(
          child: EnhancedKpiCard(
            title: 'total_orders'.tr(),
            subtitle: 'Last 7 days',
            value: '10.7K',
            trend: '14.4%',
            isPositive: true,
            previousValue: r'Previous 7 days (7.6k)',
            onDetailsPressed: () {},
          ),
        ),
        AppSpacing.h25,
        Expanded(
          child: EnhancedKpiCard(
            title: 'pending_canceled'.tr(),
            subtitle: 'Last 7 days',
            isMultiValue: true,
            multiValues: const [
              {'label': 'Pending', 'value': '509', 'sub': 'user 204'},
              {'label': 'Canceled', 'value': '94', 'sub': '14.4%', 'trend': 'down'},
            ],
            onDetailsPressed: () {},
          ),
        ),
      ],
    );
  }
}
