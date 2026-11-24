// lib/presentation/widgets/app_logo.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/app_assets.dart';
import '../../core/app_colors.dart';
import '../../core/app_strings.dart';

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, this.size = 28});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          size <= 32 ? AppAssets.logoNav : AppAssets.logo,
          width: size,
          height: size,
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
              TextSpan(text: AppStrings.appLogoPart1),
              TextSpan(text: AppStrings.appLogoPart2, style: TextStyle(color: AppColors.primary)),
            ],
          ),
        ),
      ],
    );
  }
}
