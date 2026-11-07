import 'stop_model.dart';

class RouteModel {
  final String id;
  final String routeNumber;
  final String sourceName;
  final String destinationName;
  final double distanceKm;
  final int estimatedMinutes;
  final List<StopModel> intermediateStops;

  const RouteModel({
    required this.id,
    required this.routeNumber,
    required this.sourceName,
    required this.destinationName,
    required this.distanceKm,
    required this.estimatedMinutes,
    this.intermediateStops = const [],
  });

  String get routeName => '$sourceName ↔ $destinationName';
  String get durationFormatted =>
      '${(estimatedMinutes / 60).floor()}h ${estimatedMinutes % 60}m';
}
