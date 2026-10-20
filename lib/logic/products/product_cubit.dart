import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appcart/data/models/product_model.dart';
import 'package:appcart/data/repositories/product_repository.dart';
import 'package:appcart/logic/products/product_state.dart';

/// Cubit managing product fetching, category filtering, and instant search
class ProductCubit extends Cubit<ProductState> {
  final ProductRepository productRepository;

  ProductCubit({required this.productRepository})
      : super(const ProductInitial());

  /// Loads products from repository
  Future<void> loadProducts() async {
    emit(const ProductLoading());
    try {
      final products = await productRepository.fetchProducts();
      final categories = productRepository.getCategories();
      emit(ProductLoaded(
        allProducts: products,
        filteredProducts: products,
        categories: categories,
        selectedCategory: 'All',
        searchQuery: '',
      ));
    } catch (e) {
      emit(ProductError('Failed to load products: ${e.toString()}'));
    }
  }

  /// Filters products by selected category
  void selectCategory(String category) {
    final currentState = state;
    if (currentState is ProductLoaded) {
      final filtered = _filter(
        currentState.allProducts,
        category,
        currentState.searchQuery,
      );
      emit(currentState.copyWith(
        selectedCategory: category,
        filteredProducts: filtered,
      ));
    }
  }

  /// Filters products by real-time search keyword
  void search(String query) {
    final currentState = state;
    if (currentState is ProductLoaded) {
      final filtered = _filter(
        currentState.allProducts,
        currentState.selectedCategory,
        query,
      );
      emit(currentState.copyWith(
        searchQuery: query,
        filteredProducts: filtered,
      ));
    }
  }

  List<ProductModel> _filter(
    List<ProductModel> products,
    String category,
    String query,
  ) {
    return products.where((product) {
      final matchesCategory =
          category == 'All' || product.category.toLowerCase() == category.toLowerCase();

      final cleanQuery = query.trim().toLowerCase();
      final matchesQuery = cleanQuery.isEmpty ||
          product.name.toLowerCase().contains(cleanQuery) ||
          product.description.toLowerCase().contains(cleanQuery);

      return matchesCategory && matchesQuery;
    }).toList();
  }
}
