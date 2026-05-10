import 'package:flutter/material.dart';
import '../../../../../shared/theme/app_spacing.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/kpi_grid.dart';
import '../widgets/weekly_revenue_card.dart';
import '../../../../../shared/widgets/fade_in_slide.dart';
import '../widgets/quick_inventory_card.dart';
import '../widgets/recent_orders_section.dart';
import '../widgets/latest_reviews_section.dart';

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
          FadeInSlide(
            delay: const Duration(milliseconds: 200),
            child: RecentOrdersSection(
              onViewAll: () => onNavigate?.call('orders'),
            ),
          ),
          AppSpacing.v25,
          FadeInSlide(
            delay: const Duration(milliseconds: 300),
            child: LatestReviewsSection(
              onViewAll: () => onNavigate?.call('reviews'),
            ),
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
}
