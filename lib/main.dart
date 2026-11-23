import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/splash_screen.dart';

void main() {
  runApp(const IhanBuyApp());
}

class IhanBuyApp extends StatelessWidget {
  const IhanBuyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IhanBuy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SplashScreen(),
    );
  }
}