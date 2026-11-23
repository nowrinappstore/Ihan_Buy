import '../../core/network/api_client.dart';

class OrderApiDataSource {
  final ApiClient _client;

  OrderApiDataSource(this._client);

  Future<Map<String, dynamic>> createOrder({
    required String paymentMethod,
    required Map<String, dynamic> shippingAddress,
  }) async {
    final json = await _client.post('/order', {
      'payment_method': paymentMethod,
      'shipping_address': shippingAddress,
    });
    return json['data'] as Map<String, dynamic>? ?? {};
  }
}
