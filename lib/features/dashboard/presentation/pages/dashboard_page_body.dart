import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/theme/app_spacing.dart';
import '../../../../../shared/widgets/language_menu_button.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/kpi_grid.dart';
import '../widgets/recent_orders_table.dart';
import '../widgets/side_nav.dart';
import '../widgets/weekly_revenue_card.dart';

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
                    } else if (key == 'products') {
                      Navigator.of(context).pushReplacementNamed('/products');
                    }
                  },
                ),
              ),
            ),
            AppSpacing.h25,
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: LanguageMenuButton(),
                    ),
                    AppSpacing.v20,
                    const DashboardHeader(),
                    AppSpacing.v20,
                    const KpiGrid(),
                    AppSpacing.v20,
                    const WeeklyRevenueCard(),
                    AppSpacing.v20,
                    const RecentOrdersTable(),
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
