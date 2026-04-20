import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/theme/app_spacing.dart';
import '../../../../../shared/widgets/language_menu_button.dart';
import '../../../dashboard/presentation/widgets/side_nav.dart';
import '../widgets/orders_filters.dart';
import '../widgets/orders_header.dart';
import '../widgets/orders_table.dart';
import '../widgets/orders_totals_row.dart';

class OrdersPageBody extends StatelessWidget {
  const OrdersPageBody({super.key});

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
                  activeKey: 'orders',
                  onItemTap: (key) {
                    if (key == 'home') {
                      Navigator.of(context).pushReplacementNamed('/dashboard');
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
                    const OrdersHeader(),
                    AppSpacing.v20,
                    const OrdersTotalsRow(),
                    AppSpacing.v20,
                    const OrdersFilters(),
                    AppSpacing.v20,
                    const OrdersTable(),
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
