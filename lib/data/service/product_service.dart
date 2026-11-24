// lib/data/service/product_service.dart
import '../../core/end_points.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_details.dart';
import '../../domain/entities/review.dart';
import '../model/product_model.dart';
import 'network/http_client.dart';

class ProductService {
  final HttpClient _client;

  ProductService(this._client);

  // MOCK: no reviews backend endpoint exists — kept in-memory only, resets
  // every app session.
  final List<Review> _mockReviews = [];

  Future<List<Product>> getProducts() async {
    final json = await _client.get(EndPoints.products);
    final results = (json['data'] as Map<String, dynamic>?)?['results'];
    final raw = results is List ? results : const [];
    return raw.map((e) => ProductModel.fromJson(e as Map<String, dynamic>).toEntity()).toList();
  }

  /// The backend has no dedicated product-detail endpoint, so this re-fetches
  /// the product list and wraps the matching item with empty extensions.
  Future<ProductDetails> getProductDetails(String productId) async {
    final products = await getProducts();
    final product = products.firstWhere(
      (p) => p.id == productId,
      orElse: () => throw StateError('Product not found: $productId'),
    );
    return ProductDetails(product: product);
  }

  List<Review> getReviews(String productId) =>
      _mockReviews.where((r) => r.productId == productId).toList();

  void addReview(Review review) => _mockReviews.add(review);
}
