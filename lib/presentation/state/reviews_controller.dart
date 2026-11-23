import 'package:flutter/foundation.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/create_review.dart';

class ReviewsController extends ChangeNotifier {
  final ProductRepository _repository;
  final CreateReview _createReview;

  ReviewsController({
    required ProductRepository repository,
    required CreateReview createReview,
  })  : _repository = repository,
        _createReview = createReview;

  List<Review> reviewsFor(String productId) => _repository.getReviews(productId);

  void addReview({required String productId, required String name, required String text}) {
    _createReview(productId: productId, name: name, text: text);
    notifyListeners();
  }
}