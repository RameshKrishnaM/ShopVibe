import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopvibe/data/models/user_model.dart';
import 'package:shopvibe/data/repositories/auth_repository.dart';
import 'package:shopvibe/logic/auth/auth_state.dart';

/// Cubit managing high-level authentication lifecycle
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({
    required this.authRepository,
    UserModel? initialUser,
  }) : super(initialUser != null
            ? AuthAuthenticated(initialUser)
            : const AuthInitial());

  /// Checks local storage for active saved session
  Future<void> checkAuthStatus() async {
    final user = await authRepository.getSavedUser();
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  /// Attempts login using provided credentials
  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    try {
      final user = await authRepository.login(
        email: email,
        password: password,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  /// Logs out the user and clears authentication state
  Future<void> logout() async {
    await authRepository.logout();
    emit(const AuthUnauthenticated());
  }
}
