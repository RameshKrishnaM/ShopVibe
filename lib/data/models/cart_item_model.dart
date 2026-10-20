import 'package:equatable/equatable.dart';
import 'package:shopvibe/data/models/product_model.dart';

/// Model representing an item in the shopping cart with its quantity
class CartItemModel extends Equatable {
  final ProductModel product;
  final int quantity;

  const CartItemModel({
    required this.product,
    this.quantity = 1,
  }) : assert(quantity > 0, 'Quantity must be at least 1');

  /// Subtotal for this item line
  double get subtotal => product.price * quantity;

  CartItemModel copyWith({
    ProductModel? product,
    int? quantity,
  }) {
    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [product, quantity];
}
