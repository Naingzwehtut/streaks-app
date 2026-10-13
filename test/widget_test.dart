import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaks/main.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('shows empty state, then adds and checks off a habit',
      (tester) async {
    await tester.pumpWidget(const StreaksApp());
    await tester.pumpAndSettle();

    expect(find.text('No habits yet'), findsOneWidget);

    await tester.tap(find.text('New habit'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Drink water');
    await tester.pump();
    await tester.tap(find.text('Create habit'));
    await tester.pumpAndSettle();

    expect(find.text('Drink water'), findsOneWidget);
    expect(find.text('0 of 1 done today'), findsOneWidget);
  });
}
