// lib/presentation/screens/login_screen.dart
import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_navigator.dart';
import '../../core/app_strings.dart';
import '../state/app_controllers.dart';
import '../widgets/app_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoginMode = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleNext() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.errorEnterEmailAndPassword)),
      );
      return;
    }

    if (_isLoginMode) {
      final success = await authController.login(email, password);
      if (!mounted) return;
      if (success) {
        AppNavigator.replaceWithMainShell(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authController.errorMessage!)),
        );
      }
    } else {
      AppNavigator.toCompleteProfile(context, email: email, password: password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppLogo(size: 56),
              const SizedBox(height: 32),
              Text(
                _isLoginMode ? AppStrings.loginWelcomeBack : AppStrings.loginCreateAccount,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _isLoginMode
                    ? AppStrings.errorEnterEmailAndPasswordLogin
                    : AppStrings.errorEnterEmailAndChoosePassword,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 28),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: AppStrings.loginEmailHint),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(hintText: AppStrings.loginPasswordHint),
              ),
              const SizedBox(height: 24),
              AnimatedBuilder(
                animation: authController,
                builder: (context, _) {
                  return ElevatedButton(
                    onPressed: authController.isLoading ? null : _handleNext,
                    child: authController.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_isLoginMode ? AppStrings.loginButton : AppStrings.next),
                  );
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => setState(() => _isLoginMode = !_isLoginMode),
                child: Text(
                  _isLoginMode ? AppStrings.loginNoAccount : AppStrings.loginHaveAccount,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
