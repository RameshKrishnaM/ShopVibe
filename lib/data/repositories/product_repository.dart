import 'dart:async';
import 'package:appcart/data/mock/mock_products.dart';
import 'package:appcart/data/models/product_model.dart';

/// Repository interface responsible for loading and querying product catalog
class ProductRepository {
  /// Fetches product list with simulated local delay
  Future<List<ProductModel>> fetchProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List<ProductModel>.unmodifiable(MockProducts.items);
  }

  /// Fetches available categories
  List<String> getCategories() {
    return List<String>.unmodifiable(MockProducts.categories);
  }
}
