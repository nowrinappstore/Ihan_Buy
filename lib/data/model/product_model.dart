// lib/data/model/product_model.dart
import '../../core/app_colors.dart';
import '../../domain/entities/product.dart';

class ProductModel {
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

  const ProductModel({
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

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final rawCategories = json['categories'];
    final categoryIds = <String>[];
    String categoryName = 'Uncategorized';
    if (rawCategories is List) {
      for (final entry in rawCategories) {
        if (entry is Map<String, dynamic>) {
          final id = entry['_id']?.toString();
          if (id != null) categoryIds.add(id);
          if (categoryName == 'Uncategorized' && entry['title'] != null) {
            categoryName = entry['title'].toString();
          }
        } else if (entry != null) {
          categoryIds.add(entry.toString());
        }
      }
    }

    final photos = json['photos'];
    final imageUrl = photos is List && photos.isNotEmpty ? photos.first?.toString() : null;

    final colors = json['colors'];
    final colorOptions = <String>[];
    if (colors is List) {
      for (final name in colors) {
        final key = name.toString().toLowerCase();
        if (AppColors.namedSwatches.containsKey(key)) colorOptions.add(key);
      }
    }

    final sizes = json['sizes'];
    final sizeOptions = sizes is List ? sizes.map((e) => e.toString()).toList() : <String>[];

    return ProductModel(
      id: json['_id']?.toString() ?? '',
      name: json['title']?.toString() ?? '',
      price: double.tryParse(json['current_price']?.toString() ?? '') ?? 0,
      rating: double.tryParse(json['rating']?.toString() ?? '') ?? 0,
      categoryName: categoryName,
      categoryIds: categoryIds,
      imageUrl: imageUrl,
      colorOptions: colorOptions,
      sizeOptions: sizeOptions,
      description: json['description']?.toString() ?? '',
    );
  }

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      price: price,
      rating: rating,
      categoryName: categoryName,
      categoryIds: categoryIds,
      imageUrl: imageUrl,
      colorOptions: colorOptions,
      sizeOptions: sizeOptions,
      description: description,
    );
  }
}
