// lib/presentation/state/cart_controller.dart
import 'package:flutter/foundation.dart';

import '../../core/app_strings.dart';
import '../../data/service/cart_service.dart';
import '../../data/service/network/response_wrapper.dart';
import '../../data/service/wishlist_service.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/product.dart';

class CartController extends ChangeNotifier {
  final CartService _cartService;
  final WishlistService _wishlistService;

  CartController(this._cartService, this._wishlistService);

  bool isLoading = false;
  String? errorMessage;

  List<CartItem> get cart => _cartService.items;

  int get cartCount => cart.fold(0, (sum, item) => sum + item.quantity);

  double get cartTotal => cart.fold(0, (sum, item) => sum + item.total);

  Future<bool> addToCart(
    Product product, {
    required String color,
    required String size,
    int quantity = 1,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _cartService.addToCart(product, color: color, size: size, quantity: quantity);
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (_) {
      errorMessage = AppStrings.errorCouldNotAddToCart;
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> removeFromCart(CartItem item) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _cartService.removeFromCart(item);
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (_) {
      errorMessage = AppStrings.errorCouldNotRemoveItem;
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateQuantity(CartItem item, int delta) async {
    errorMessage = null;
    try {
      await _cartService.updateQuantity(item, delta);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      errorMessage = AppStrings.errorCouldNotUpdateQuantity;
      notifyListeners();
      return false;
    }
  }

  bool isWishlisted(String productId) => _wishlistService.isWishlisted(productId);

  void toggleWishlist(String productId) {
    _wishlistService.toggleWishlist(productId);
    notifyListeners();
  }

  Future<bool> checkout({
    required Map<String, dynamic> shippingAddress,
    String paymentMethod = 'cod',
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _cartService.checkout(shippingAddress: shippingAddress, paymentMethod: paymentMethod);
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (_) {
      errorMessage = AppStrings.errorCouldNotPlaceOrder;
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
