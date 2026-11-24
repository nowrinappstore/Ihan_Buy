// lib/data/model/wishlist_item_model.dart
import '../../domain/entities/wishlist_item.dart';
import 'product_model.dart';

/// Wishlisting has no dedicated backend endpoint; it is tracked client-side
/// and built directly from an already-fetched product, not parsed from JSON.
class WishlistItemModel {
  final String id;
  final ProductModel product;

  const WishlistItemModel({required this.id, required this.product});

  WishlistItem toEntity() => WishlistItem(id: id, product: product.toEntity());
}
