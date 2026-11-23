import 'package:flutter/foundation.dart' hide Category;

import '../../core/network/api_client.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductsController extends ChangeNotifier {
  final ProductRepository _repository;

  ProductsController({required ProductRepository repository}) : _repository = repository;

  List<Product> products = [];
  List<Category> categories = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final results = await Future.wait([_repository.getProducts(), _repository.getCategories()]);
      products = results[0] as List<Product>;
      categories = results[1] as List<Category>;
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (_) {
      errorMessage = 'Could not load products. Please try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
