import '../models/bus_model.dart';
import '../models/route_model.dart';
import '../models/stop_model.dart';
import '../models/trip_model.dart';

abstract class BusRepository {
  Future<List<RouteModel>> getPopularRoutes();
  Future<List<StopModel>> getStops();
  Future<List<TripModel>> searchTrips({required String fromStop, required String toStop});
  Future<List<TripModel>> getNearbyBuses();
  Future<TripModel?> getTripById(String tripId);
}

/// Demonstration Repository containing realistic KKRTC routes
/// Highlighting the initial example corridor: Ballari ↔ Gangavathi
class MockBusRepository implements BusRepository {
  static final List<StopModel> _demoStops = [
    const StopModel(
      id: 'stop_blr_01',
      nameEn: 'Ballari Central Bus Stand',
      nameKn: 'ಬಳ್ಳಾರಿ ಕೇಂದ್ರ ಬಸ್ ನಿಲ್ದಾಣ',
      sequence: 1,
      latitude: 15.1394,
      longitude: 76.9214,
      landmark: 'Main City Circle',
    ),
    const StopModel(
      id: 'stop_kdt_02',
      nameEn: 'Kudithini',
      nameKn: 'ಕುಡಿತಿನಿ',
      sequence: 2,
      latitude: 15.1842,
      longitude: 76.7845,
      landmark: 'Industrial Area Junction',
    ),
    const StopModel(
      id: 'stop_trg_03',
      nameEn: 'Toranagallu (Jindal Cross)',
      nameKn: 'ತೋರಣಗಲ್ಲು (ಜಿಂದಾಲ್ ಕ್ರಾಸ್)',
      sequence: 3,
      latitude: 15.2215,
      longitude: 76.6621,
      landmark: 'Jindal Steel Complex Entrance',
    ),
    const StopModel(
      id: 'stop_kmp_04',
      nameEn: 'Kampli',
      nameKn: 'ಕಂಪ್ಲಿ',
      sequence: 4,
      latitude: 15.4052,
      longitude: 76.6083,
      landmark: 'Kampli Old Fort Bridge',
    ),
    const StopModel(
      id: 'stop_ggv_05',
      nameEn: 'Gangavathi KKRTC Bus Stand',
      nameKn: 'ಗಂಗಾವತಿ ಕೆ.ಕೆ.ಆರ್.ಟಿ.ಸಿ ಬಸ್ ನಿಲ್ದಾಣ',
      sequence: 5,
      latitude: 15.4328,
      longitude: 76.5312,
      landmark: 'Near City Clock Tower',
    ),
    const StopModel(
      id: 'stop_hsp_06',
      nameEn: 'Hospet (Hosapete) Central',
      nameKn: 'ಹೊಸಪೇಟೆ ಕೇಂದ್ರ ಬಸ್ ನಿಲ್ದಾಣ',
      sequence: 6,
      latitude: 15.2710,
      longitude: 76.3892,
      landmark: 'Near Railway Station',
    ),
  ];

  static final List<RouteModel> _demoRoutes = [
    RouteModel(
      id: 'route_blr_ggv',
      routeNumber: 'KK-104',
      sourceName: 'Ballari',
      destinationName: 'Gangavathi',
      distanceKm: 68.5,
      estimatedMinutes: 95,
      intermediateStops: _demoStops.sublist(0, 5),
    ),
    const RouteModel(
      id: 'route_blr_hsp',
      routeNumber: 'KK-208',
      sourceName: 'Ballari',
      destinationName: 'Hosapete',
      distanceKm: 62.0,
      estimatedMinutes: 80,
    ),
    const RouteModel(
      id: 'route_ggv_kpl',
      routeNumber: 'KK-315',
      sourceName: 'Gangavathi',
      destinationName: 'Koppal',
      distanceKm: 39.0,
      estimatedMinutes: 55,
    ),
  ];

  static final List<TripModel> _demoTrips = [
    TripModel(
      id: 'trip_blr_ggv_01',
      bus: const BusModel(
        id: 'bus_ka34_f1204',
        registrationNumber: 'KA-34-F-1204',
        depotName: 'Ballari Depot-1',
        serviceType: BusServiceType.sarige,
      ),
      route: _demoRoutes[0],
      status: TripStatus.active,
      scheduledDeparture: '09:15 AM',
      nextStop: 'Toranagallu',
      etaMinutes: 12,
      delayMinutes: 0,
      trackingSource: TrackingSource.officialDriverGps,
      confidenceScore: 98,
      currentLatitude: 15.2010,
      currentLongitude: 76.7110,
      speedKmh: 48.5,
      passengerContributors: 0,
      lastUpdated: DateTime.now().subtract(const Duration(seconds: 15)),
    ),
    TripModel(
      id: 'trip_blr_ggv_02',
      bus: const BusModel(
        id: 'bus_ka34_f1892',
        registrationNumber: 'KA-34-F-1892',
        depotName: 'Gangavathi Depot',
        serviceType: BusServiceType.vaibhava,
      ),
      route: _demoRoutes[0],
      status: TripStatus.active,
      scheduledDeparture: '09:45 AM',
      nextStop: 'Kudithini',
      etaMinutes: 24,
      delayMinutes: 4,
      trackingSource: TrackingSource.passengerAssistedGps,
      confidenceScore: 78,
      currentLatitude: 15.1610,
      currentLongitude: 76.8210,
      speedKmh: 41.2,
      passengerContributors: 3,
      lastUpdated: DateTime.now().subtract(const Duration(seconds: 35)),
    ),
    TripModel(
      id: 'trip_blr_ggv_03',
      bus: const BusModel(
        id: 'bus_ka34_f2100',
        registrationNumber: 'KA-34-F-2100',
        depotName: 'Ballari Depot-2',
        serviceType: BusServiceType.nonStop,
      ),
      route: _demoRoutes[0],
      status: TripStatus.notStarted,
      scheduledDeparture: '10:30 AM',
      nextStop: 'Ballari Central',
      etaMinutes: 65,
      delayMinutes: 0,
      trackingSource: TrackingSource.gpsUnavailable,
      confidenceScore: 30,
      currentLatitude: 15.1394,
      currentLongitude: 76.9214,
      speedKmh: 0.0,
      passengerContributors: 0,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  @override
  Future<List<RouteModel>> getPopularRoutes() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _demoRoutes;
  }

  @override
  Future<List<StopModel>> getStops() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _demoStops;
  }

  @override
  Future<List<TripModel>> searchTrips({
    required String fromStop,
    required String toStop,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _demoTrips;
  }

  @override
  Future<List<TripModel>> getNearbyBuses() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return _demoTrips.where((t) => t.status == TripStatus.active).toList();
  }

  @override
  Future<TripModel?> getTripById(String tripId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _demoTrips.firstWhere((t) => t.id == tripId);
    } catch (_) {
      return _demoTrips.first;
    }
  }
}
