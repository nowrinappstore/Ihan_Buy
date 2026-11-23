import 'package:flutter/material.dart';
import '../../core/di/injector.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/app_logo.dart';
import 'complete_profile_screen.dart';
import 'main_shell.dart';

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
        const SnackBar(content: Text('Please enter your email and password')),
      );
      return;
    }

    if (_isLoginMode) {
      final success = await authController.login(email, password);
      if (!mounted) return;
      if (success) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const MainShell()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authController.errorMessage!)),
        );
      }
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CompleteProfileScreen(email: email, password: password),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppLogo(size: 56),
              const SizedBox(height: 32),
              Text(
                _isLoginMode ? 'Welcome Back' : 'Create Account',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _isLoginMode
                    ? 'Please Enter Your Email And Password'
                    : 'Please Enter Your Email And Choose A Password',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 28),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Email Address'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Password'),
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
                        : Text(_isLoginMode ? 'Log In' : 'Next'),
                  );
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => setState(() => _isLoginMode = !_isLoginMode),
                child: Text(
                  _isLoginMode ? "Don't have an account? Sign Up" : 'Already have an account? Log In',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
