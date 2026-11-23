import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/di/injector.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/app_logo.dart';
import 'main_shell.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(4, (_) => FocusNode());
  int _secondsLeft = 120;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _secondsLeft = 120;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  Future<void> _handleNext() async {
    final code = _controllers.map((c) => c.text).join();
    if (code.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the full 4-digit code')),
      );
      return;
    }

    final verified = await authController.verifyOtp(code);
    if (!mounted) return;

    if (verified) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainShell()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authController.errorMessage!)),
      );
    }
  }

  Future<void> _handleResend() async {
    setState(_startTimer);
    await authController.sendOtp(widget.email);
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
              const Text(
                'Enter OTP Code',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'A 4 Digit OTP Code has been Sent',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (i) {
                  return SizedBox(
                    width: 64,
                    height: 64,
                    child: TextField(
                      controller: _controllers[i],
                      focusNode: _nodes[i],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(counterText: ''),
                      onChanged: (value) {
                        if (value.isNotEmpty && i < 3) {
                          _nodes[i + 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
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
                        : const Text('Next'),
                  );
                },
              ),
              const SizedBox(height: 16),
              Text(
                'This code will expire in $_secondsLeft s',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: _secondsLeft == 0 ? _handleResend : null,
                child: const Text('Resend Code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}