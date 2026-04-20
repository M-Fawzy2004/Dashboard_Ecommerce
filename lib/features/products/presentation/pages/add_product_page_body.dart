import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/theme/app_spacing.dart';
import '../../../dashboard/presentation/widgets/side_nav.dart';
import '../widgets/add_product_top_bar.dart';
import '../widgets/product_basic_form_card.dart';
import '../widgets/product_media_categories_card.dart';

class AddProductPageBody extends StatelessWidget {
  const AddProductPageBody({super.key});

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
                  activeKey: 'add_products',
                  onItemTap: (key) {
                    if (key == 'home') {
                      Navigator.of(context).pushReplacementNamed('/dashboard');
                    } else if (key == 'orders') {
                      Navigator.of(context).pushReplacementNamed('/orders');
                    } else if (key == 'categories') {
                      Navigator.of(context).pushReplacementNamed('/categories');
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
                    const AddProductTopBar(),
                    AppSpacing.v20,
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.r),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFFFFF), Color(0xFFF6F9FF)],
                          begin: AlignmentDirectional.topStart,
                          end: AlignmentDirectional.bottomEnd,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 3, child: const ProductBasicFormCard()),
                          SizedBox(width: 16.w),
                          Expanded(flex: 2, child: const ProductMediaCategoriesCard()),
                        ],
                      ),
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
