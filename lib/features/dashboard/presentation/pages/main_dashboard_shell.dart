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
      default:
        return const DashboardPageBody();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Row(
            children: [
              SideNav(
                activeKey: _activeKey,
                onItemTap: (key) {
                  // If it's a page we handle in the shell, just switch state
                  if (['home', 'product_list', 'add_products', 'orders', 'customers'].contains(key)) {
                    setState(() => _activeKey = key);
                  } else {
                    // Handle logout or other external navigation if any
                    if (key == 'logout') {
                      Navigator.of(context).pushReplacementNamed('/login');
                    }
                  }
                },
              ),
              AppSpacing.h25,
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
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
  }
}
