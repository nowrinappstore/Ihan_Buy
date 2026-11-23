import 'package:flutter/material.dart';
import '../../core/network/api_client.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/usecases/add_to_cart.dart';
import '../../domain/usecases/checkout.dart';
import '../../domain/usecases/remove_from_cart.dart';
import '../../domain/usecases/toggle_wishlist.dart';
import '../../domain/usecases/update_cart_quantity.dart';

class CartController extends ChangeNotifier {
  final CartRepository _repository;
  final AddToCart _addToCart;
  final RemoveFromCart _removeFromCart;
  final UpdateCartQuantity _updateCartQuantity;
  final ToggleWishlist _toggleWishlist;
  final Checkout _checkout;

  CartController({
    required CartRepository repository,
    required AddToCart addToCart,
    required RemoveFromCart removeFromCart,
    required UpdateCartQuantity updateCartQuantity,
    required ToggleWishlist toggleWishlist,
    required Checkout checkout,
  })  : _repository = repository,
        _addToCart = addToCart,
        _removeFromCart = removeFromCart,
        _updateCartQuantity = updateCartQuantity,
        _toggleWishlist = toggleWishlist,
        _checkout = checkout;

  bool isLoading = false;
  String? errorMessage;

  List<CartItem> get cart => _repository.items;

  int get cartCount => cart.fold(0, (sum, item) => sum + item.quantity);

  double get cartTotal => cart.fold(0, (sum, item) => sum + item.total);

  Future<bool> addToCart(Product product, {required Color color, required String size, int quantity = 1}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _addToCart(product, color: color, size: size, quantity: quantity);
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (_) {
      errorMessage = 'Could not add this item to your cart. Please try again.';
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
      await _removeFromCart(item);
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (_) {
      errorMessage = 'Could not remove this item. Please try again.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateQuantity(CartItem item, int delta) async {
    errorMessage = null;
    try {
      await _updateCartQuantity(item, delta);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      errorMessage = 'Could not update the quantity. Please try again.';
      notifyListeners();
      return false;
    }
  }

  bool isWishlisted(String productId) => _repository.wishlistIds.contains(productId);

  void toggleWishlist(String productId) {
    _toggleWishlist(productId);
    notifyListeners();
  }

  Future<bool> checkout({required Map<String, dynamic> shippingAddress, String paymentMethod = 'cod'}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _checkout(shippingAddress: shippingAddress, paymentMethod: paymentMethod);
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (_) {
      errorMessage = 'Could not place your order. Please try again.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
