import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../core/constants/app_colors.dart';
import '../../core/maps/map_config.dart';

/// Interactive OpenStreetMap panel with zoom controls, current location,
/// bus tracking markers, and configurable tile providers.
class OsmMapPanel extends StatefulWidget {
  const OsmMapPanel({
    super.key,
    this.busLocation,
    this.origin,
    this.destination,
    this.routeCoordinates = const [],
    this.initialZoom = 14.0,
  });

  /// Real-time bus position received from the backend (if available).
  final LatLng? busLocation;

  /// Origin stop coordinates.
  final LatLng? origin;

  /// Destination stop coordinates.
  final LatLng? destination;

  /// Ordered coordinates representing the transit route polyline.
  final List<LatLng> routeCoordinates;

  /// Initial map zoom level.
  final double initialZoom;

  @override
  State<OsmMapPanel> createState() => _OsmMapPanelState();
}

class _OsmMapPanelState extends State<OsmMapPanel> {
  late final MapController _mapController;
  LatLng? _passengerLocation;
  bool _locationLoading = false;
  String? _locationError;
  late double _zoom;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _zoom = widget.initialZoom;
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _locatePassenger() async {
    setState(() {
      _locationLoading = true;
      _locationError = null;
    });
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw Exception('Turn on device location to show your position.');
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('Location permission was not granted.');
      }
      final position = await Geolocator.getCurrentPosition();
      final location = LatLng(position.latitude, position.longitude);
      if (!mounted) return;
      setState(() => _passengerLocation = location);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          try {
            _mapController.move(location, _zoom);
          } catch (_) {}
        }
      });
    } catch (error) {
      if (mounted) setState(() => _locationError = error.toString());
    } finally {
      if (mounted) setState(() => _locationLoading = false);
    }
  }

  void _changeZoom(double delta) {
    if (!mounted) return;
    try {
      final newZoom = (_mapController.camera.zoom + delta).clamp(3.0, 18.0);
      _zoom = newZoom;
      _mapController.move(_mapController.camera.center, newZoom);
    } catch (_) {}
  }

  Widget _buildBusMarker() {
    return Tooltip(
      message: 'Bus location',
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.brightCyan,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.deepNavy, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.brightCyan.withValues(alpha: 0.4),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        padding: const EdgeInsets.all(6),
        child: const Icon(
          Icons.directions_bus_rounded,
          color: AppColors.deepNavy,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildPassengerMarker() {
    return Tooltip(
      message: 'Your location',
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.iceBlue,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.deepNavy, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.iceBlue.withValues(alpha: 0.3),
              blurRadius: 6,
            ),
          ],
        ),
        padding: const EdgeInsets.all(4),
        child: const Icon(
          Icons.person_pin_circle_rounded,
          color: AppColors.deepNavy,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildLocationPin({
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return Tooltip(
      message: label,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.deepNavy, width: 2),
        ),
        padding: const EdgeInsets.all(4),
        child: Icon(icon, color: AppColors.deepNavy, size: 20),
      ),
    );
  }

  List<Marker> get _markers => [
    if (_passengerLocation != null)
      Marker(
        point: _passengerLocation!,
        width: 36,
        height: 36,
        child: _buildPassengerMarker(),
      ),
    if (widget.busLocation != null)
      Marker(
        point: widget.busLocation!,
        width: 44,
        height: 44,
        child: _buildBusMarker(),
      ),
    if (widget.origin != null)
      Marker(
        point: widget.origin!,
        width: 36,
        height: 36,
        child: _buildLocationPin(
          icon: Icons.trip_origin,
          color: AppColors.brightCyan,
          label: 'From',
        ),
      ),
    if (widget.destination != null)
      Marker(
        point: widget.destination!,
        width: 36,
        height: 36,
        child: _buildLocationPin(
          icon: Icons.location_on,
          color: AppColors.warningAmber,
          label: 'To',
        ),
      ),
  ];

  @override
  Widget build(BuildContext context) {
    if (!MapConfig.isConfigured) {
      return const _MapNotice(
        icon: Icons.map_outlined,
        message: 'OpenStreetMap tiles are not configured.',
      );
    }

    if (_passengerLocation == null &&
        widget.busLocation == null &&
        widget.origin == null &&
        widget.routeCoordinates.isEmpty) {
      return _MapNotice(
        icon: Icons.my_location,
        message: _locationError ?? 'Enable location to open the live map.',
        action: _locationLoading ? null : _locatePassenger,
        loading: _locationLoading,
      );
    }

    final initialCenter =
        widget.busLocation ??
        widget.origin ??
        _passengerLocation ??
        (widget.routeCoordinates.isNotEmpty
            ? widget.routeCoordinates.first
            : const LatLng(
                MapConfig.defaultLatitude,
                MapConfig.defaultLongitude,
              ));

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: _zoom,
              minZoom: 3.0,
              maxZoom: 18.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: MapConfig.tileUrlTemplate,
                userAgentPackageName: MapConfig.userAgentPackageName,
                maxZoom: 18,
              ),
              if (widget.routeCoordinates.length >= 2)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: widget.routeCoordinates,
                      color: AppColors.brightCyan,
                      strokeWidth: 4.5,
                    ),
                  ],
                ),
              MarkerLayer(markers: _markers),
            ],
          ),
          Positioned(
            left: 8,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.deepNavy.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppColors.oceanBlue.withValues(alpha: 0.5),
                  width: 0.5,
                ),
              ),
              child: const Text(
                MapConfig.attribution,
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Positioned(
            right: 12,
            top: 12,
            child: Column(
              children: [
                _MapControl(
                  icon: Icons.add,
                  label: 'Zoom in',
                  onPressed: () => _changeZoom(1),
                ),
                const SizedBox(height: 8),
                _MapControl(
                  icon: Icons.remove,
                  label: 'Zoom out',
                  onPressed: () => _changeZoom(-1),
                ),
                const SizedBox(height: 8),
                _MapControl(
                  icon: Icons.my_location,
                  label: 'My location',
                  onPressed: _locatePassenger,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapNotice extends StatelessWidget {
  const _MapNotice({
    required this.icon,
    required this.message,
    this.action,
    this.loading = false,
  });

  final IconData icon;
  final String message;
  final VoidCallback? action;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.darkBlue,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.oceanBlue),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.brightCyan, size: 30),
          const SizedBox(height: 10),
          Text(message, textAlign: TextAlign.center),
          if (action != null) ...[
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: action,
              child: loading
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Use current location'),
            ),
          ],
        ],
      ),
    );
  }
}

class _MapControl extends StatelessWidget {
  const _MapControl({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.darkBlue,
      borderRadius: BorderRadius.circular(12),
      child: IconButton(
        tooltip: label,
        onPressed: onPressed,
        icon: Icon(icon, color: AppColors.brightCyan),
      ),
    );
  }
}
