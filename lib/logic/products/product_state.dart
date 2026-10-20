import 'package:equatable/equatable.dart';
import 'package:appcart/data/models/product_model.dart';

/// State representation for product catalog, category filters, and search
abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  const ProductLoading();
}

class ProductLoaded extends ProductState {
  final List<ProductModel> allProducts;
  final List<ProductModel> filteredProducts;
  final List<String> categories;
  final String selectedCategory;
  final String searchQuery;

  const ProductLoaded({
    required this.allProducts,
    required this.filteredProducts,
    required this.categories,
    this.selectedCategory = 'All',
    this.searchQuery = '',
  });

  ProductLoaded copyWith({
    List<ProductModel>? allProducts,
    List<ProductModel>? filteredProducts,
    List<String>? categories,
    String? selectedCategory,
    String? searchQuery,
  }) {
    return ProductLoaded(
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        allProducts,
        filteredProducts,
        categories,
        selectedCategory,
        searchQuery,
      ];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}
