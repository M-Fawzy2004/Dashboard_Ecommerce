import 'package:flutter/material.dart';

import 'products_page_body.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ProductsPageBody(),
    );
  }
}
