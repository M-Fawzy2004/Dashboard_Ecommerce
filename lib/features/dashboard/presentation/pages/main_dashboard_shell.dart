import 'package:dashboard_ecommerce/features/categories/presentation/pages/categories_management_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_spacing.dart';
import '../widgets/side_nav.dart';
import 'dashboard_page_body.dart';
import '../../../products/presentation/pages/products_page_body.dart';
import '../../../products/presentation/pages/add_product_page_body.dart';
import '../../../orders/presentation/pages/orders_page_body.dart';
import '../../../reviews/presentation/pages/reviews_page_body.dart';
import '../../../products/domain/entities/product_entity.dart';

class MainDashboardShell extends StatefulWidget {
  const MainDashboardShell({super.key, this.initialPage = 'home'});
  final String initialPage;

  @override
  State<MainDashboardShell> createState() => _MainDashboardShellState();
}

class _MainDashboardShellState extends State<MainDashboardShell> {
  late String _activeKey;
  ProductEntity? _editProduct;

  @override
  void initState() {
    super.initState();
    _activeKey = widget.initialPage;
  }

  int _getSelectedIndex() {
    switch (_activeKey) {
      case 'home':
        return 0;
      case 'orders':
        return 1;
      case 'product_list':
        return 2;
      case 'add_products':
        return 3;
      case 'categories':
        return 4;
      case 'reviews':
        return 5;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 800;
        final double horizontalPadding = isMobile ? 16.w : 24.w;

        final sideNav = SideNav(
          activeKey: _activeKey,
          onItemTap: (key) {
            final validKeys = [
              'home',
              'orders',
              'product_list',
              'add_products',
              'categories',
              'reviews',
            ];
            if (validKeys.contains(key)) {
              setState(() {
                _activeKey = key;
                if (key == 'add_products') _editProduct = null;
              });
              if (isMobile) Navigator.pop(context);
            } else if (key == 'logout') {
              Navigator.of(context).pushReplacementNamed('/login');
            }
          },
        );

        return Scaffold(
          appBar: isMobile
              ? AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  title: Text(
                    'Dashboard',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18.sp,
                    ),
                  ),
                )
              : null,
          drawer: isMobile ? Drawer(child: SafeArea(child: sideNav)) : null,
          body: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: isMobile ? 10.h : 20.h,
              ),
              child: Row(
                children: [
                  if (!isMobile) ...[sideNav, AppSpacing.h25],
                  Expanded(
                    child: IndexedStack(
                      index: _getSelectedIndex(),
                      children: [
                        DashboardPageBody(
                          onNavigate: (key) => setState(() => _activeKey = key),
                        ),
                        const OrdersPageBody(),
                        ProductsPageBody(
                          onEdit: (product) {
                            setState(() {
                              _editProduct = product;
                              _activeKey = 'add_products';
                            });
                          },
                        ),
                        AddProductPageBody(
                          key: ValueKey(
                            _editProduct?.id ?? 'new',
                          ), // Key ensures rebuild on new product
                          initialProduct: _editProduct,
                          onSuccess: () =>
                              setState(() => _activeKey = 'product_list'),
                        ),
                        const CategoriesManagementBody(),
                        ReviewsPageBody(
                          onProductTap: (product) {
                            setState(() {
                              _editProduct = product;
                              _activeKey = 'add_products';
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
