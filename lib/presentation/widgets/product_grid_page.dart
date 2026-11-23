import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import 'product_card.dart';

class ProductGridPage extends StatelessWidget {
  final List<Product> products;
  final ValueChanged<Product> onProductTap;

  const ProductGridPage({
    super.key,
    required this.products,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.72,
        ),
        itemBuilder: (context, i) {
          final product = products[i];
          return ProductCard(
            product: product,
            width: double.infinity,
            onTap: () => onProductTap(product),
          );
        },
      ),
    );
  }
}
