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

import '../../../../../shared/widgets/fade_in_slide.dart';

class DashboardPageBody extends StatelessWidget {
  const DashboardPageBody({super.key});

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
          // ── KPI Summary (Overview of performance) ──
          const FadeInSlide(
            delay: Duration(milliseconds: 100),
            child: KpiGrid(),
          ),
          AppSpacing.v25,
          // ── Revenue Chart (Expanding full width for clarity) ──
          const FadeInSlide(
            delay: Duration(milliseconds: 200),
            child: WeeklyRevenueCard(),
          ),
          AppSpacing.v25,
          // ── Product Insights (Listings and Performance) ──
          const FadeInSlide(
            delay: Duration(milliseconds: 300),
            child: BestSellingProductsCard(),
          ),
          AppSpacing.v25,
          const FadeInSlide(
            delay: Duration(milliseconds: 400),
            child: TopProductsCard(),
          ),
          AppSpacing.v25,
          // ── Geographic and Real-time Traffic ──
          FadeInSlide(
            delay: const Duration(milliseconds: 500),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 600) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const RealTimeUsersCard(),
                      AppSpacing.v25,
                      const SalesByCountryCard(),
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(child: RealTimeUsersCard()),
                    AppSpacing.h25,
                    const Expanded(child: SalesByCountryCard()),
                  ],
                );
              },
            ),
          ),
          AppSpacing.v25,
          const FadeInSlide(
            delay: Duration(milliseconds: 600),
            child: AddNewProductCard(),
          ),
          AppSpacing.v30,
        ],
      ),
    );
  }
}
