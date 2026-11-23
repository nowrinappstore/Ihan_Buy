import '../entities/review.dart';
import '../repositories/product_repository.dart';

class CreateReview {
  final ProductRepository repository;

  CreateReview(this.repository);

  void call({required String productId, required String name, required String text}) {
    repository.addReview(Review(productId: productId, name: name, text: text));
  }
}