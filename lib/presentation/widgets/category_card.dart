// lib/presentation/widgets/category_card.dart
import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../domain/entities/category.dart';

enum CategoryCardStyle { avatar, tile }

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;
  final CategoryCardStyle style;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
    this.style = CategoryCardStyle.tile,
  });

  static const List<IconData> _fallbackIcons = [
    Icons.category_outlined,
    Icons.tv,
    Icons.ramen_dining,
    Icons.diamond_outlined,
    Icons.bed_outlined,
    Icons.checkroom_outlined,
    Icons.sports_basketball_outlined,
    Icons.watch_outlined,
  ];

  IconData get _icon => _fallbackIcons[category.iconIndex % _fallbackIcons.length];

  Color get _color => AppColors.categoryFallbackColors[
      category.iconIndex % AppColors.categoryFallbackColors.length];

  @override
  Widget build(BuildContext context) {
    final icon = Icon(_icon, color: _color);
    final iconContainer = style == CategoryCardStyle.avatar
        ? CircleAvatar(
            radius: 28,
            backgroundColor: _color.withValues(alpha: 0.12),
            child: icon,
          )
        : Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: icon,
          );

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconContainer,
          const SizedBox(height: 8),
          Text(
            category.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, height: 1.1),
          ),
        ],
      ),
    );
  }
}
