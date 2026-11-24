// lib/core/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF0FA3A3);
  static const Color primaryDark = Color(0xFF0B7A7A);
  static const Color accentOrange = Color(0xFFFF7A3D);
  static const Color accentPink = Color(0xFFE94E9C);
  static const Color background = Color(0xFFF7F8FA);
  static const Color card = Colors.white;
  static const Color textPrimary = Color(0xFF1C2433);
  static const Color textSecondary = Color(0xFF8A94A6);
  static const Color border = Color(0xFFE6E9EE);
  static const Color star = Color(0xFFFFB800);

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static const Color productPlaceholder = Color(0xFF5B8DEF);

  static const List<Color> categoryFallbackColors = [
    Color(0xFF5B8DEF),
    Color(0xFFFF7A3D),
    Color(0xFF2ECC71),
    Color(0xFF0FA3A3),
    Color(0xFFE85C8A),
  ];

  static const Map<String, Color> namedSwatches = {
    'black': Colors.black,
    'white': Colors.white,
    'grey': Colors.grey,
    'gray': Colors.grey,
    'red': Colors.red,
    'blue': Colors.blue,
    'green': Colors.green,
    'yellow': Colors.yellow,
    'orange': Colors.orange,
    'pink': Colors.pink,
    'purple': Colors.purple,
    'brown': Color(0xFF8B5E3C),
    'gold': Color(0xFFD4AF37),
    'silver': Color(0xFFC0C0C0),
  };

  static Color swatchFor(String colorName) {
    return namedSwatches[colorName.toLowerCase()] ?? primary;
  }
}
