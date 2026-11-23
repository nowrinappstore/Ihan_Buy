import 'package:flutter/material.dart';
import '../entities/cart_item.dart';
import '../entities/product.dart';
import '../repositories/cart_repository.dart';

class AddToCart {
  final CartRepository repository;

  AddToCart(this.repository);

  Future<void> call(
    Product product, {
    required Color color,
    required String size,
    int quantity = 1,
  }) async {
    final existing = repository.findMatching(product.id, color, size);
    if (existing != null) {
      await repository.setQuantity(existing, existing.quantity + quantity);
    } else {
      await repository.insert(
        CartItem(product: product, color: color, size: size, quantity: quantity),
      );
    }
  }
}
