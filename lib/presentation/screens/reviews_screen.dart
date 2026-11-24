// lib/presentation/screens/reviews_screen.dart
import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_navigator.dart';
import '../../core/app_strings.dart';
import '../../domain/entities/product.dart';
import '../state/app_controllers.dart';

class ReviewsScreen extends StatelessWidget {
  final Product product;

  const ReviewsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.reviewsTitle)),
      body: AnimatedBuilder(
        animation: reviewsController,
        builder: (context, _) {
          final reviews = reviewsController.reviewsFor(product.id);
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: reviews.length,
                  separatorBuilder: (_, _) => const Divider(height: 28),
                  itemBuilder: (context, i) {
                    final review = reviews[i];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          backgroundColor: AppColors.border,
                          child: Icon(Icons.person, color: AppColors.textSecondary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(review.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(review.text, style: const TextStyle(color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.reviewsCount(reviews.length),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    FloatingActionButton.small(
                      onPressed: () => AppNavigator.toCreateReview(context, product: product),
                      backgroundColor: AppColors.primary,
                      child: const Icon(Icons.add, color: AppColors.white),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
