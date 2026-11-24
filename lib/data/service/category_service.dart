// lib/data/service/category_service.dart
import '../../core/end_points.dart';
import '../../domain/entities/category.dart';
import '../model/category_model.dart';
import 'network/http_client.dart';

class CategoryService {
  final HttpClient _client;

  CategoryService(this._client);

  Future<List<Category>> getCategories() async {
    final json = await _client.get(EndPoints.categories);
    final results = (json['data'] as Map<String, dynamic>?)?['results'];
    final raw = results is List ? results : const [];
    return [
      for (var i = 0; i < raw.length; i++)
        CategoryModel.fromJson(raw[i] as Map<String, dynamic>, index: i).toEntity(),
    ];
  }
}
