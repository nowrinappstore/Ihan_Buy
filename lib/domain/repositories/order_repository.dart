abstract class OrderRepository {
  Future<void> createOrder({
    required String paymentMethod,
    required Map<String, dynamic> shippingAddress,
  });
}
