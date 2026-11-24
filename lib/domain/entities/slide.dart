// lib/domain/entities/slide.dart
/// Local-only promotional banner content. There is no slides backend
/// endpoint; `slide_service.dart` returns a fixed local list of these.
class Slide {
  final String id;
  final String title;
  final String subtitle;

  const Slide({required this.id, required this.title, required this.subtitle});
}
