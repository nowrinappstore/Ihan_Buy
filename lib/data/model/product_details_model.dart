// lib/data/model/product_details_model.dart
import '../../domain/entities/product_details.dart';
import 'product_model.dart';

class ProductDetailsModel {
  final ProductModel product;
  final List<String> images;
  final Map<String, String> specs;

  const ProductDetailsModel({
    required this.product,
    this.images = const [],
    this.specs = const {},
  });

  factory ProductDetailsModel.fromProductJson(Map<String, dynamic> json) {
    return ProductDetailsModel(product: ProductModel.fromJson(json));
  }

  ProductDetails toEntity() {
    return ProductDetails(product: product.toEntity(), images: images, specs: specs);
  }
}
