import 'package:flutter/material.dart';
import '../../core/di/injector.dart';
import '../widgets/category_card.dart';
import 'category_products_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: AnimatedBuilder(
        animation: productsController,
        builder: (context, _) {
          if (productsController.isLoading && productsController.categories.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.count(
              crossAxisCount: 4,
              mainAxisSpacing: 20,
              crossAxisSpacing: 12,
              childAspectRatio: 0.8,
              children: productsController.categories.map((c) {
                return CategoryCard(
                  category: c,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => CategoryProductsScreen(category: c)),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
