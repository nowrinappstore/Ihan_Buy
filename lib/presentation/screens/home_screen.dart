// lib/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_navigator.dart';
import '../../core/app_strings.dart';
import '../../domain/entities/product.dart';
import '../state/app_controllers.dart';
import '../widgets/app_logo.dart';
import '../widgets/category_card.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.logOut),
        content: const Text(AppStrings.logOutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(AppStrings.logOut),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await authController.logout();
    if (!context.mounted) return;
    AppNavigator.replaceWithLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppLogo(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () => _handleLogout(context),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.call_outlined),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: productsController,
        builder: (context, _) {
          if (productsController.isLoading && productsController.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (productsController.errorMessage != null && productsController.products.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(productsController.errorMessage!, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: productsController.load,
                    child: const Text(AppStrings.retry),
                  ),
                ],
              ),
            );
          }

          final categories = productsController.categories;
          final products = productsController.products;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              const TextField(
                decoration: InputDecoration(
                  hintText: AppStrings.search,
                  prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            AppStrings.promoBannerText,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.white,
                              foregroundColor: AppColors.primary,
                              minimumSize: const Size(100, 36),
                            ),
                            onPressed: () {},
                            child: const Text(AppStrings.buyNow),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.directions_run, size: 80, color: AppColors.white),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _SectionHeader(
                title: AppStrings.allCategories,
                onSeeAll: () => AppNavigator.toCategoryProducts(context),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 92,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 16),
                  itemBuilder: (context, i) {
                    final c = categories[i];
                    return CategoryCard(
                      category: c,
                      style: CategoryCardStyle.avatar,
                      onTap: () => AppNavigator.toCategoryProducts(context, category: c),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              _ProductSection(title: AppStrings.popularSection, products: products.take(4).toList()),
              const SizedBox(height: 24),
              _ProductSection(
                title: AppStrings.specialSection,
                products: products.skip(3).take(4).toList(),
              ),
              const SizedBox(height: 24),
              _ProductSection(title: AppStrings.newSection, products: products.skip(6).take(4).toList()),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: onSeeAll,
          child: const Text(AppStrings.seeAll, style: TextStyle(color: AppColors.primary)),
        ),
      ],
    );
  }
}

class _ProductSection extends StatelessWidget {
  final String title;
  final List<Product> products;

  const _ProductSection({required this.title, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: title,
          onSeeAll: () => AppNavigator.toCategoryProducts(context),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final product = products[i];
              return ProductCard(
                product: product,
                onTap: () => AppNavigator.toProductDetails(context, product: product),
              );
            },
          ),
        ),
      ],
    );
  }
}
