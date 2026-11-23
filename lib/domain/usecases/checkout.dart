import '../repositories/cart_repository.dart';
import '../repositories/order_repository.dart';

class Checkout {
  final CartRepository cartRepository;
  final OrderRepository orderRepository;

  Checkout(this.cartRepository, this.orderRepository);

  Future<void> call({
    required Map<String, dynamic> shippingAddress,
    String paymentMethod = 'cod',
  }) async {
    final items = cartRepository.items;
    if (items.isEmpty) {
      throw StateError('Cannot checkout an empty cart');
    }

    await orderRepository.createOrder(
      paymentMethod: paymentMethod,
      shippingAddress: shippingAddress,
    );
    cartRepository.clear();
  }
}
