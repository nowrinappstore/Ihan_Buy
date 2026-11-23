import 'package:flutter/material.dart';
import '../../core/di/injector.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/product.dart';
import '../widgets/app_logo.dart';
import '../widgets/category_card.dart';
import '../widgets/product_card.dart';
import 'category_products_screen.dart';
import 'login_screen.dart';
import 'product_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await authController.logout();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
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
                    child: const Text('Retry'),
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
                  hintText: 'Search',
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
                            'Happy New Year\nSpecial Deal\nSave 30%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                              minimumSize: const Size(100, 36),
                            ),
                            onPressed: () {},
                            child: const Text('Buy Now'),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.directions_run, size: 80, color: Colors.white),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _SectionHeader(
                title: 'All Categories',
                onSeeAll: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CategoryProductsScreen(category: null)),
                ),
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
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => CategoryProductsScreen(category: c)),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              _ProductSection(title: 'Popular', products: products.take(4).toList()),
              const SizedBox(height: 24),
              _ProductSection(title: 'Special', products: products.skip(3).take(4).toList()),
              const SizedBox(height: 24),
              _ProductSection(title: 'New', products: products.skip(6).take(4).toList()),
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
          child: const Text('See All', style: TextStyle(color: AppColors.primary)),
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
          onSeeAll: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CategoryProductsScreen(category: null)),
          ),
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
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
