import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/models/user_model.dart';

/// Central persistent state storage using SharedPreferences.
/// Preserves non-sensitive navigation context, incomplete forms, and user sessions
/// across application restarts without storing credentials or passwords.
class AppStateStorage {
  static const String _keyUserRole = 'kkrtc_user_role';
  static const String _keyIsAuthenticated = 'kkrtc_is_authenticated';
  static const String _keyPhoneNumber = 'kkrtc_phone_number';
  static const String _keyPassengerTabIndex = 'kkrtc_passenger_tab_index';
  static const String _keyPilotRouteId = 'kkrtc_pilot_route_id';
  static const String _keyPilotBusId = 'kkrtc_pilot_bus_id';
  static const String _keyPilotJourneyConfirmed =
      'kkrtc_pilot_journey_confirmed';
  static const String _keyPilotActiveTripId = 'kkrtc_pilot_active_trip_id';
  static const String _keySearchSource = 'kkrtc_search_source';
  static const String _keySearchDestination = 'kkrtc_search_destination';

  static SharedPreferences? _prefs;

  /// Internal getter ensuring preferences instance is initialized.
  static Future<SharedPreferences> get _instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Inject or override prefs for testing.
  @visibleForTesting
  static void setMockInitialValues(Map<String, Object> values) {
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues(values);
    _prefs = null;
  }

  // ================= ROLE & AUTHENTICATION =================

  /// Persists the selected user role (Passenger or Pilot).
  static Future<void> saveRole(UserRole role) async {
    final prefs = await _instance;
    await prefs.setString(_keyUserRole, role.name);
  }

  /// Retrieves the saved user role if set.
  static Future<UserRole?> getRole() async {
    final prefs = await _instance;
    final value = prefs.getString(_keyUserRole);
    if (value == null) return null;
    return value == UserRole.pilot.name ? UserRole.pilot : UserRole.passenger;
  }

  /// Saves the authenticated state and associated phone number.
  /// Does NOT store OTPs, passwords, or sensitive auth tokens in plain text.
  static Future<void> saveAuthenticatedSession({
    required UserRole role,
    required String phoneNumber,
  }) async {
    final prefs = await _instance;
    await Future.wait([
      prefs.setString(_keyUserRole, role.name),
      prefs.setBool(_keyIsAuthenticated, true),
      prefs.setString(_keyPhoneNumber, phoneNumber),
    ]);
  }

  /// Checks whether a valid session was previously established.
  static Future<bool> isAuthenticated() async {
    final prefs = await _instance;
    return prefs.getBool(_keyIsAuthenticated) ?? false;
  }

  /// Retrieves the stored phone number (masked display purpose).
  static Future<String?> getPhoneNumber() async {
    final prefs = await _instance;
    return prefs.getString(_keyPhoneNumber);
  }

  // ================= NAVIGATION CONTEXT =================

  /// Saves the current tab index inside [PassengerMainScreen].
  static Future<void> savePassengerTabIndex(int index) async {
    final prefs = await _instance;
    await prefs.setInt(_keyPassengerTabIndex, index);
  }

  /// Retrieves the last visited passenger tab index (defaults to 0: Home).
  static Future<int> getPassengerTabIndex() async {
    final prefs = await _instance;
    return prefs.getInt(_keyPassengerTabIndex) ?? 0;
  }

  // ================= PILOT TRIP FORM PERSISTENCE =================

  /// Persists pilot draft inputs (Route ID, Bus ID, and confirmation state).
  /// Note: Saving draft inputs does NOT start or imply an active running trip.
  static Future<void> savePilotForm({
    required String routeId,
    required String busId,
    required bool isConfirmed,
  }) async {
    final prefs = await _instance;
    await Future.wait([
      prefs.setString(_keyPilotRouteId, routeId),
      prefs.setString(_keyPilotBusId, busId),
      prefs.setBool(_keyPilotJourneyConfirmed, isConfirmed),
    ]);
  }

  /// Retrieves draft inputs previously entered by the pilot.
  static Future<Map<String, dynamic>> getPilotForm() async {
    final prefs = await _instance;
    return {
      'routeId': prefs.getString(_keyPilotRouteId) ?? '',
      'busId': prefs.getString(_keyPilotBusId) ?? '',
      'isConfirmed': prefs.getBool(_keyPilotJourneyConfirmed) ?? false,
    };
  }

  /// Persists the active trip ID only when verified with the backend.
  static Future<void> savePilotActiveTripId(int? tripId) async {
    final prefs = await _instance;
    if (tripId == null) {
      await prefs.remove(_keyPilotActiveTripId);
    } else {
      await prefs.setInt(_keyPilotActiveTripId, tripId);
    }
  }

  /// Retrieves the previously recorded active trip ID (subject to backend validation).
  static Future<int?> getPilotActiveTripId() async {
    final prefs = await _instance;
    return prefs.getInt(_keyPilotActiveTripId);
  }

  // ================= PASSENGER SEARCH PERSISTENCE =================

  /// Persists recent search source and destination drafts.
  static Future<void> saveSearchQuery({
    String? source,
    String? destination,
  }) async {
    final prefs = await _instance;
    if (source != null) await prefs.setString(_keySearchSource, source);
    if (destination != null) {
      await prefs.setString(_keySearchDestination, destination);
    }
  }

  /// Retrieves recent draft search terms.
  static Future<Map<String, String>> getSearchQuery() async {
    final prefs = await _instance;
    return {
      'source': prefs.getString(_keySearchSource) ?? '',
      'destination': prefs.getString(_keySearchDestination) ?? '',
    };
  }

  // ================= SESSION CLEANUP =================

  /// Logs the user out by clearing session authentication, active trip,
  /// and draft state while safely allowing a fresh login.
  static Future<void> clearSession() async {
    final prefs = await _instance;
    await Future.wait([
      prefs.remove(_keyIsAuthenticated),
      prefs.remove(_keyPhoneNumber),
      prefs.remove(_keyPassengerTabIndex),
      prefs.remove(_keyPilotActiveTripId),
      prefs.remove(_keyPilotJourneyConfirmed),
    ]);
  }

  /// Complete reset for test isolation or full app data wipe.
  static Future<void> clearAll() async {
    final prefs = await _instance;
    await prefs.clear();
  }
}
