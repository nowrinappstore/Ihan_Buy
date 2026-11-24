// lib/data/service/wishlist_service.dart
import '../../domain/entities/product.dart';
import '../../domain/entities/wishlist_item.dart';

/// Wishlisting has no dedicated backend endpoint; it is tracked client-side
/// only, same as before this migration.
class WishlistService {
  final Set<String> _wishlistIds = {};

  bool isWishlisted(String productId) => _wishlistIds.contains(productId);

  void toggleWishlist(String productId) {
    if (!_wishlistIds.add(productId)) {
      _wishlistIds.remove(productId);
    }
  }

  List<WishlistItem> getWishlist(List<Product> allProducts) {
    return allProducts
        .where((p) => _wishlistIds.contains(p.id))
        .map((p) => WishlistItem(id: p.id, product: p))
        .toList();
  }
}
