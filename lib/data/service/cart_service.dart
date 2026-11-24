// lib/data/service/cart_service.dart
import '../../core/end_points.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/product.dart';
import 'network/http_client.dart';

class CartService {
  final HttpClient _client;

  CartService(this._client);

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  CartItem? _findMatching(String productId, String color, String size) {
    for (final item in _items) {
      if (item.product.id == productId && item.color == color && item.size == size) {
        return item;
      }
    }
    return null;
  }

  Future<void> addToCart(
    Product product, {
    required String color,
    required String size,
    int quantity = 1,
  }) async {
    final existing = _findMatching(product.id, color, size);
    if (existing != null) {
      await updateQuantity(existing, quantity);
      return;
    }

    final json = await _client.post(EndPoints.cart, {
      'product': product.id,
      'quantity': quantity,
      'color': color,
      if (size.isNotEmpty) 'size': size,
    });
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final item = CartItem(
      id: data['_id']?.toString(),
      product: product,
      color: color,
      size: size,
      quantity: quantity,
    );
    _items.add(item);
  }

  Future<void> removeFromCart(CartItem item) async {
    final id = item.id;
    if (id != null) {
      await _client.delete(EndPoints.cartItem(id));
    }
    _items.remove(item);
  }

  Future<void> updateQuantity(CartItem item, int delta) async {
    final newQuantity = (item.quantity + delta).clamp(1, 99);
    final id = item.id;
    if (id != null) {
      await _client.patch(EndPoints.cartItem(id), {'quantity': newQuantity});
    }
    item.quantity = newQuantity;
  }

  Future<void> checkout({
    required Map<String, dynamic> shippingAddress,
    String paymentMethod = 'cod',
  }) async {
    if (_items.isEmpty) {
      throw StateError('Cannot checkout an empty cart');
    }

    await _client.post(EndPoints.order, {
      'payment_method': paymentMethod,
      'shipping_address': shippingAddress,
    });
    _items.clear();
  }
}
