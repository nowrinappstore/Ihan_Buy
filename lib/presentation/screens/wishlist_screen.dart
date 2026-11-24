// lib/presentation/screens/wishlist_screen.dart
import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_navigator.dart';
import '../../core/app_strings.dart';
import '../state/app_controllers.dart';
import '../widgets/product_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.wishlistTitle)),
      body: AnimatedBuilder(
        animation: Listenable.merge([cartController, productsController]),
        builder: (context, _) {
          final items = productsController.products
              .where((p) => cartController.isWishlisted(p.id))
              .toList();
          if (items.isEmpty) {
            return const Center(
              child: Text(
                AppStrings.wishlistEmpty,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, i) {
                final product = items[i];
                return ProductCard(
                  product: product,
                  width: double.infinity,
                  onTap: () => AppNavigator.toProductDetails(context, product: product),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
