import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/theme/app_spacing.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/kpi_grid.dart';
import '../widgets/side_nav.dart';
import '../widgets/weekly_revenue_card.dart';
import '../widgets/transaction_card.dart';
import '../widgets/best_selling_products_card.dart';
import '../widgets/real_time_users_card.dart';
import '../widgets/sales_by_country_card.dart';
import '../widgets/top_products_card.dart';
import '../widgets/add_new_product_card.dart';

class DashboardPageBody extends StatelessWidget {
  const DashboardPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: SideNav(
                  activeKey: 'home',
                  onItemTap: (key) {
                    if (key == 'orders') {
                      Navigator.of(context).pushReplacementNamed('/orders');
                    } else if (key == 'categories') {
                      Navigator.of(context).pushReplacementNamed('/categories');
                    } else if (key == 'product_list') {
                      Navigator.of(context).pushReplacementNamed('/products');
                    } else if (key == 'add_products') {
                      Navigator.of(context).pushReplacementNamed('/add-products');
                    }
                  },
                ),
              ),
            ),
            AppSpacing.h25,
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DashboardHeader(),
                    AppSpacing.v20,
                    // Top Row: KPI Grid
                    const KpiGrid(),
                    AppSpacing.v20,
                    
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column (Wider)
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              const WeeklyRevenueCard(),
                              AppSpacing.v20,
                              const TransactionCard(),
                              AppSpacing.v20,
                              const BestSellingProductsCard(),
                            ],
                          ),
                        ),
                        AppSpacing.h25,
                        // Right Column (Narrower)
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              const RealTimeUsersCard(),
                              AppSpacing.v20,
                              const SalesByCountryCard(),
                              AppSpacing.v20,
                              const TopProductsCard(),
                              AppSpacing.v20,
                              const AddNewProductCard(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
