// lib/presentation/screens/main_shell.dart
import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_strings.dart';
import '../state/app_controllers.dart';
import 'cart_screen.dart';
import 'categories_screen.dart';
import 'home_screen.dart';
import 'wishlist_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final _screens = const [
    HomeScreen(),
    CategoriesScreen(),
    CartScreen(),
    WishlistScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: AnimatedBuilder(
        animation: cartController,
        builder: (context, _) {
          return BottomNavigationBar(
            currentIndex: _index,
            onTap: (i) => setState(() => _index = i),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textSecondary,
            showUnselectedLabels: true,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: AppStrings.navHome,
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.grid_view_outlined),
                label: AppStrings.navCategories,
              ),
              BottomNavigationBarItem(
                icon: Badge(
                  label: Text('${cartController.cartCount}'),
                  isLabelVisible: cartController.cartCount > 0,
                  child: const Icon(Icons.shopping_basket_outlined),
                ),
                label: AppStrings.navCart,
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.card_giftcard_outlined),
                label: AppStrings.navWish,
              ),
            ],
          );
        },
      ),
    );
  }
}
