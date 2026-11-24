// lib/presentation/state/products_controller.dart
import 'package:flutter/foundation.dart' hide Category;

import '../../core/app_strings.dart';
import '../../data/service/category_service.dart';
import '../../data/service/network/response_wrapper.dart';
import '../../data/service/product_service.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';

class ProductsController extends ChangeNotifier {
  final ProductService _productService;
  final CategoryService _categoryService;

  ProductsController(this._productService, this._categoryService);

  List<Product> products = [];
  List<Category> categories = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final results = await Future.wait([
        _productService.getProducts(),
        _categoryService.getCategories(),
      ]);
      products = results[0] as List<Product>;
      categories = results[1] as List<Category>;
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (_) {
      errorMessage = AppStrings.errorCouldNotLoadProducts;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
