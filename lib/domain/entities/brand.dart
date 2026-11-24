// lib/domain/entities/brand.dart
/// No backend/data support exists for brands today. This entity is a stub
/// kept so `brand_service.dart` has a non-JSON return type to satisfy the
/// service layer contract; it currently always resolves to an empty list.
class Brand {
  final String id;
  final String name;
  final String? logoUrl;

  const Brand({required this.id, required this.name, this.logoUrl});
}
