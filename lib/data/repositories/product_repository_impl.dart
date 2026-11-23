import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_api_data_source.dart';
import '../datasources/product_mock_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductApiDataSource _apiDataSource;

  ProductRepositoryImpl(this._apiDataSource);

  @override
  Future<List<Category>> getCategories() async {
    final raw = await _apiDataSource.getCategories();
    return [
      for (var i = 0; i < raw.length; i++)
        Category.fromJson(raw[i] as Map<String, dynamic>, index: i),
    ];
  }

  @override
  Future<List<Product>> getProducts() async {
    final raw = await _apiDataSource.getProducts();
    return raw.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  List<Review> getReviews(String productId) => ProductMockDataSource.reviewsFor(productId);

  @override
  void addReview(Review review) => ProductMockDataSource.addReview(review);
}
