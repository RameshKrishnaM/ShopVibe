import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopvibe/core/constants/app_colors.dart';
import 'package:shopvibe/logic/cart/cart_bloc.dart';
import 'package:shopvibe/logic/cart/cart_state.dart';

/// App bar cart icon with dynamic live badge counter
class CartBadgeIcon extends StatelessWidget {
  final VoidCallback onTap;

  const CartBadgeIcon({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      buildWhen: (previous, current) =>
          previous.totalItemCount != current.totalItemCount,
      builder: (context, state) {
        final count = state.totalItemCount;

        return Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.shopping_bag_outlined,
                color: AppColors.textPrimary,
                size: 26,
              ),
              tooltip: 'Shopping Cart',
              onPressed: onTap,
            ),
            if (count > 0)
              Positioned(
                top: 6,
                right: 6,
                child: IgnorePointer(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        count > 99 ? '99+' : '$count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
