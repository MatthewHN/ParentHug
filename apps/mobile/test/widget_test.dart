import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parenthug/core/widgets/buttons.dart';

void main() {
  testWidgets('PrimaryButton renders label and responds to taps',
      (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(
            label: 'Get help now',
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Get help now'), findsOneWidget);
    await tester.tap(find.text('Get help now'));
    expect(tapped, isTrue);
  });

  testWidgets('PrimaryButton shows a spinner while loading', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PrimaryButton(label: 'Loading', loading: true),
        ),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
