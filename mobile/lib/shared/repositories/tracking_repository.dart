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

class UnavailableTrackingRepository implements TrackingRepository {
  @override
  Future<TripModel?> getLiveLocation(String tripId) async => null;

  @override
  Future<bool> submitPassengerLocation({
    required String tripId,
    required double latitude,
    required double longitude,
    required double accuracy,
  }) async {
    return false;
  }

  @override
  Future<bool> submitDriverLocation({
    required String tripId,
    required double latitude,
    required double longitude,
    required double speed,
    required double heading,
  }) async {
    return false;
  }
}
