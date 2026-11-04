import '../models/route_model.dart';
import '../models/stop_model.dart';
import '../models/trip_model.dart';

/// Empty data source until the corresponding passenger endpoints are deployed.
/// It intentionally returns no simulated trips, coordinates, or telemetry.
class UnavailableBusRepository {
  Future<List<RouteModel>> getPopularRoutes() async => const [];

  Future<List<StopModel>> getStops() async => const [];

  Future<List<TripModel>> searchTrips({
    required String fromStop,
    required String toStop,
  }) async => const [];

  Future<List<TripModel>> getNearbyBuses() async => const [];

  Future<TripModel?> getTripById(String tripId) async => null;
}
