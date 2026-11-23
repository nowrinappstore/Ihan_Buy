import 'package:flutter/material.dart';
import '../../core/di/injector.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/product.dart';
import 'reviews_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late Color _selectedColor =
      widget.product.colorOptions.isNotEmpty ? widget.product.colorOptions.first : AppColors.primary;
  int _selectedSizeIndex = 1;
  int _quantity = 1;

  String get _selectedSize =>
      widget.product.sizeOptions.isNotEmpty
          ? widget.product.sizeOptions[_selectedSizeIndex.clamp(0, widget.product.sizeOptions.length - 1)]
          : '';

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: ListView(
        children: [
          Container(
            height: 240,
            width: double.infinity,
            color: product.color.withValues(alpha: 0.08),
            child: product.imageUrl != null
                ? Image.network(
                    product.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Center(
                      child: Icon(product.icon, size: 120, color: product.color),
                    ),
                  )
                : Center(
                    child: Icon(product.icon, size: 120, color: product.color),
                  ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(4, (i) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i == 0 ? AppColors.primary : AppColors.border,
                  ),
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    _QuantityStepper(
                      quantity: _quantity,
                      onChanged: (q) => setState(() => _quantity = q),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.star, size: 18),
                    const SizedBox(width: 4),
                    Text('${product.rating}'),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => ReviewsScreen(product: product)),
                      ),
                      child: const Text('Reviews', style: TextStyle(color: AppColors.primary)),
                    ),
                    const Spacer(),
                    AnimatedBuilder(
                      animation: cartController,
                      builder: (context, _) {
                        final liked = cartController.isWishlisted(product.id);
                        return GestureDetector(
                          onTap: () => cartController.toggleWishlist(product.id),
                          child: Icon(
                            liked ? Icons.favorite : Icons.favorite_border,
                            color: liked ? AppColors.accentPink : AppColors.textSecondary,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Color', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Row(
                  children: product.colorOptions.map((c) {
                    final selected = c == _selectedColor;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColor = c),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected ? AppColors.primary : AppColors.border,
                            width: selected ? 2 : 1,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                const Text('Size', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Row(
                  children: product.sizeOptions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final size = entry.value;
                    final selected = index == _selectedSizeIndex;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedSizeIndex = index),
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 40,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selected ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selected ? AppColors.primary : AppColors.border,
                          ),
                        ),
                        child: Text(
                          size,
                          style: TextStyle(color: selected ? Colors.white : AppColors.textPrimary),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                const Text('Description', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text(product.description, style: const TextStyle(color: AppColors.textSecondary, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Row(
            children: [
              Text(
                '\$${product.price.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              SizedBox(
                width: 180,
                child: AnimatedBuilder(
                  animation: cartController,
                  builder: (context, _) {
                    return ElevatedButton(
                      onPressed: cartController.isLoading
                          ? null
                          : () async {
                              final added = await cartController.addToCart(
                                product,
                                color: _selectedColor,
                                size: _selectedSize,
                                quantity: _quantity,
                              );
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(added ? 'Added to cart' : cartController.errorMessage!),
                                ),
                              );
                            },
                      child: cartController.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Add To Cart'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;

  const _QuantityStepper({required this.quantity, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            iconSize: 16,
            visualDensity: VisualDensity.compact,
            onPressed: () => onChanged((quantity - 1).clamp(1, 99)),
            icon: const Icon(Icons.remove),
          ),
          Text(quantity.toString().padLeft(2, '0')),
          IconButton(
            iconSize: 16,
            visualDensity: VisualDensity.compact,
            onPressed: () => onChanged((quantity + 1).clamp(1, 99)),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}