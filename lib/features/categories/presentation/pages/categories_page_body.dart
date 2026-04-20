import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/theme/app_spacing.dart';
import '../../../dashboard/presentation/widgets/side_nav.dart';
import '../widgets/categories_discover_section.dart';
import '../widgets/categories_products_panel.dart';
import '../widgets/categories_top_bar.dart';

class CategoriesPageBody extends StatelessWidget {
  const CategoriesPageBody({super.key});

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
                  activeKey: 'categories',
                  onItemTap: (key) {
                    if (key == 'home') {
                      Navigator.of(context).pushReplacementNamed('/dashboard');
                    } else if (key == 'orders') {
                      Navigator.of(context).pushReplacementNamed('/orders');
                    } else if (key == 'products') {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CategoriesTopBar(),
                    AppSpacing.v20,
                    const CategoriesDiscoverSection(),
                    AppSpacing.v20,
                    const CategoriesProductsPanel(),
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
