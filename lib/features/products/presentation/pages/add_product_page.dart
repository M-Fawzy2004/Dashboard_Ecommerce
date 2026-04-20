import 'package:dashboard_ecommerce/features/dashboard/presentation/pages/main_dashboard_shell.dart';
import 'package:flutter/material.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainDashboardShell(initialPage: 'add_products');
  }
}
