import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class UpdateCartQuantity {
  final CartRepository repository;

  UpdateCartQuantity(this.repository);

  Future<void> call(CartItem item, int delta) {
    return repository.setQuantity(item, (item.quantity + delta).clamp(1, 99));
  }
}