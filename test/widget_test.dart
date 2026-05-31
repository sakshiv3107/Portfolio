import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/shared/widgets/footer.dart';

void main() {
  testWidgets('Footer rendering smoke test', (WidgetTester tester) async {
    // Build Footer widget inside a MaterialApp and Scaffold to provide text direction and material styling.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Footer(),
        ),
      ),
    );

    // Verify that the copyright and designer details render successfully.
    expect(find.textContaining('Sakshi Vishnoi'), findsOneWidget);
    expect(find.textContaining('Built with Flutter'), findsOneWidget);
    expect(find.textContaining('Dark Precision theme'), findsOneWidget);
  });
}
