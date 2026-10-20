import 'package:flutter/material.dart';
import 'package:appcart/data/models/product_model.dart';
import 'package:appcart/presentation/screens/auth/login_screen.dart';
import 'package:appcart/presentation/screens/cart/cart_screen.dart';
import 'package:appcart/presentation/screens/products/product_detail_screen.dart';
import 'package:appcart/presentation/screens/products/product_listing_screen.dart';

/// Centralized route manager for named routing
class AppRouter {
  static const String login = '/login';
  static const String products = '/products';
  static const String cart = '/cart';
  static const String productDetail = '/product-detail';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );

      case products:
        return MaterialPageRoute(
          builder: (_) => const ProductListingScreen(),
          settings: settings,
        );

      case productDetail:
        final product = settings.arguments as ProductModel;
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(product: product),
          settings: settings,
        );

      case cart:
        return MaterialPageRoute(
          builder: (_) => const CartScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
    }
  }
}

