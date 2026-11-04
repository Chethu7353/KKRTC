import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/constants/app_colors.dart';
import '../../core/maps/google_maps_config.dart';

class GoogleMapPanel extends StatefulWidget {
  const GoogleMapPanel({
    super.key,
    this.busLocation,
    this.origin,
    this.destination,
    this.routeCoordinates = const [],
  });

  final LatLng? busLocation;
  final LatLng? origin;
  final LatLng? destination;
  final List<LatLng> routeCoordinates;

  @override
  State<GoogleMapPanel> createState() => _GoogleMapPanelState();
}

class _GoogleMapPanelState extends State<GoogleMapPanel> {
  GoogleMapController? _controller;
  LatLng? _passengerLocation;
  bool _locationLoading = false;
  String? _locationError;
  double _zoom = 14;

  Future<void> _locatePassenger() async {
    if (!GoogleMapsConfig.isConfigured) return;
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
      await _controller?.animateCamera(
        CameraUpdate.newLatLngZoom(location, _zoom),
      );
    } catch (error) {
      if (mounted) setState(() => _locationError = error.toString());
    } finally {
      if (mounted) setState(() => _locationLoading = false);
    }
  }

  Set<Marker> get _markers => {
    if (_passengerLocation != null)
      Marker(
        markerId: const MarkerId('passenger-location'),
        position: _passengerLocation!,
        infoWindow: const InfoWindow(title: 'Your location'),
      ),
    if (widget.busLocation != null)
      Marker(
        markerId: const MarkerId('bus-location'),
        position: widget.busLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        infoWindow: const InfoWindow(title: 'Bus location'),
      ),
    if (widget.origin != null)
      Marker(
        markerId: const MarkerId('trip-origin'),
        position: widget.origin!,
        infoWindow: const InfoWindow(title: 'From'),
      ),
    if (widget.destination != null)
      Marker(
        markerId: const MarkerId('trip-destination'),
        position: widget.destination!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(title: 'To'),
      ),
  };

  Set<Polyline> get _polylines => widget.routeCoordinates.length < 2
      ? {}
      : {
          Polyline(
            polylineId: const PolylineId('selected-route'),
            points: widget.routeCoordinates,
            color: AppColors.brightCyan,
            width: 5,
          ),
        };

  @override
  Widget build(BuildContext context) {
    if (!GoogleMapsConfig.isConfigured) {
      return const _MapNotice(
        icon: Icons.map_outlined,
        message: 'Google Maps unavailable. Configure GOOGLE_MAPS_API_KEY for the Android Maps SDK.',
      );
    }

    if (_passengerLocation == null &&
        widget.busLocation == null &&
        widget.origin == null) {
      return _MapNotice(
        icon: Icons.my_location,
        message: _locationError ?? 'Enable location to open the live map.',
        action: _locationLoading ? null : _locatePassenger,
        loading: _locationLoading,
      );
    }

    final initial = widget.origin ?? widget.busLocation ?? _passengerLocation!;
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: initial, zoom: _zoom),
            onMapCreated: (controller) => _controller = controller,
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: _passengerLocation != null,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: true,
            mapToolbarEnabled: false,
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

  Future<void> _changeZoom(double delta) async {
    _zoom = (_zoom + delta).clamp(2, 20);
    await _controller?.animateCamera(CameraUpdate.zoomTo(_zoom));
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
