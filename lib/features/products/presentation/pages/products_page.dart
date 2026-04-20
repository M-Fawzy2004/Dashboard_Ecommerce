import 'package:dashboard_ecommerce/features/dashboard/presentation/pages/main_dashboard_shell.dart';
import 'package:flutter/material.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainDashboardShell(initialPage: 'product_list');
  }
}
