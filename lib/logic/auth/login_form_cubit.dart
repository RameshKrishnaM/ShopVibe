import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appcart/core/constants/app_constants.dart';
import 'package:appcart/core/utils/validators.dart';
import 'package:appcart/logic/auth/login_form_state.dart';

/// Cubit managing input form validation, reactive error tracking, and password visibility
class LoginFormCubit extends Cubit<LoginFormState> {
  LoginFormCubit() : super(const LoginFormState());

  /// Handles email change with dynamic validation
  void onEmailChanged(String value) {
    final error = Validators.validateEmail(value);
    emit(state.copyWith(
      email: value,
      isEmailTouched: true,
      emailError: () => error,
    ));
  }

  /// Handles password change with dynamic validation
  void onPasswordChanged(String value) {
    final error = Validators.validatePassword(value);
    emit(state.copyWith(
      password: value,
      isPasswordTouched: true,
      passwordError: () => error,
    ));
  }

  /// Toggles password obscurity
  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  /// Fills demo credentials for rapid assessment evaluation
  void fillDemoCredentials() {
    emit(state.copyWith(
      email: AppConstants.demoEmail,
      password: AppConstants.demoPassword,
      isEmailTouched: true,
      isPasswordTouched: true,
      emailError: () => null,
      passwordError: () => null,
    ));
  }

  /// Forces validation of all fields (e.g. on submit tap attempt)
  bool validate() {
    final emailErr = Validators.validateEmail(state.email);
    final passErr = Validators.validatePassword(state.password);
    emit(state.copyWith(
      isEmailTouched: true,
      isPasswordTouched: true,
      emailError: () => emailErr,
      passwordError: () => passErr,
    ));
    return emailErr == null && passErr == null;
  }

  /// Resets the form to initial pristine state
  void reset() {
    emit(const LoginFormState());
  }
}
