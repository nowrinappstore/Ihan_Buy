import '../../core/network/api_client.dart';

class ProductApiDataSource {
  final ApiClient _client;

  ProductApiDataSource(this._client);

  Future<List<dynamic>> getProducts() async {
    final json = await _client.get('/products');
    final results = (json['data'] as Map<String, dynamic>?)?['results'];
    return results is List ? results : const [];
  }

  Future<List<dynamic>> getCategories() async {
    final json = await _client.get('/categories');
    final results = (json['data'] as Map<String, dynamic>?)?['results'];
    return results is List ? results : const [];
  }
}
