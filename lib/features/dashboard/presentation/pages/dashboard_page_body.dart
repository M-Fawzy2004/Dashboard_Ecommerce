import 'package:flutter/material.dart';
import '../../../../../shared/theme/app_spacing.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/kpi_grid.dart';
import '../widgets/weekly_revenue_card.dart';
import '../widgets/best_selling_products_card.dart';
import '../widgets/real_time_users_card.dart';
import '../widgets/sales_by_country_card.dart';
import '../widgets/top_products_card.dart';
import '../widgets/add_new_product_card.dart';

class DashboardPageBody extends StatelessWidget {
  const DashboardPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DashboardHeader(),
          AppSpacing.v25,
          // ── KPI Summary (Overview of performance) ──
          const KpiGrid(),
          AppSpacing.v25,
          // ── Revenue Chart (Expanding full width for clarity) ──
          const WeeklyRevenueCard(),
          AppSpacing.v25,
          // ── Product Insights (Listings and Performance) ──
          const BestSellingProductsCard(),
          AppSpacing.v25,
          const TopProductsCard(),
          AppSpacing.v25,
          // ── Geographic and Real-time Traffic ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(child: RealTimeUsersCard()),
              AppSpacing.h25,
              const Expanded(child: SalesByCountryCard()),
            ],
          ),
          AppSpacing.v25,
          const AddNewProductCard(),
          AppSpacing.v30,
        ],
      ),
    );
  }
}
