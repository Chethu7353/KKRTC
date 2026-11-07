import 'bus_model.dart';
import 'route_model.dart';
import 'stop_model.dart';

enum TripStatus { notStarted, scheduled, active, inProgress, paused, completed }

enum TrackingSource {
  officialDriverGps,
  passengerAssisted,
  passengerAssistedGps,
  gpsUnavailable,
}

class TripModel {
  final String id;
  final BusModel bus;
  final RouteModel route;
  final TripStatus status;
  final String scheduledDeparture;
  final String nextStop;
  final StopModel? nextStopModel;
  final int? etaMinutes;
  final int? delayMinutes;
  final TrackingSource trackingSource;
  final int? confidenceScore;
  final double? currentLatitude;
  final double? currentLongitude;
  final double? speedKmh;
  final int? passengerContributors;
  final int? passengerReportsCount;
  final DateTime lastUpdated;
  final double? distanceRemainingKm;

  const TripModel({
    required this.id,
    required this.bus,
    required this.route,
    required this.status,
    required this.scheduledDeparture,
    required this.nextStop,
    this.nextStopModel,
    this.etaMinutes,
    this.delayMinutes,
    required this.trackingSource,
    this.confidenceScore,
    this.currentLatitude,
    this.currentLongitude,
    this.speedKmh,
    this.passengerContributors,
    this.passengerReportsCount,
    required this.lastUpdated,
    this.distanceRemainingKm,
  });

  // ── Convenience accessors used by screens ──────────────────────
  /// Alias for [trackingSource] – used by live_tracking_screen and badge widgets.
  TrackingSource get source => trackingSource;

  /// Speed in km/h – alias to match screens that use `currentSpeedKmph`.
  double? get currentSpeedKmph => speedKmh;

  /// Display name of the next stop (from nextStopModel if available, else nextStop).
  String get nextStopName => nextStopModel?.nameEn ?? nextStop;

  /// Kannada name of the next stop, if a StopModel is provided.
  String? get nextStopNameKn => nextStopModel?.nameKn;

  bool get isLive =>
      (status == TripStatus.active || status == TripStatus.inProgress) &&
      trackingSource != TrackingSource.gpsUnavailable;

  bool get isDelayed => delayMinutes != null && delayMinutes! > 5;

  String get etaDisplay => etaMinutes == null
      ? 'ETA unavailable'
      : etaMinutes! <= 1
      ? 'Arriving now'
      : '$etaMinutes mins';

  TripModel copyWith({
    String? id,
    BusModel? bus,
    RouteModel? route,
    TripStatus? status,
    String? scheduledDeparture,
    String? nextStop,
    StopModel? nextStopModel,
    int? etaMinutes,
    int? delayMinutes,
    TrackingSource? source,
    int? confidenceScore,
    double? currentLatitude,
    double? currentLongitude,
    double? speedKmh,
    int? passengerContributors,
    int? passengerReportsCount,
    DateTime? lastUpdated,
    double? distanceRemainingKm,
  }) {
    return TripModel(
      id: id ?? this.id,
      bus: bus ?? this.bus,
      route: route ?? this.route,
      status: status ?? this.status,
      scheduledDeparture: scheduledDeparture ?? this.scheduledDeparture,
      nextStop: nextStop ?? this.nextStop,
      nextStopModel: nextStopModel ?? this.nextStopModel,
      etaMinutes: etaMinutes ?? this.etaMinutes,
      delayMinutes: delayMinutes ?? this.delayMinutes,
      trackingSource: source ?? trackingSource,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      currentLatitude: currentLatitude ?? this.currentLatitude,
      currentLongitude: currentLongitude ?? this.currentLongitude,
      speedKmh: speedKmh ?? this.speedKmh,
      passengerContributors:
          passengerContributors ?? this.passengerContributors,
      passengerReportsCount:
          passengerReportsCount ?? this.passengerReportsCount,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      distanceRemainingKm: distanceRemainingKm ?? this.distanceRemainingKm,
    );
  }
}
