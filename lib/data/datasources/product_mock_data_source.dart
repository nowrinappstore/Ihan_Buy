import '../../domain/entities/review.dart';

class ProductMockDataSource {
  static final List<Review> _reviews = [];

  static List<Review> reviewsFor(String productId) =>
      _reviews.where((r) => r.productId == productId).toList();

  static void addReview(Review review) => _reviews.add(review);
}
