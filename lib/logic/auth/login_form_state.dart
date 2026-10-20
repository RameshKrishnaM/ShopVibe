import 'package:equatable/equatable.dart';

/// State representation for Login form validation and password visibility
class LoginFormState extends Equatable {
  final String email;
  final String password;
  final bool isPasswordVisible;
  final String? emailError;
  final String? passwordError;
  final bool isEmailTouched;
  final bool isPasswordTouched;

  const LoginFormState({
    this.email = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.emailError,
    this.passwordError,
    this.isEmailTouched = false,
    this.isPasswordTouched = false,
  });

  /// Evaluates whether the form is fully valid to enable submit button
  bool get isValid =>
      email.trim().isNotEmpty &&
      password.isNotEmpty &&
      emailError == null &&
      passwordError == null;

  LoginFormState copyWith({
    String? email,
    String? password,
    bool? isPasswordVisible,
    String? Function()? emailError,
    String? Function()? passwordError,
    bool? isEmailTouched,
    bool? isPasswordTouched,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      emailError: emailError != null ? emailError() : this.emailError,
      passwordError:
          passwordError != null ? passwordError() : this.passwordError,
      isEmailTouched: isEmailTouched ?? this.isEmailTouched,
      isPasswordTouched: isPasswordTouched ?? this.isPasswordTouched,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        isPasswordVisible,
        emailError,
        passwordError,
        isEmailTouched,
        isPasswordTouched,
      ];
}
