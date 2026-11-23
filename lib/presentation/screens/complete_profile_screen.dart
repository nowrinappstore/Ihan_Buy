import 'package:flutter/material.dart';
import '../../core/di/injector.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/app_logo.dart';
import 'otp_screen.dart';

class CompleteProfileScreen extends StatefulWidget {
  final String email;
  final String password;

  const CompleteProfileScreen({super.key, required this.email, required this.password});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _handleComplete() async {
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your first and last name')),
      );
      return;
    }

    final signedUp = await authController.signup(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: widget.email,
      password: widget.password,
      phone: _phoneController.text.trim(),
      city: _cityController.text.trim(),
      address: _addressController.text.trim(),
    );
    if (!mounted) return;

    if (signedUp) {
      final sent = await authController.sendOtp(widget.email);
      if (!mounted) return;
      if (sent) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => OtpScreen(email: widget.email)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authController.errorMessage!)),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authController.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              const AppLogo(size: 56),
              const SizedBox(height: 24),
              const Text(
                'Complete Profile',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Get started with us with your details',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(hintText: 'First Name'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(hintText: 'Last Name'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(hintText: 'Mobile'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _cityController,
                decoration: const InputDecoration(hintText: 'City'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _addressController,
                maxLines: 3,
                decoration: const InputDecoration(hintText: 'Shipping Address'),
              ),
              const SizedBox(height: 24),
              AnimatedBuilder(
                animation: authController,
                builder: (context, _) {
                  return ElevatedButton(
                    onPressed: authController.isLoading ? null : _handleComplete,
                    child: authController.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Complete'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
