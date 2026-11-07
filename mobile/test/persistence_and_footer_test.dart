import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kkrtc_bus/core/storage/app_state_storage.dart';
import 'package:kkrtc_bus/features/authentication/login_screen.dart';
import 'package:kkrtc_bus/features/driver/driver_dashboard_screen.dart';
import 'package:kkrtc_bus/shared/models/route_model.dart';
import 'package:kkrtc_bus/shared/models/user_model.dart';
import 'package:kkrtc_bus/shared/widgets/vac_teams_footer.dart';

void main() {
  group('AppStateStorage Unit Tests', () {
    setUp(() {
      AppStateStorage.setMockInitialValues({});
    });

    test('Fresh install safe fallback defaults', () async {
      expect(await AppStateStorage.getRole(), isNull);
      expect(await AppStateStorage.isAuthenticated(), isFalse);
      expect(await AppStateStorage.getPhoneNumber(), isNull);
      expect(await AppStateStorage.getPassengerTabIndex(), 0);
      final pilotForm = await AppStateStorage.getPilotForm();
      expect(pilotForm['routeId'], '');
      expect(pilotForm['busId'], '');
      expect(pilotForm['isConfirmed'], isFalse);
      expect(await AppStateStorage.getPilotActiveTripId(), isNull);
    });

    test('Persists and retrieves selected user role', () async {
      await AppStateStorage.saveRole(UserRole.pilot);
      expect(await AppStateStorage.getRole(), UserRole.pilot);

      await AppStateStorage.saveRole(UserRole.passenger);
      expect(await AppStateStorage.getRole(), UserRole.passenger);
    });

    test('Persists and clears authenticated session securely', () async {
      await AppStateStorage.saveAuthenticatedSession(
        role: UserRole.passenger,
        phoneNumber: '+91 9876543210',
      );
      expect(await AppStateStorage.isAuthenticated(), isTrue);
      expect(await AppStateStorage.getRole(), UserRole.passenger);
      expect(await AppStateStorage.getPhoneNumber(), '+91 9876543210');

      await AppStateStorage.clearSession();
      expect(await AppStateStorage.isAuthenticated(), isFalse);
      expect(await AppStateStorage.getPhoneNumber(), isNull);
    });

    test('Persists and restores passenger tab index', () async {
      await AppStateStorage.savePassengerTabIndex(2);
      expect(await AppStateStorage.getPassengerTabIndex(), 2);
    });

    test('Persists pilot draft form without starting a trip', () async {
      await AppStateStorage.savePilotForm(
        routeId: '101',
        busId: '202',
        isConfirmed: true,
      );
      final draft = await AppStateStorage.getPilotForm();
      expect(draft['routeId'], '101');
      expect(draft['busId'], '202');
      expect(draft['isConfirmed'], isTrue);

      // Verify saving draft did NOT set an active trip
      expect(await AppStateStorage.getPilotActiveTripId(), isNull);
    });

    test('Persists and clears search query drafts', () async {
      await AppStateStorage.saveSearchQuery(
        source: 'Kalaburagi',
        destination: 'Ballari',
      );
      final query = await AppStateStorage.getSearchQuery();
      expect(query['source'], 'Kalaburagi');
      expect(query['destination'], 'Ballari');
    });
  });

  group('Persistent Footer & UI Widget Tests', () {
    testWidgets('VacTeamsFooter renders subtle Powered by VAC Teams text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: VacTeamsFooter())),
      );
      expect(find.byType(VacTeamsFooter), findsOneWidget);
      expect(
        find.textContaining('Powered by', findRichText: true),
        findsOneWidget,
      );
      expect(
        find.textContaining('VAC Teams', findRichText: true),
        findsOneWidget,
      );
    });

    testWidgets(
      'LoginScreen displays Indian flag country code without mojibake',
      (WidgetTester tester) async {
        AppStateStorage.setMockInitialValues({});
        await tester.pumpWidget(
          const MaterialApp(home: LoginScreen(role: UserRole.passenger)),
        );
        await tester.pumpAndSettle();

        // Check clean Indian flag emoji and country code
        expect(find.text('🇮🇳 +91'), findsOneWidget);
        // Ensure corrupted CP1252 characters are completely gone
        expect(find.textContaining('ðŸ', findRichText: true), findsNothing);

        // Verify VAC Teams footer is present
        expect(find.byType(VacTeamsFooter), findsOneWidget);
      },
    );

    testWidgets(
      'DriverDashboardScreen restores draft Route and Bus ID without starting any trip',
      (WidgetTester tester) async {
        AppStateStorage.setMockInitialValues({
          'kkrtc_pilot_route_id': '45',
          'kkrtc_pilot_bus_id': '108',
          'kkrtc_pilot_journey_confirmed': true,
        });

        await tester.pumpWidget(
          const MaterialApp(home: DriverDashboardScreen()),
        );
        await tester.pumpAndSettle();

        // Check AppBar and Header
        expect(find.text('Pilot Journey'), findsOneWidget);
        expect(find.text('Plan your trip'), findsOneWidget);

        // Check that Route ID and Bus ID form fields were restored from storage
        expect(find.text('45'), findsWidgets);
        expect(find.text('108'), findsWidgets);

        // Check that active trip is NOT auto-started
        expect(find.textContaining('Active trip #'), findsNothing);

        // Drag up to reveal bottom footer in ListView
        await tester.drag(find.byType(ListView), const Offset(0, -600));
        await tester.pumpAndSettle();
        expect(find.byType(VacTeamsFooter), findsOneWidget);
      },
    );

    test(
      'RouteModel routeName format contains clean arrow without mojibake',
      () {
        const route = RouteModel(
          id: '1',
          routeNumber: 'KK-12',
          sourceName: 'Kalaburagi',
          destinationName: 'Bengaluru',
          distanceKm: 610,
          estimatedMinutes: 540,
        );
        expect(route.routeName, 'Kalaburagi ↔ Bengaluru');
        expect(route.routeName.contains('â†'), isFalse);
      },
    );
  });
}
