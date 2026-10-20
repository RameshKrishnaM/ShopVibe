import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopvibe/core/constants/app_colors.dart';
import 'package:shopvibe/data/models/product_model.dart';
import 'package:shopvibe/logic/auth/auth_cubit.dart';
import 'package:shopvibe/logic/auth/auth_state.dart';
import 'package:shopvibe/logic/cart/cart_bloc.dart';
import 'package:shopvibe/logic/cart/cart_event.dart';
import 'package:shopvibe/logic/cart/cart_state.dart';
import 'package:shopvibe/logic/products/product_cubit.dart';
import 'package:shopvibe/logic/products/product_state.dart';
import 'package:shopvibe/presentation/navigation/app_router.dart';
import 'package:shopvibe/presentation/widgets/cart_badge_icon.dart';
import 'package:shopvibe/presentation/widgets/empty_state_view.dart';
import 'package:shopvibe/presentation/widgets/product_card.dart';

/// Screen 2: Product Listing Screen with search, category filtering, and live cart integration
class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({super.key});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load products on initial view
    context.read<ProductCubit>().loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onAddToCart(BuildContext context, ProductModel product) {
    context.read<CartBloc>().add(AddToCartEvent(product));

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Added ${product.name} to cart',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: Colors.amberAccent,
          onPressed: () {
            Navigator.pushNamed(context, AppRouter.cart);
          },
        ),
        backgroundColor: AppColors.textPrimary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    final userName =
        authState is AuthAuthenticated ? authState.user.displayName : null;

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign Out'),
        content: Text(
          userName != null
              ? 'Are you sure you want to sign out, $userName?'
              : 'Are you sure you want to sign out of your account?',
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
              minimumSize: const Size(80, 40),
            ),
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.read<AuthCubit>().logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRouter.login,
                (route) => false,
              );
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            final userName = authState is AuthAuthenticated
                ? authState.user.displayName
                : null;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ShopVibe',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  userName != null && userName.isNotEmpty
                      ? 'Hello, $userName 👋'
                      : 'Curated Essentials',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          CartBadgeIcon(
            onTap: () => Navigator.pushNamed(context, AppRouter.cart),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.textSecondary),
            tooltip: 'Sign Out',
            onPressed: () => _confirmLogout(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, productState) {
          if (productState is ProductLoading || productState is ProductInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (productState is ProductError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded,
                      size: 48, color: AppColors.error),
                  const SizedBox(height: 12),
                  Text(
                    productState.message,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<ProductCubit>().loadProducts(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (productState is ProductLoaded) {
            return RefreshIndicator(
              onRefresh: () => context.read<ProductCubit>().loadProducts(),
              color: AppColors.primary,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // Search Bar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) =>
                              context.read<ProductCubit>().search(value),
                          decoration: InputDecoration(
                            hintText: 'Search products by name or details...',
                            hintStyle: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textTertiary,
                            ),
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: AppColors.textSecondary,
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.clear_rounded,
                                      size: 18,
                                      color: AppColors.textSecondary,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      context.read<ProductCubit>().search('');
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Category Filter Pills
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 52,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: productState.categories.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final category = productState.categories[index];
                          final isSelected =
                              productState.selectedCategory == category;

                          return Center(
                            child: FilterChip(
                              label: Text(category),
                              selected: isSelected,
                              onSelected: (_) => context
                                  .read<ProductCubit>()
                                  .selectCategory(category),
                              backgroundColor: Colors.white,
                              selectedColor: AppColors.primary,
                              labelStyle: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                              showCheckmark: false,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.border,
                                  width: 1,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Products Grid Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Featured Items (${productState.filteredProducts.length})',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (productState.selectedCategory != 'All' ||
                              productState.searchQuery.isNotEmpty)
                            InkWell(
                              onTap: () {
                                _searchController.clear();
                                context.read<ProductCubit>().loadProducts();
                              },
                              child: const Text(
                                'Clear Filters',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Empty Search / Filter State
                  if (productState.filteredProducts.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyStateView(
                        icon: Icons.search_off_rounded,
                        title: 'No Products Found',
                        message:
                            'We could not find any items matching "${productState.searchQuery}". Try a different search term or category.',
                        buttonText: 'Reset Filters',
                        onButtonPressed: () {
                          _searchController.clear();
                          context.read<ProductCubit>().loadProducts();
                        },
                      ),
                    )
                  else
                    // Reusable Product Cards Grid
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      sliver: SliverLayoutBuilder(
                        builder: (context, constraints) {
                          // Adaptive column count for wider screens/desktop vs phone
                          final crossAxisCount =
                              constraints.crossAxisExtent > 700 ? 3 : 2;

                          return BlocBuilder<CartBloc, CartState>(
                            builder: (context, cartState) {
                              return SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 14,
                                  mainAxisSpacing: 14,
                                  childAspectRatio: 0.63,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final product =
                                        productState.filteredProducts[index];
                                    final inCartQty = cartState
                                        .getProductQuantity(product.id);

                                    return ProductCard(
                                      product: product,
                                      cartQuantity: inCartQty,
                                      onAddToCart: () =>
                                          _onAddToCart(context, product),
                                      onIncrement: () => context
                                          .read<CartBloc>()
                                          .add(IncrementQuantityEvent(product.id)),
                                      onDecrement: () => context
                                          .read<CartBloc>()
                                          .add(DecrementQuantityEvent(product.id)),
                                      onTap: () => Navigator.pushNamed(
                                        context,
                                        AppRouter.productDetail,
                                        arguments: product,
                                      ),
                                    );
                                  },
                                  childCount:
                                      productState.filteredProducts.length,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      ),
    );
  }
}
