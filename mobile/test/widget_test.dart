import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kkrtc_bus/features/authentication/role_selection_screen.dart';

void main() {
  testWidgets('account selection offers only Passenger and Pilot', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: RoleSelectionScreen()));
    expect(find.text('Passenger'), findsOneWidget);
    expect(find.text('Pilot'), findsOneWidget);
    expect(find.text('Driver'), findsNothing);
    expect(find.text('Conductor'), findsNothing);
    expect(find.text('User'), findsNothing);
  });

  testWidgets(
    'pilot selection carries through login and OTP to pilot dashboard',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RoleSelectionScreen()));
      await tester.tap(find.text('Pilot'));
      await tester.pumpAndSettle();
      expect(find.text('Welcome to KKRTC'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField).first, '9876543210');
      await tester.tap(find.text('Send OTP'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 800));
      await tester.pumpAndSettle();
      expect(find.text('Verify OTP'), findsOneWidget);

      final otpFields = find.byType(TextFormField);
      for (var i = 0; i < 6; i++) {
        await tester.enterText(otpFields.at(i), '1');
      }
      await tester.tap(find.text('Confirm & Continue'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 800));
      await tester.pumpAndSettle();
      expect(find.text('Pilot journey'), findsOneWidget);
      expect(find.text('Passenger dashboard'), findsNothing);
    },
  );
}
