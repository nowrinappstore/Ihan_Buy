import 'package:flutter/material.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_api_data_source.dart';

class CartRepositoryImpl implements CartRepository {
  final CartApiDataSource _dataSource;

  CartRepositoryImpl(this._dataSource);

  final List<CartItem> _items = [];
  final Set<String> _wishlistIds = {};

  @override
  List<CartItem> get items => _items;

  @override
  Set<String> get wishlistIds => _wishlistIds;

  @override
  CartItem? findMatching(String productId, Color color, String size) {
    for (final item in _items) {
      if (item.product.id == productId && item.color == color && item.size == size) {
        return item;
      }
    }
    return null;
  }

  @override
  Future<void> insert(CartItem item) async {
    final data = await _dataSource.addToCart(
      productId: item.product.id,
      quantity: item.quantity,
      color: Product.colorName(item.color),
      size: item.size,
    );
    item.id = data['_id']?.toString();
    _items.add(item);
  }

  @override
  Future<void> remove(CartItem item) async {
    final id = item.id;
    if (id != null) {
      await _dataSource.deleteCartItem(id);
    }
    _items.remove(item);
  }

  @override
  Future<void> setQuantity(CartItem item, int quantity) async {
    final id = item.id;
    if (id != null) {
      await _dataSource.updateCartItem(id, quantity);
    }
    item.quantity = quantity;
  }

  @override
  void toggleWishlistId(String productId) {
    if (!_wishlistIds.add(productId)) {
      _wishlistIds.remove(productId);
    }
  }

  @override
  void clear() => _items.clear();
}
