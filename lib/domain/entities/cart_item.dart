// lib/domain/entities/cart_item.dart
import 'product.dart';

class CartItem {
  /// The backend's cart-item id, set once this item has been synced to the
  /// server cart. Null only in the instant between creation and sync.
  String? id;
  final Product product;
  final String color;
  final String size;
  int quantity;

  CartItem({
    this.id,
    required this.product,
    required this.color,
    required this.size,
    this.quantity = 1,
  });

  double get total => product.price * quantity;
}
