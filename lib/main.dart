import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appcart/core/theme/app_theme.dart';
import 'package:appcart/data/models/user_model.dart';
import 'package:appcart/data/repositories/auth_repository.dart';
import 'package:appcart/data/repositories/product_repository.dart';
import 'package:appcart/logic/auth/auth_cubit.dart';
import 'package:appcart/logic/cart/cart_bloc.dart';
import 'package:appcart/logic/products/product_cubit.dart';
import 'package:appcart/presentation/navigation/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Instantiate foundational repositories
  final authRepository = AuthRepository();
  final productRepository = ProductRepository();

  // Check local storage for persistent user login session
  final initialUser = await authRepository.getSavedUser();

  runApp(
    AppCartApp(
      authRepository: authRepository,
      productRepository: productRepository,
      initialUser: initialUser,
    ),
  );
}

/// Root Application Widget with injected repositories and global BLoC/Cubit providers
class AppCartApp extends StatelessWidget {
  final AuthRepository authRepository;
  final ProductRepository productRepository;
  final UserModel? initialUser;

  const AppCartApp({
    super.key,
    required this.authRepository,
    required this.productRepository,
    this.initialUser,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: productRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(
              authRepository: context.read<AuthRepository>(),
              initialUser: initialUser,
            ),
          ),
          BlocProvider<ProductCubit>(
            create: (context) => ProductCubit(
              productRepository: context.read<ProductRepository>(),
            ),
          ),
          // CartBloc provided at root to maintain state across screen navigations
          BlocProvider<CartBloc>(
            create: (context) => CartBloc(),
          ),
        ],
        child: MaterialApp(
          title: 'ShopVibe',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          initialRoute: initialUser != null ? AppRouter.products : AppRouter.login,
          onGenerateRoute: AppRouter.onGenerateRoute,
        ),
      ),
    );
  }
}

