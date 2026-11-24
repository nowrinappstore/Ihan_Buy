import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ihan_buy/domain/entities/product.dart';
import 'package:ihan_buy/presentation/screens/product_details_screen.dart';

Future<void> openProductDetails(WidgetTester tester, Product product) async {
  // Fully tear down the previous screen first, so its Navigator (and route
  // stack) doesn't survive into the next pumpWidget via element reuse.
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pumpWidget(
    MaterialApp(home: ProductDetailsScreen(product: product)),
  );
}

const _productA = Product(
  id: 'review-flow-test-a',
  name: 'Test Product A',
  price: 10,
  rating: 4.5,
  categoryName: 'Test',
);

const _productB = Product(
  id: 'review-flow-test-b',
  name: 'Test Product B',
  price: 20,
  rating: 4.0,
  categoryName: 'Test',
);

void main() {
  testWidgets('reviews are scoped per product end to end', (WidgetTester tester) async {
    // 1. Grid -> product detail -> Reviews starts empty for a fresh product.
    await openProductDetails(tester, _productA);
    await tester.tap(find.text('Reviews'));
    await tester.pumpAndSettle();

    expect(find.text('Reviews (0)'), findsOneWidget);

    // 2. Reviews -> create review -> submit -> new review appears for *this* product.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'First Name'), 'Ada');
    await tester.enterText(find.widgetWithText(TextField, 'Last Name'), 'Lovelace');
    await tester.enterText(find.widgetWithText(TextField, 'Write Review'), 'Exactly as described.');
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(find.text('Reviews (1)'), findsOneWidget);
    expect(find.text('Ada Lovelace'), findsOneWidget);
    expect(find.text('Exactly as described.'), findsOneWidget);

    // 3. A different product's reviews are unaffected by the above.
    await openProductDetails(tester, _productB);
    await tester.tap(find.text('Reviews'));
    await tester.pumpAndSettle();

    expect(find.text('Reviews (0)'), findsOneWidget);
    expect(find.text('Ada Lovelace'), findsNothing);

    // 4. Writing a review here attaches it to *this* product only.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'First Name'), 'Grace');
    await tester.enterText(find.widgetWithText(TextField, 'Last Name'), 'Hopper');
    await tester.enterText(find.widgetWithText(TextField, 'Write Review'), 'Solid build quality.');
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(find.text('Reviews (1)'), findsOneWidget);
    expect(find.text('Grace Hopper'), findsOneWidget);

    // 5. Back on the first product, its review count is still 1 — not 2.
    await openProductDetails(tester, _productA);
    await tester.tap(find.text('Reviews'));
    await tester.pumpAndSettle();

    expect(find.text('Reviews (1)'), findsOneWidget);
    expect(find.text('Grace Hopper'), findsNothing);
  });
}
