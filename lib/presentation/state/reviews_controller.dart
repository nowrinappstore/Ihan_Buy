// lib/presentation/state/reviews_controller.dart
import 'package:flutter/foundation.dart';

import '../../data/service/product_service.dart';
import '../../domain/entities/review.dart';

class ReviewsController extends ChangeNotifier {
  final ProductService _productService;

  ReviewsController(this._productService);

  List<Review> reviewsFor(String productId) => _productService.getReviews(productId);

  void addReview({required String productId, required String name, required String text}) {
    _productService.addReview(Review(productId: productId, name: name, text: text));
    notifyListeners();
  }
}
