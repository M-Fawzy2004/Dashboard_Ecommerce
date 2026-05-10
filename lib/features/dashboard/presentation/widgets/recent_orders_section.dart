import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:dashboard_ecommerce/features/orders/presentation/cubit/orders_cubit.dart';
import 'dashboard_section.dart';
import 'status_badge.dart';
import 'hover_row.dart';

class RecentOrdersSection extends StatelessWidget {
  const RecentOrdersSection({super.key, this.onViewAll});
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    return DashboardSection(
      title: 'Recent Orders',
      actionLabel: 'View All',
      onActionTap: onViewAll ?? () {},
      child: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            );
          }
          final recent = state.orders.take(5).toList();
          if (recent.isEmpty) {
            return Text(
              'No orders yet',
              style: TextStyle(
                color: Colors.white.withOpacity(0.3),
                fontSize: 13,
              ),
            );
          }

          return Column(
            children: recent.map((order) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: HoverRow(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.white.withOpacity(0.4),
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.orderCode,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                DateFormat('MMM dd, HH:mm').format(order.createdAt),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white.withOpacity(0.25),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${order.totalAmount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 3),
                            StatusBadge(status: order.status),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
