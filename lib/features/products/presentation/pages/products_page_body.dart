import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/theme/app_spacing.dart';
import '../../../dashboard/presentation/widgets/side_nav.dart';
import '../widgets/add_product_top_bar.dart';
import '../widgets/product_basic_form_card.dart';
import '../widgets/product_media_categories_card.dart';

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
                    const AddProductTopBar(),
                    AppSpacing.v20,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: const ProductBasicFormCard()),
                        SizedBox(width: 16.w),
                        Expanded(flex: 2, child: const ProductMediaCategoriesCard()),
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
