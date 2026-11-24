// lib/data/model/cart_item_model.dart
import '../../domain/entities/cart_item.dart';
import 'product_model.dart';

class CartItemModel {
  final String? id;
  final ProductModel product;
  final String color;
  final String size;
  final int quantity;

  const CartItemModel({
    this.id,
    required this.product,
    required this.color,
    required this.size,
    required this.quantity,
  });

  /// The add-to-cart endpoint only returns the created item's id, not a full
  /// cart-item shape, so the rest of the fields are supplied by the caller.
  factory CartItemModel.fromAddResponse(
    Map<String, dynamic> json, {
    required ProductModel product,
    required String color,
    required String size,
    required int quantity,
  }) {
    return CartItemModel(
      id: json['_id']?.toString(),
      product: product,
      color: color,
      size: size,
      quantity: quantity,
    );
  }

  CartItem toEntity() {
    return CartItem(
      id: id,
      product: product.toEntity(),
      color: color,
      size: size,
      quantity: quantity,
    );
  }
}
