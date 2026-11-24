// lib/data/service/brand_service.dart
import '../../domain/entities/brand.dart';

/// No backend/data support exists for brands today. Stubbed until a real
/// brand concept is designed — intentionally returns no fake data.
class BrandService {
  Future<List<Brand>> getBrands() async => const [];
}
