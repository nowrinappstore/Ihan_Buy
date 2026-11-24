// lib/domain/entities/product_details.dart
import 'product.dart';

/// Extended product view. The backend has no dedicated product-detail
/// endpoint today, so [images]/[specs] default empty and this simply wraps
/// the [Product] returned by the product list endpoint.
class ProductDetails {
  final Product product;
  final List<String> images;
  final Map<String, String> specs;

  const ProductDetails({
    required this.product,
    this.images = const [],
    this.specs = const {},
  });
}
