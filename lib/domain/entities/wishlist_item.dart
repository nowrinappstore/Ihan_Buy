// lib/domain/entities/wishlist_item.dart
import 'product.dart';

class WishlistItem {
  final String id;
  final Product product;

  const WishlistItem({required this.id, required this.product});
}
