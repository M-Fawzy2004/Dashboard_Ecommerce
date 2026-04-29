import 'package:flutter/material.dart';
import '../../../../../shared/theme/app_spacing.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/kpi_grid.dart';
import '../widgets/weekly_revenue_card.dart';
import '../../../../../shared/widgets/fade_in_slide.dart';

import 'package:dashboard_ecommerce/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:dashboard_ecommerce/features/reviews/presentation/cubit/reviews_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../../shared/theme/app_colors.dart';

import '../widgets/quick_inventory_card.dart';

class DashboardPageBody extends StatelessWidget {
  const DashboardPageBody({super.key, this.onNavigate});
  final Function(String)? onNavigate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const FadeInSlide(
            direction: Offset(0, -0.1),
            child: DashboardHeader(),
          ),
          AppSpacing.v25,
          const FadeInSlide(
            delay: Duration(milliseconds: 100),
            child: KpiGrid(),
          ),
          AppSpacing.v25,

          // ── Recent Activity Section ──
          FadeInSlide(
            delay: const Duration(milliseconds: 200),
            child: _buildRecentOrders(context),
          ),
          AppSpacing.v25,

          FadeInSlide(
            delay: const Duration(milliseconds: 300),
            child: _buildLatestReviews(context),
          ),

          AppSpacing.v25,
          FadeInSlide(
            delay: const Duration(milliseconds: 400),
            child: QuickInventoryCard(
              onAddProduct: () => onNavigate?.call('add_products'),
              onSeeMore: () => onNavigate?.call('product_list'),
            ),
          ),

          AppSpacing.v25,
          const FadeInSlide(
            delay: Duration(milliseconds: 500),
            child: WeeklyRevenueCard(),
          ),
          AppSpacing.v30,
        ],
      ),
    );
  }

  Widget _buildRecentOrders(BuildContext context) {
    return _DashboardSection(
      title: 'Recent Orders',
      actionLabel: 'View All',
      onActionTap: () => onNavigate?.call('orders'),
      child: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final recent = state.orders.take(5).toList();
          if (recent.isEmpty) return const Text('No orders yet');

          return Column(
            children: recent
                .map(
                  (order) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                    title: Text(
                      order.orderCode,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      DateFormat('MMM dd, HH:mm').format(order.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${order.totalAmount}',
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        Text(
                          order.status.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            color: _getStatusColor(order.status),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }

  Widget _buildLatestReviews(BuildContext context) {
    return _DashboardSection(
      title: 'Latest Reviews',
      actionLabel: 'View All',
      onActionTap: () => onNavigate?.call('reviews'),
      child: BlocBuilder<ReviewsCubit, ReviewsState>(
        builder: (context, state) {
          if (state is ReviewsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ReviewsLoaded) {
            final recent = state.reviews.take(3).toList();
            if (recent.isEmpty) return const Text('No reviews yet');
            return Column(
              children: recent
                  .map(
                    (review) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.orange.withValues(
                              alpha: 0.1,
                            ),
                            child: Text(
                              review.userName[0],
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review.userName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  review.comment,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: List.generate(
                              5,
                              (i) => Icon(
                                Icons.star,
                                size: 10,
                                color: i < review.rating
                                    ? Colors.orange
                                    : Colors.grey.shade300,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}

class _DashboardSection extends StatelessWidget {
  const _DashboardSection({
    required this.title,
    required this.actionLabel,
    required this.onActionTap,
    required this.child,
  });
  final String title;
  final String actionLabel;
  final VoidCallback onActionTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              TextButton(
                onPressed: onActionTap,
                child: Text(
                  actionLabel,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
