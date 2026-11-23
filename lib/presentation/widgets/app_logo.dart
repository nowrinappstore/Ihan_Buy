import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, this.size = 28});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.3),
            gradient: const LinearGradient(
              colors: [AppColors.accentPink, AppColors.accentOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Icon(Icons.shopping_bag, color: Colors.white, size: size * 0.6),
        ),
        const SizedBox(width: 8),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: size * 0.65,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            children: const [
              TextSpan(text: 'Ihan'),
              TextSpan(text: 'Buy', style: TextStyle(color: AppColors.primary)),
            ],
          ),
        ),
      ],
    );
  }
}