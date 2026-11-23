import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const Category({
    this.id = '',
    required this.name,
    required this.icon,
    required this.color,
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

  static const List<Color> _fallbackColors = [
    Color(0xFF5B8DEF),
    Color(0xFFFF7A3D),
    Color(0xFF2ECC71),
    Color(0xFF0FA3A3),
    Color(0xFFE85C8A),
  ];

  factory Category.fromJson(Map<String, dynamic> json, {int index = 0}) {
    return Category(
      id: json['_id']?.toString() ?? '',
      name: json['title']?.toString() ?? 'Category',
      icon: _fallbackIcons[index % _fallbackIcons.length],
      color: _fallbackColors[index % _fallbackColors.length],
    );
  }
}
