import '../../core/network/api_client.dart';

class CartApiDataSource {
  final ApiClient _client;

  CartApiDataSource(this._client);

  Future<Map<String, dynamic>> addToCart({
    required String productId,
    int quantity = 1,
    String? color,
    String? size,
  }) async {
    final json = await _client.post('/cart', {
      'product': productId,
      'quantity': quantity,
      if (color != null) 'color': color,
      if (size != null && size.isNotEmpty) 'size': size,
    });
    return json['data'] as Map<String, dynamic>? ?? {};
  }

  Future<void> updateCartItem(String cartItemId, int quantity) {
    return _client.patch('/cart/$cartItemId', {'quantity': quantity});
  }

  Future<void> deleteCartItem(String cartItemId) {
    return _client.delete('/cart/$cartItemId');
  }
}
