import 'bus_model.dart';
import 'route_model.dart';

enum TripStatus { notStarted, active, paused, completed }

enum TrackingSource { officialDriverGps, passengerAssistedGps, gpsUnavailable }

class TripModel {
  final String id;
  final BusModel bus;
  final RouteModel route;
  final TripStatus status;
  final String scheduledDeparture;
  final String nextStop;
  final int etaMinutes;
  final int delayMinutes;
  final TrackingSource trackingSource;
  final int confidenceScore;
  final double currentLatitude;
  final double currentLongitude;
  final double speedKmh;
  final int passengerContributors;
  final DateTime lastUpdated;

  const TripModel({
    required this.id,
    required this.bus,
    required this.route,
    required this.status,
    required this.scheduledDeparture,
    required this.nextStop,
    required this.etaMinutes,
    this.delayMinutes = 0,
    required this.trackingSource,
    this.confidenceScore = 95,
    required this.currentLatitude,
    required this.currentLongitude,
    this.speedKmh = 42.0,
    this.passengerContributors = 0,
    required this.lastUpdated,
  });

  bool get isLive => status == TripStatus.active && trackingSource != TrackingSource.gpsUnavailable;
  bool get isDelayed => delayMinutes > 5;
  String get etaDisplay => etaMinutes <= 1 ? 'Arriving now' : '$etaMinutes mins';
}
