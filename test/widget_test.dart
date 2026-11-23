import 'package:flutter_test/flutter_test.dart';

import 'package:ihan_buy/main.dart';

void main() {
  testWidgets('App shows splash screen with IhanBuy branding', (WidgetTester tester) async {
    await tester.pumpWidget(const IhanBuyApp());

    // The logo renders "Ihan" + "Buy" as sibling TextSpans in one RichText,
    // so it must be matched as the combined plain text, not two Text widgets.
    expect(find.text('IhanBuy', findRichText: true), findsOneWidget);

    // Splash schedules a Future.delayed(2s) navigation; let it fire so no
    // Timer is left pending when the test tears down the widget tree.
    await tester.pump(const Duration(seconds: 2));
  });
}