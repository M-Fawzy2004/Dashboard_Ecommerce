import 'package:dashboard_ecommerce/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:dashboard_ecommerce/features/products/presentation/cubit/products_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../../../shared/widgets/enhanced_kpi_card.dart';
import '../../../../../shared/theme/app_spacing.dart';

class KpiGrid extends StatelessWidget {
  const KpiGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, ordersState) {
        return BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, productsState) {
            final orders = ordersState.orders;
            final products = productsState.items;

            final totalSales = orders.fold(0.0, (sum, item) => sum + item.totalAmount);
            final pendingOrders = orders.where((o) => o.status == 'pending' || o.status == 'new').length;
            final canceledOrders = orders.where((o) => o.status == 'cancelled').length;

            return LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 800;
                
                final cards = [
                  EnhancedKpiCard(
                    title: 'Total Sales',
                    subtitle: 'All time',
                    value: '\$${totalSales.toStringAsFixed(0)}',
                    trend: '+0.0%', // Could calculate trend if we had dates history
                    isPositive: true,
                    previousValue: 'Total Revenue',
                    onDetailsPressed: () {},
                  ),
                  EnhancedKpiCard(
                    title: 'Orders',
                    subtitle: 'Total count',
                    value: '${orders.length}',
                    trend: 'Real-time',
                    isPositive: true,
                    previousValue: '${products.length} Products listed',
                    onDetailsPressed: () {},
                  ),
                  EnhancedKpiCard(
                    title: 'Order Status',
                    subtitle: 'Current summary',
                    isMultiValue: true,
                    multiValues: [
                      {'label': 'Pending', 'value': '$pendingOrders', 'sub': 'requires action'},
                      {'label': 'Canceled', 'value': '$canceledOrders', 'sub': 'total failed'},
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
          },
        );
      },
    );
  }
}

