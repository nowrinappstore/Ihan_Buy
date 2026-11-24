// lib/presentation/screens/category_products_screen.dart
import 'package:flutter/material.dart';

import '../../core/app_navigator.dart';
import '../../core/app_strings.dart';
import '../../domain/entities/category.dart';
import '../state/app_controllers.dart';
import '../widgets/product_grid_page.dart';

class CategoryProductsScreen extends StatelessWidget {
  final Category? category;

  const CategoryProductsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final title = category?.name ?? AppStrings.allProductsTitle;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: AnimatedBuilder(
        animation: productsController,
        builder: (context, _) {
          final allProducts = productsController.products;
          final products = category == null
              ? allProducts
              : allProducts.where((p) => p.categoryIds.contains(category!.id)).toList();

          return ProductGridPage(
            products: products,
            onProductTap: (product) =>
                AppNavigator.toProductDetails(context, product: product),
          );
        },
      ),
    );
  }
}
