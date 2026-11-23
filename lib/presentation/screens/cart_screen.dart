import 'package:flutter/material.dart';
import '../../core/di/injector.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/product.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: AnimatedBuilder(
        animation: cartController,
        builder: (context, _) {
          final cart = cartController.cart;
          if (cart.isEmpty) {
            return const Center(
              child: Text('Your cart is empty', style: TextStyle(color: AppColors.textSecondary)),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, i) {
                    final item = cart[i];
                    return Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: item.product.color.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(item.product.icon, color: item.product.color),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.product.name,
                                  style: const TextStyle(fontWeight: FontWeight.w600)),
                              Text(
                                'Color: ${_colorName(item.color)}, Size: ${item.size}',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 4),
                              Text('\$${item.product.price.toStringAsFixed(0)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () => cartController.removeFromCart(item),
                              icon: const Icon(Icons.delete_outline, color: AppColors.textSecondary),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  iconSize: 16,
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () => cartController.updateQuantity(item, -1),
                                  icon: const Icon(Icons.remove_circle_outline),
                                ),
                                Text(item.quantity.toString().padLeft(2, '0')),
                                IconButton(
                                  iconSize: 16,
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () => cartController.updateQuantity(item, 1),
                                  icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total Price', style: TextStyle(color: AppColors.textSecondary)),
                            Text(
                              '\$${cartController.cartTotal.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 160,
                        child: ElevatedButton(
                          onPressed: cartController.isLoading
                              ? null
                              : () async {
                                  final shippingAddress = await showDialog<Map<String, dynamic>>(
                                    context: context,
                                    builder: (_) => const _ShippingAddressDialog(),
                                  );
                                  if (shippingAddress == null) return;
                                  if (!context.mounted) return;

                                  final placed = await cartController.checkout(
                                    shippingAddress: shippingAddress,
                                  );
                                  if (!context.mounted) return;
                                  if (placed) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Order placed successfully')),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(cartController.errorMessage!)),
                                    );
                                  }
                                },
                          child: cartController.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Text('Checkout'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _colorName(Color color) {
    final name = Product.colorName(color);
    if (name == null) return 'N/A';
    return name[0].toUpperCase() + name.substring(1);
  }
}

class _ShippingAddressDialog extends StatefulWidget {
  const _ShippingAddressDialog();

  @override
  State<_ShippingAddressDialog> createState() => _ShippingAddressDialogState();
}

class _ShippingAddressDialogState extends State<_ShippingAddressDialog> {
  late final _fullNameController = TextEditingController(
    text: [authController.currentUser?.firstName, authController.currentUser?.lastName]
        .where((s) => s != null && s.isNotEmpty)
        .join(' '),
  );
  late final _phoneController =
      TextEditingController(text: authController.currentUser?.phone ?? '');
  late final _addressController =
      TextEditingController(text: authController.currentUser?.address ?? '');
  late final _cityController =
      TextEditingController(text: authController.currentUser?.city ?? '');
  final _postalCodeController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_fullNameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _addressController.text.trim().isEmpty ||
        _cityController.text.trim().isEmpty ||
        _postalCodeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all shipping details')),
      );
      return;
    }

    Navigator.of(context).pop({
      'full_name': _fullNameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'address': _addressController.text.trim(),
      'city': _cityController.text.trim(),
      'postal_code': _postalCodeController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Shipping Details'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _fullNameController,
              decoration: const InputDecoration(hintText: 'Full Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(hintText: 'Phone'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _addressController,
              maxLines: 2,
              decoration: const InputDecoration(hintText: 'Address'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(hintText: 'City'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _postalCodeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Postal Code'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _submit,
          child: const Text('Place Order (COD)'),
        ),
      ],
    );
  }
}