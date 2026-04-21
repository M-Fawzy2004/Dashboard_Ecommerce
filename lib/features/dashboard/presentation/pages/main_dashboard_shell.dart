import 'package:dashboard_ecommerce/features/categories/presentation/pages/categories_management_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_spacing.dart';
import '../widgets/side_nav.dart';
import 'dashboard_page_body.dart';
import '../../../products/presentation/pages/products_page_body.dart';
import '../../../products/presentation/pages/add_product_page_body.dart';
import '../../../orders/presentation/pages/orders_page_body.dart';

class MainDashboardShell extends StatefulWidget {
  const MainDashboardShell({super.key, this.initialPage = 'home'});
  final String initialPage;

  @override
  State<MainDashboardShell> createState() => _MainDashboardShellState();
}

class _MainDashboardShellState extends State<MainDashboardShell> {
  late String _activeKey;

  @override
  void initState() {
    super.initState();
    _activeKey = widget.initialPage;
  }

  Widget _buildBody() {
    switch (_activeKey) {
      case 'home':
        return const DashboardPageBody();
      case 'orders':
        return const OrdersPageBody();
      case 'product_list':
        return const ProductsPageBody();
      case 'add_products':
        return const AddProductPageBody();
      case 'categories':
        return const CategoriesManagementBody();
      default:
        return const DashboardPageBody();
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
            if (['home', 'product_list', 'add_products', 'orders', 'customers', 'categories'].contains(key)) {
              setState(() => _activeKey = key);
              if (isMobile && Scaffold.of(context).isDrawerOpen) {
                Navigator.of(context).pop();
              } else if (isMobile) {
                // If context isn't finding scaffold drawer state easily due to builder, popping via global isn't ideal but we can just pop context.
                Navigator.pop(context);
              }
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
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18.sp),
                  ),
                )
              : null,
          drawer: isMobile ? Drawer(child: SafeArea(child: sideNav)) : null,
          body: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: isMobile ? 10.h : 20.h),
              child: Row(
                children: [
                  if (!isMobile) ...[
                    sideNav,
                    AppSpacing.h25,
                  ],
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      switchInCurve: Curves.easeOutCubic,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: KeyedSubtree(
                        key: ValueKey(_activeKey),
                        child: _buildBody(),
                      ),
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
