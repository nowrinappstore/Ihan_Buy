// lib/data/model/category_model.dart
import '../../domain/entities/category.dart';

class CategoryModel {
  final String id;
  final String name;
  final int iconIndex;

  const CategoryModel({this.id = '', required this.name, this.iconIndex = 0});

  factory CategoryModel.fromJson(Map<String, dynamic> json, {int index = 0}) {
    return CategoryModel(
      id: json['_id']?.toString() ?? '',
      name: json['title']?.toString() ?? 'Category',
      iconIndex: index,
    );
  }

  Category toEntity() => Category(id: id, name: name, iconIndex: iconIndex);
}
