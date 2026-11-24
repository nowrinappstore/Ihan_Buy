// lib/core/app_navigator.dart
import 'package:flutter/material.dart';

import '../domain/entities/category.dart';
import '../domain/entities/product.dart';
import '../presentation/screens/category_products_screen.dart';
import '../presentation/screens/complete_profile_screen.dart';
import '../presentation/screens/create_review_screen.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/main_shell.dart';
import '../presentation/screens/otp_screen.dart';
import '../presentation/screens/product_details_screen.dart';
import '../presentation/screens/reviews_screen.dart';

class AppNavigator {
  AppNavigator._();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String mainShell = '/main';

  static void toLogin(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  static void replaceWithLogin(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  static void replaceWithMainShell(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShell()),
      (route) => false,
    );
  }

  static void toCompleteProfile(
    BuildContext context, {
    required String email,
    required String password,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CompleteProfileScreen(email: email, password: password),
      ),
    );
  }

  static void toOtp(BuildContext context, {required String email}) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => OtpScreen(email: email)));
  }

  static void toMainShell(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MainShell()));
  }

  static void toCategoryProducts(BuildContext context, {Category? category}) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CategoryProductsScreen(category: category)),
    );
  }

  static void toProductDetails(BuildContext context, {required Product product}) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product)),
    );
  }

  static void toReviews(BuildContext context, {required Product product}) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ReviewsScreen(product: product)),
    );
  }

  static void toCreateReview(BuildContext context, {required Product product}) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CreateReviewScreen(product: product)),
    );
  }

  static void pop(BuildContext context) {
    Navigator.of(context).pop();
  }
}
