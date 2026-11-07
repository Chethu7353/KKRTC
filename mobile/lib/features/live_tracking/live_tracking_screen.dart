import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../core/constants/app_colors.dart';
import '../../shared/models/trip_model.dart';
import '../../shared/widgets/osm_map_panel.dart';
import '../../shared/widgets/status_badge.dart';
import '../../shared/widgets/vac_teams_footer.dart';
import 'passenger_assisted_tracking_sheet.dart';

class LiveTrackingScreen extends StatelessWidget {
  const LiveTrackingScreen({super.key, this.trip});

  final TripModel? trip;

  @override
  Widget build(BuildContext context) {
    final currentTrip = trip;
    final hasBusPosition =
        currentTrip?.currentLatitude != null &&
        currentTrip?.currentLongitude != null;
    final routeStops = currentTrip?.route.intermediateStops ?? const [];
    final routeCoordinates = routeStops
        .map((stop) => LatLng(stop.latitude, stop.longitude))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(currentTrip?.bus.registrationNumber ?? 'Live tracking'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(
            height: 420,
            child: OsmMapPanel(
              busLocation: hasBusPosition
                  ? LatLng(
                      currentTrip!.currentLatitude!,
                      currentTrip.currentLongitude!,
                    )
                  : null,
              origin: routeCoordinates.isEmpty ? null : routeCoordinates.first,
              destination: routeCoordinates.length < 2
                  ? null
                  : routeCoordinates.last,
              routeCoordinates: routeCoordinates,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (currentTrip == null)
                    const Text(
                      'Live tracking unavailable',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  else ...[
                    Text(
                      '${currentTrip.route.sourceName} → ${currentTrip.route.destinationName}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TrackingSourceBadge(source: currentTrip.source),
                  ],
                  const SizedBox(height: 16),
                  _MetricLine(
                    label: 'ETA',
                    value: currentTrip?.etaDisplay ?? 'ETA unavailable',
                  ),
                  const SizedBox(height: 8),
                  _MetricLine(
                    label: 'Speed',
                    value: currentTrip?.currentSpeedKmph == null
                        ? 'Speed unavailable'
                        : '${currentTrip!.currentSpeedKmph!.toStringAsFixed(0)} km/h',
                  ),
                  if (currentTrip == null) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'No live trip data is available from the KKRTC service.',
                      style: TextStyle(color: AppColors.mutedBlueGrey),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Passenger-assisted GPS unavailable',
                      style: TextStyle(color: AppColors.mutedBlueGrey),
                    ),
                  ] else ...[
                    const SizedBox(height: 14),
                    OutlinedButton.icon(
                      onPressed: () =>
                          _showAssistedTracking(context, currentTrip),
                      icon: const Icon(Icons.share_location_outlined),
                      label: const Text('Passenger-assisted GPS'),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const VacTeamsFooter(padding: EdgeInsets.only(top: 16, bottom: 16)),
        ],
      ),
    );
  }

  void _showAssistedTracking(BuildContext context, TripModel trip) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          PassengerAssistedTrackingSheet(trip: trip, onToggleSharing: (_) {}),
    );
  }
}

class _MetricLine extends StatelessWidget {
  const _MetricLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(color: AppColors.mutedBlueGrey)),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
    ],
  );
}
