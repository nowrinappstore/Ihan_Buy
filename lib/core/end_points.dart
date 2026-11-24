// lib/core/end_points.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EndPoints {
  EndPoints._();

  static String get baseUrl => dotenv.env['BASE_URL']!;

  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';

  static const String products = '/products';
  static const String categories = '/categories';
  static const String cart = '/cart';
  static String cartItem(String id) => '/cart/$id';
  static const String order = '/order';
}
