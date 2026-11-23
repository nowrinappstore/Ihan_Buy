import '../entities/category.dart';
import '../entities/product.dart';
import '../entities/review.dart';

abstract class ProductRepository {
  Future<List<Category>> getCategories();
  Future<List<Product>> getProducts();
  List<Review> getReviews(String productId);
  void addReview(Review review);
}
