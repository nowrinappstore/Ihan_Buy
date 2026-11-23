import 'package:flutter/material.dart';
import '../../core/di/injector.dart';
import '../../domain/entities/product.dart';

class CreateReviewScreen extends StatefulWidget {
  final Product product;

  const CreateReviewScreen({super.key, required this.product});

  @override
  State<CreateReviewScreen> createState() => _CreateReviewScreenState();
}

class _CreateReviewScreenState extends State<CreateReviewScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _reviewController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final text = _reviewController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty || text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in your name and review')),
      );
      return;
    }

    reviewsController.addReview(
      productId: widget.product.id,
      name: '$firstName $lastName',
      text: text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Review submitted')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Review')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(hintText: 'First Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(hintText: 'Last Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _reviewController,
              maxLines: 6,
              decoration: const InputDecoration(hintText: 'Write Review'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _handleSubmit,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}