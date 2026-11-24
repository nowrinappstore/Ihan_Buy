// lib/data/model/slide_model.dart
import '../../domain/entities/slide.dart';

/// Local-only promotional banner content; there is no slides backend.
class SlideModel {
  final String id;
  final String title;
  final String subtitle;

  const SlideModel({required this.id, required this.title, required this.subtitle});

  Slide toEntity() => Slide(id: id, title: title, subtitle: subtitle);
}
