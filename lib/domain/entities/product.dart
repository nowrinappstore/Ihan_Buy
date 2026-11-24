// lib/domain/entities/product.dart
class Product {
  final String id;
  final String name;
  final double price;
  final double rating;
  final String categoryName;
  final List<String> categoryIds;
  final String? imageUrl;
  final List<String> colorOptions;
  final List<String> sizeOptions;
  final String description;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.categoryName,
    this.categoryIds = const [],
    this.imageUrl,
    this.colorOptions = const [],
    this.sizeOptions = const [],
    this.description = '',
  });
}
