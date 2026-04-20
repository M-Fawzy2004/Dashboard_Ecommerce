import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/theme/app_spacing.dart';
import '../../../../../shared/widgets/language_menu_button.dart';
import '../../../dashboard/presentation/widgets/side_nav.dart';
import '../widgets/products_header.dart';
import '../widgets/products_inventory_cards.dart';
import '../widgets/products_table.dart';
import '../widgets/top_selling_products.dart';

class ProductsPageBody extends StatelessWidget {
  const ProductsPageBody({super.key});

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
                  activeKey: 'products',
                  onItemTap: (key) {
                    if (key == 'home') {
                      Navigator.of(context).pushReplacementNamed('/dashboard');
                    } else if (key == 'orders') {
                      Navigator.of(context).pushReplacementNamed('/orders');
                    } else if (key == 'categories') {
                      Navigator.of(context).pushReplacementNamed('/categories');
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
                    const Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: LanguageMenuButton(),
                    ),
                    AppSpacing.v20,
                    const ProductsHeader(),
                    AppSpacing.v20,
                    const ProductsInventoryCards(),
                    AppSpacing.v20,
                    const TopSellingProducts(),
                    AppSpacing.v20,
                    const ProductsTable(),
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
