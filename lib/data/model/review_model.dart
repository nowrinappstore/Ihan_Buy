// lib/data/model/review_model.dart
import '../../domain/entities/review.dart';

/// No reviews backend exists; reviews live in-memory only for the session.
class ReviewModel {
  final String productId;
  final String name;
  final String text;

  const ReviewModel({required this.productId, required this.name, required this.text});

  Review toEntity() => Review(productId: productId, name: name, text: text);
}
