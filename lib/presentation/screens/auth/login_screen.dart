import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopvibe/core/constants/app_colors.dart';
import 'package:shopvibe/core/constants/app_constants.dart';
import 'package:shopvibe/logic/auth/auth_cubit.dart';
import 'package:shopvibe/logic/auth/auth_state.dart';
import 'package:shopvibe/logic/auth/login_form_cubit.dart';
import 'package:shopvibe/logic/auth/login_form_state.dart';
import 'package:shopvibe/presentation/navigation/app_router.dart';
import 'package:shopvibe/presentation/widgets/custom_button.dart';
import 'package:shopvibe/presentation/widgets/custom_text_field.dart';

/// Screen 1: Login Screen adhering to all assessment requirements
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed(BuildContext context, LoginFormState formState) {
    FocusScope.of(context).unfocus();
    context.read<AuthCubit>().login(
          email: formState.email,
          password: formState.password,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginFormCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, authState) {
          if (authState is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(child: Text(authState.message)),
                  ],
                ),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          } else if (authState is AuthAuthenticated) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRouter.products,
              (route) => false,
            );
          }
        },
        builder: (context, authState) {
          final isLoading = authState is AuthLoading;

          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 20.0,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: BlocBuilder<LoginFormCubit, LoginFormState>(
                      builder: (context, formState) {
                        final formCubit = context.read<LoginFormCubit>();

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // App Icon / Branding
                            Center(
                              child: Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          AppColors.primary.withValues(alpha: 0.3),
                                      blurRadius: 18,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.shopping_bag_rounded,
                                  size: 38,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Header Titles
                            const Text(
                              'Welcome Back',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              AppConstants.appTagline,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Quick Fill Demo Credentials Banner
                            InkWell(
                              onTap: () {
                                formCubit.fillDemoCredentials();
                                _emailController.text =
                                    AppConstants.demoEmail;
                                _passwordController.text =
                                    AppConstants.demoPassword;
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        AppColors.primary.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.flash_on_rounded,
                                      size: 18,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Tap to autofill demo credentials\n(${AppConstants.demoEmail})',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 14,
                                      color: AppColors.primary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Form Card
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.border),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 14,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Email Field
                                  CustomTextField(
                                    key: const Key('login_email_field'),
                                    label: 'Email Address *',
                                    hintText: 'name@example.com',
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    prefixIcon: Icons.alternate_email_rounded,
                                    errorText: formState.isEmailTouched
                                        ? formState.emailError
                                        : null,
                                    onChanged: formCubit.onEmailChanged,
                                  ),
                                  const SizedBox(height: 18),

                                  // Password Field with Show/Hide
                                  CustomTextField(
                                    key: const Key('login_password_field'),
                                    label: 'Password *',
                                    hintText: 'Min. 6 characters',
                                    controller: _passwordController,
                                    obscureText: !formState.isPasswordVisible,
                                    textInputAction: TextInputAction.done,
                                    prefixIcon: Icons.lock_outline_rounded,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        formState.isPasswordVisible
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: AppColors.textSecondary,
                                        size: 20,
                                      ),
                                      onPressed:
                                          formCubit.togglePasswordVisibility,
                                    ),
                                    errorText: formState.isPasswordTouched
                                        ? formState.passwordError
                                        : null,
                                    onChanged: formCubit.onPasswordChanged,
                                    onEditingComplete: () {
                                      if (formState.isValid && !isLoading) {
                                        _onLoginPressed(context, formState);
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 26),

                                  // Reactive Login Button: Enabled only when formState.isValid is true!
                                  CustomButton(
                                    key: const Key('login_submit_button'),
                                    text: 'Sign In',
                                    isLoading: isLoading,
                                    onPressed: formState.isValid
                                        ? () => _onLoginPressed(
                                            context, formState)
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Footer Note
                            const Center(
                              child: Text(
                                'Both fields are mandatory to proceed',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
