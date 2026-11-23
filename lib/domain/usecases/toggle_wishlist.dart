import '../repositories/cart_repository.dart';

class ToggleWishlist {
  final CartRepository repository;

  ToggleWishlist(this.repository);

  void call(String productId) => repository.toggleWishlistId(productId);
}