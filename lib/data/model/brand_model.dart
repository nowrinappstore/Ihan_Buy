// lib/data/model/brand_model.dart
import '../../domain/entities/brand.dart';

/// No backend/data support exists for brands today; `fromJson` is kept so
/// this model is ready the moment a brands endpoint exists.
class BrandModel {
  final String id;
  final String name;
  final String? logoUrl;

  const BrandModel({required this.id, required this.name, this.logoUrl});

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      logoUrl: json['logo']?.toString(),
    );
  }

  Brand toEntity() => Brand(id: id, name: name, logoUrl: logoUrl);
}
