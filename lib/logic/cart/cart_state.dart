import 'package:equatable/equatable.dart';
import 'package:shopvibe/data/models/cart_item_model.dart';
import 'package:shopvibe/data/models/product_model.dart';

enum CartActionStatus { initial, itemAdded, itemRemoved, quantityUpdated, cleared }

/// Immutable state containing shopping cart items, totals, and action status
class CartState extends Equatable {
  final List<CartItemModel> items;
  final CartActionStatus status;
  final ProductModel? lastModifiedProduct;
  final String? message;

  const CartState({
    this.items = const [],
    this.status = CartActionStatus.initial,
    this.lastModifiedProduct,
    this.message,
  });

  /// Total sum of all line items
  double get totalPrice =>
      items.fold(0.0, (sum, item) => sum + item.subtotal);

  /// Total number of individual items in the cart
  int get totalItemCount =>
      items.fold(0, (count, item) => count + item.quantity);

  /// Number of unique product entries
  int get uniqueItemCount => items.length;

  /// Returns true if cart has 0 items
  bool get isEmpty => items.isEmpty;

  /// Returns true if cart has at least 1 item
  bool get isNotEmpty => items.isNotEmpty;

  /// Check if a specific product is already in the cart
  bool containsProduct(String productId) =>
      items.any((item) => item.product.id == productId);

  /// Get current quantity of a specific product (or 0 if not present)
  int getProductQuantity(String productId) {
    final index = items.indexWhere((item) => item.product.id == productId);
    return index != -1 ? items[index].quantity : 0;
  }

  CartState copyWith({
    List<CartItemModel>? items,
    CartActionStatus? status,
    ProductModel? Function()? lastModifiedProduct,
    String? Function()? message,
  }) {
    return CartState(
      items: items ?? this.items,
      status: status ?? this.status,
      lastModifiedProduct: lastModifiedProduct != null
          ? lastModifiedProduct()
          : this.lastModifiedProduct,
      message: message != null ? message() : this.message,
    );
  }

  @override
  List<Object?> get props => [items, status, lastModifiedProduct, message];
}
