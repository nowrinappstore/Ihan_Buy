// lib/data/service/slide_service.dart
import '../../core/app_strings.dart';
import '../../domain/entities/slide.dart';
import '../model/slide_model.dart';

/// Local-only promotional banner content; there is no slides backend.
class SlideService {
  List<Slide> getSlides() {
    return const [
      SlideModel(
        id: 'promo-1',
        title: AppStrings.promoBannerText,
        subtitle: AppStrings.buyNow,
      ),
    ].map((m) => m.toEntity()).toList();
  }
}
