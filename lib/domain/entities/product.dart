import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final double rating;
  final String categoryName;
  final List<String> categoryIds;
  final IconData icon;
  final Color color;
  final String? imageUrl;
  final List<Color> colorOptions;
  final List<String> sizeOptions;
  final String description;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.categoryName,
    this.categoryIds = const [],
    required this.icon,
    required this.color,
    this.imageUrl,
    this.colorOptions = const [],
    this.sizeOptions = const [],
    this.description =
        'Reference site about Lorem Ipsum, giving information on its origins, '
            'as well as a random Lipsum generator. Reference site about Lorem '
            'Ipsum, giving information on its origins, as well as a random '
            'Lipsum generator.',
  });

  static const Map<String, Color> namedColors = {
    'black': Colors.black,
    'white': Colors.white,
    'grey': Colors.grey,
    'gray': Colors.grey,
    'red': Colors.red,
    'blue': Colors.blue,
    'green': Colors.green,
    'yellow': Colors.yellow,
    'orange': Colors.orange,
    'pink': Colors.pink,
    'purple': Colors.purple,
    'brown': Color(0xFF8B5E3C),
    'gold': Color(0xFFD4AF37),
    'silver': Color(0xFFC0C0C0),
  };

  /// Reverse lookup used when sending a locally-picked [Color] back to the API.
  static String? colorName(Color color) {
    for (final entry in namedColors.entries) {
      if (entry.value == color) return entry.key;
    }
    return null;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
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
    final colorOptions = <Color>[];
    if (colors is List) {
      for (final name in colors) {
        final color = namedColors[name.toString().toLowerCase()];
        if (color != null) colorOptions.add(color);
      }
    }

    final sizes = json['sizes'];
    final sizeOptions = sizes is List ? sizes.map((e) => e.toString()).toList() : <String>[];

    return Product(
      id: json['_id']?.toString() ?? '',
      name: json['title']?.toString() ?? '',
      price: double.tryParse(json['current_price']?.toString() ?? '') ?? 0,
      rating: double.tryParse(json['rating']?.toString() ?? '') ?? 0,
      categoryName: categoryName,
      categoryIds: categoryIds,
      icon: Icons.shopping_bag_outlined,
      color: const Color(0xFF5B8DEF),
      imageUrl: imageUrl,
      colorOptions: colorOptions,
      sizeOptions: sizeOptions,
      description: json['description']?.toString() ?? '',
    );
  }
}
