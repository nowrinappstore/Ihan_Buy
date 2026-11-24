// lib/domain/entities/category.dart
class Category {
  final String id;
  final String name;

  /// Stable index used by the presentation layer to cycle through a fixed
  /// set of fallback icons/colors, since the backend supplies neither.
  final int iconIndex;

  const Category({
    this.id = '',
    required this.name,
    this.iconIndex = 0,
  });
}
