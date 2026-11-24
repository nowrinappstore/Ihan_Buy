// lib/domain/entities/review.dart
class Review {
  final String productId;
  final String name;
  final String text;

  const Review({required this.productId, required this.name, required this.text});
}
