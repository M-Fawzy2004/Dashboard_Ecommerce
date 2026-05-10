import 'package:dashboard_ecommerce/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../shared/theme/app_spacing.dart';
import '../../../../../shared/widgets/enhanced_kpi_card.dart';

class OrdersTotalsRow extends StatelessWidget {
  const OrdersTotalsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        final totalCount = state.orders.length;
        final newCount = state.orders
            .where(
              (o) =>
                  o.status.toLowerCase() == 'pending' ||
                  o.status.toLowerCase() == 'confirmed',
            )
            .length;
        final completedCount = state.orders
            .where((o) => o.status.toLowerCase() == 'delivered')
            .length;
        final cancelledCount = state.orders
            .where((o) => o.status.toLowerCase() == 'cancelled')
            .length;

        return LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 800;

            final cards = [
              EnhancedKpiCard(
                title: 'Total Orders',
                subtitle: 'Current total',
                value: totalCount.toString(),
                trend: 'Live',
                isPositive: true,
                showDetailsButton: false,
              ),
              EnhancedKpiCard(
                title: 'New Orders',
                subtitle: 'Pending & Confirmed',
                value: newCount.toString(),
                trend: 'New',
                isPositive: true,
                showDetailsButton: false,
              ),
              EnhancedKpiCard(
                title: 'Completed Orders',
                subtitle: 'Delivered',
                value: completedCount.toString(),
                trend: 'Success',
                isPositive: true,
                showDetailsButton: false,
              ),
              EnhancedKpiCard(
                title: 'Cancelled Orders',
                subtitle: 'Cancelled/Failed',
                value: cancelledCount.toString(),
                trend: 'Check',
                isPositive: false,
                showDetailsButton: false,
              ),
            ];

            if (isMobile) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: cards[0]),
                      AppSpacing.h15,
                      Expanded(child: cards[1]),
                    ],
                  ),
                  AppSpacing.v16,
                  Row(
                    children: [
                      Expanded(child: cards[2]),
                      AppSpacing.h15,
                      Expanded(child: cards[3]),
                    ],
                  ),
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
      },
    );
  }
}
