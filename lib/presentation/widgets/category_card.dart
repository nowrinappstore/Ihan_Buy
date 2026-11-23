import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
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

  @override
  Widget build(BuildContext context) {
    final icon = Icon(category.icon, color: category.color);
    final iconContainer = style == CategoryCardStyle.avatar
        ? CircleAvatar(
            radius: 28,
            backgroundColor: category.color.withValues(alpha: 0.12),
            child: icon,
          )
        : Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
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
