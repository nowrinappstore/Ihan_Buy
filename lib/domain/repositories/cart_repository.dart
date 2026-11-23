import 'package:flutter/material.dart';
import '../entities/cart_item.dart';

abstract class CartRepository {
  List<CartItem> get items;
  Set<String> get wishlistIds;

  CartItem? findMatching(String productId, Color color, String size);
  Future<void> insert(CartItem item);
  Future<void> remove(CartItem item);
  Future<void> setQuantity(CartItem item, int quantity);
  void toggleWishlistId(String productId);
  void clear();
}
