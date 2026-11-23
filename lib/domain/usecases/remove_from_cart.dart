import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class RemoveFromCart {
  final CartRepository repository;

  RemoveFromCart(this.repository);

  Future<void> call(CartItem item) => repository.remove(item);
}