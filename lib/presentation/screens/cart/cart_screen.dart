import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appcart/core/constants/app_colors.dart';
import 'package:appcart/core/utils/currency_formatter.dart';
import 'package:appcart/data/models/cart_item_model.dart';
import 'package:appcart/logic/cart/cart_bloc.dart';
import 'package:appcart/logic/cart/cart_event.dart';
import 'package:appcart/logic/cart/cart_state.dart';
import 'package:appcart/presentation/widgets/cart_item_tile.dart';
import 'package:appcart/presentation/widgets/empty_state_view.dart';
import 'package:appcart/presentation/widgets/price_summary_card.dart';

/// Screen 3: Cart Screen complying with all assessment requirements
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  void _onCheckoutPressed(BuildContext context, double totalAmount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                size: 42,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Order Placed!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your demo order for ${CurrencyFormatter.format(totalAmount)} has been placed successfully.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(180, 46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.read<CartBloc>().add(const ClearCartEvent());
              Navigator.pop(context); // Return to products
            },
            child: const Text('Back to Shopping'),
          ),
        ],
      ),
    );
  }

  void _confirmClearCart(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear Cart'),
        content: const Text(
          'Are you sure you want to remove all items from your shopping cart?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.read<CartBloc>().add(const ClearCartEvent());
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(
              state.isEmpty
                  ? 'Shopping Cart'
                  : 'Shopping Cart (${state.totalItemCount})',
            ),
            actions: [
              if (state.isNotEmpty)
                IconButton(
                  icon: const Icon(
                    Icons.delete_sweep_outlined,
                    color: AppColors.textSecondary,
                  ),
                  tooltip: 'Clear Cart',
                  onPressed: () => _confirmClearCart(context),
                ),
            ],
          ),
          body: state.isEmpty
              ? EmptyStateView(
                  icon: Icons.remove_shopping_cart_outlined,
                  title: 'Your Cart is Empty',
                  message:
                      'Looks like you haven\'t added any items to your cart yet. Explore our curated catalog and start shopping!',
                  buttonText: 'Start Shopping',
                  onButtonPressed: () => Navigator.pop(context),
                )
              : Column(
                  children: [
                    // Cart Line Items List
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        itemCount: state.items.length,
                        itemBuilder: (context, index) {
                          final CartItemModel item = state.items[index];

                          return CartItemTile(
                            key: ValueKey(item.product.id),
                            item: item,
                            onIncrement: () {
                              context.read<CartBloc>().add(
                                    IncrementQuantityEvent(item.product.id),
                                  );
                            },
                            onDecrement: () {
                              context.read<CartBloc>().add(
                                    DecrementQuantityEvent(item.product.id),
                                  );
                            },
                            onRemove: () {
                              context.read<CartBloc>().add(
                                    RemoveFromCartEvent(item.product.id),
                                  );
                            },
                          );
                        },
                      ),
                    ),

                    // Price Breakdown & Checkout Bottom Sheet
                    PriceSummaryCard(
                      subtotal: state.totalPrice,
                      onCheckout: () =>
                          _onCheckoutPressed(context, state.totalPrice),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
