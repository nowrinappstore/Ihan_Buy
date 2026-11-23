import 'package:flutter/material.dart';
import '../../core/di/injector.dart' as injector;
import '../../domain/entities/category.dart';
import '../widgets/product_grid_page.dart';
import 'product_details_screen.dart';

class CategoryProductsScreen extends StatelessWidget {
  final Category? category;

  const CategoryProductsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final title = category?.name ?? 'All Products';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: AnimatedBuilder(
        animation: injector.productsController,
        builder: (context, _) {
          final allProducts = injector.productsController.products;
          final products = category == null
              ? allProducts
              : allProducts.where((p) => p.categoryIds.contains(category!.id)).toList();

          return ProductGridPage(
            products: products,
            onProductTap: (product) => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product)),
            ),
          );
        },
      ),
    );
  }
}
