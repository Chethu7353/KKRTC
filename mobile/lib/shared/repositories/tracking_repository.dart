import '../models/trip_model.dart';

abstract class TrackingRepository {
  Future<TripModel?> getLiveLocation(String tripId);
  Future<bool> submitPassengerLocation({
    required String tripId,
    required double latitude,
    required double longitude,
    required double accuracy,
  });
  Future<bool> submitDriverLocation({
    required String tripId,
    required double latitude,
    required double longitude,
    required double speed,
    required double heading,
  });
}

class MockTrackingRepository implements TrackingRepository {
  bool _passengerLocationSharingActive = false;

  bool get isPassengerSharingActive => _passengerLocationSharingActive;

  void togglePassengerSharing(bool active) {
    _passengerLocationSharingActive = active;
  }

  @override
  Future<TripModel?> getLiveLocation(String tripId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return null;
  }

  @override
  Future<bool> submitPassengerLocation({
    required String tripId,
    required double latitude,
    required double longitude,
    required double accuracy,
  }) async {
    // Demonstration simulated submission
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  @override
  Future<bool> submitDriverLocation({
    required String tripId,
    required double latitude,
    required double longitude,
    required double speed,
    required double heading,
  }) async {
    // Demonstration simulated driver telemetry submission
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
}
