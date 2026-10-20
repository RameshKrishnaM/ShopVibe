import 'package:equatable/equatable.dart';
import 'package:shopvibe/data/models/product_model.dart';

/// Base abstract event for CartBloc
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

/// Event dispatched when user adds a product to the cart
class AddToCartEvent extends CartEvent {
  final ProductModel product;
  final int quantity;

  const AddToCartEvent(this.product, {this.quantity = 1})
      : assert(quantity > 0, 'Quantity must be positive');

  @override
  List<Object?> get props => [product, quantity];
}

/// Event dispatched when user removes a product entirely from the cart
class RemoveFromCartEvent extends CartEvent {
  final String productId;

  const RemoveFromCartEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

/// Event dispatched to update item quantity directly
class UpdateQuantityEvent extends CartEvent {
  final String productId;
  final int newQuantity;

  const UpdateQuantityEvent({
    required this.productId,
    required this.newQuantity,
  });

  @override
  List<Object?> get props => [productId, newQuantity];
}

/// Event dispatched to increment item quantity by 1
class IncrementQuantityEvent extends CartEvent {
  final String productId;

  const IncrementQuantityEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

/// Event dispatched to decrement item quantity by 1
class DecrementQuantityEvent extends CartEvent {
  final String productId;

  const DecrementQuantityEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

/// Event dispatched to clear all items in the cart
class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}
