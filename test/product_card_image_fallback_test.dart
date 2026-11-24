import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ihan_buy/domain/entities/product.dart';
import 'package:ihan_buy/presentation/widgets/product_card.dart';

void main() {
  testWidgets('ProductCard falls back to an icon when the image fails to load',
      (WidgetTester tester) async {
    const product = Product(
      id: 'broken-image-product',
      name: 'Broken Image Product',
      price: 10,
      rating: 4.5,
      categoryName: 'Test',
      imageUrl: 'https://example.invalid/not-a-real-image.png',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProductCard(product: product, onTap: () {}),
        ),
      ),
    );

    // Let the network image request fail and the errorBuilder run.
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('ProductCard shows the fallback icon when there is no image URL',
      (WidgetTester tester) async {
    const product = Product(
      id: 'no-image-product',
      name: 'No Image Product',
      price: 10,
      rating: 4.5,
      categoryName: 'Test',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProductCard(product: product, onTap: () {}),
        ),
      ),
    );

    expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
