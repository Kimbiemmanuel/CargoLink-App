import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cargolink_app/main.dart';

void main() {
  testWidgets('CargoLink app renders login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: CargoLinkApp()));
    await tester.pumpAndSettle();
    expect(find.text('CargoLink'), findsOneWidget);
  });
}
