import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appcart/data/models/cart_item_model.dart';
import 'package:appcart/logic/cart/cart_event.dart';
import 'package:appcart/logic/cart/cart_state.dart';

/// Event-driven BLoC managing shopping cart state, line items, and mutations
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
    on<IncrementQuantityEvent>(_onIncrementQuantity);
    on<DecrementQuantityEvent>(_onDecrementQuantity);
    on<ClearCartEvent>(_onClearCart);
  }

  void _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) {
    final currentItems = List<CartItemModel>.from(state.items);
    final existingIndex = currentItems.indexWhere(
      (item) => item.product.id == event.product.id,
    );

    if (existingIndex >= 0) {
      final existingItem = currentItems[existingIndex];
      currentItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + event.quantity,
      );
    } else {
      currentItems.add(
        CartItemModel(product: event.product, quantity: event.quantity),
      );
    }

    emit(state.copyWith(
      items: currentItems,
      status: CartActionStatus.itemAdded,
      lastModifiedProduct: () => event.product,
      message: () => '${event.product.name} added to cart',
    ));
  }

  void _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) {
    final currentItems = List<CartItemModel>.from(state.items);
    final existingIndex = currentItems.indexWhere(
      (item) => item.product.id == event.productId,
    );

    if (existingIndex >= 0) {
      final removedItem = currentItems.removeAt(existingIndex);
      emit(state.copyWith(
        items: currentItems,
        status: CartActionStatus.itemRemoved,
        lastModifiedProduct: () => removedItem.product,
        message: () => '${removedItem.product.name} removed from cart',
      ));
    }
  }

  void _onUpdateQuantity(UpdateQuantityEvent event, Emitter<CartState> emit) {
    if (event.newQuantity <= 0) {
      add(RemoveFromCartEvent(event.productId));
      return;
    }

    final currentItems = List<CartItemModel>.from(state.items);
    final existingIndex = currentItems.indexWhere(
      (item) => item.product.id == event.productId,
    );

    if (existingIndex >= 0) {
      currentItems[existingIndex] = currentItems[existingIndex].copyWith(
        quantity: event.newQuantity,
      );
      emit(state.copyWith(
        items: currentItems,
        status: CartActionStatus.quantityUpdated,
        lastModifiedProduct: () => currentItems[existingIndex].product,
      ));
    }
  }

  void _onIncrementQuantity(
    IncrementQuantityEvent event,
    Emitter<CartState> emit,
  ) {
    final currentItems = List<CartItemModel>.from(state.items);
    final index = currentItems.indexWhere(
      (item) => item.product.id == event.productId,
    );

    if (index >= 0) {
      final item = currentItems[index];
      currentItems[index] = item.copyWith(quantity: item.quantity + 1);
      emit(state.copyWith(
        items: currentItems,
        status: CartActionStatus.quantityUpdated,
        lastModifiedProduct: () => item.product,
      ));
    }
  }

  void _onDecrementQuantity(
    DecrementQuantityEvent event,
    Emitter<CartState> emit,
  ) {
    final currentItems = List<CartItemModel>.from(state.items);
    final index = currentItems.indexWhere(
      (item) => item.product.id == event.productId,
    );

    if (index >= 0) {
      final item = currentItems[index];
      if (item.quantity > 1) {
        currentItems[index] = item.copyWith(quantity: item.quantity - 1);
        emit(state.copyWith(
          items: currentItems,
          status: CartActionStatus.quantityUpdated,
          lastModifiedProduct: () => item.product,
        ));
      } else {
        // Quantity reached 0 -> remove
        final removed = currentItems.removeAt(index);
        emit(state.copyWith(
          items: currentItems,
          status: CartActionStatus.itemRemoved,
          lastModifiedProduct: () => removed.product,
          message: () => '${removed.product.name} removed from cart',
        ));
      }
    }
  }

  void _onClearCart(ClearCartEvent event, Emitter<CartState> emit) {
    emit(state.copyWith(
      items: const [],
      status: CartActionStatus.cleared,
      lastModifiedProduct: () => null,
      message: () => 'Cart has been cleared',
    ));
  }
}
