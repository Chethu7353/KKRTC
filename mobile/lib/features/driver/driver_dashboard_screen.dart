import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_config.dart';
import '../../shared/widgets/google_map_panel.dart';

class DriverDashboardScreen extends StatefulWidget {
  const DriverDashboardScreen({super.key});

  @override
  State<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends State<DriverDashboardScreen> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  bool _journeyConfirmed = false;
  bool _startingTrip = false;
  String? _serviceMessage;

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _confirmJourney() {
    if (_fromController.text.trim().isEmpty ||
        _toController.text.trim().isEmpty) {
      setState(
        () =>
            _serviceMessage = 'Enter both a starting address and destination.',
      );
      return;
    }
    setState(() {
      _journeyConfirmed = true;
      _serviceMessage = null;
    });
  }

  Future<void> _startTrip() async {
    setState(() {
      _startingTrip = true;
      _serviceMessage = null;
    });
    try {
      await ApiClient().post(
        ApiConfig.driverStartTripEndpoint,
        data: {
          'origin': _fromController.text.trim(),
          'destination': _toController.text.trim(),
        },
      );
      if (mounted) {
        setState(
          () => _serviceMessage =
              'Trip service responded, but did not return a tracking session.',
        );
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _serviceMessage =
              'Trip service unavailable. No trip has been started.',
        );
      }
    } finally {
      if (mounted) setState(() => _startingTrip = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilot journey')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Plan your trip',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            const Text(
              'Select a start and destination. A trip only begins when you press Start trip.',
              style: TextStyle(color: AppColors.mutedBlueGrey),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _fromController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'From',
                hintText: 'Starting address',
                prefixIcon: Icon(Icons.trip_origin),
              ),
              onChanged: (_) => setState(() => _journeyConfirmed = false),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _toController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'To',
                hintText: 'Destination address',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              onChanged: (_) => setState(() => _journeyConfirmed = false),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _confirmJourney,
              icon: const Icon(Icons.route_outlined),
              label: const Text('Confirm journey'),
            ),
            if (_journeyConfirmed) ...[
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Selected journey'),
                      const SizedBox(height: 8),
                      Text('From: ${_fromController.text.trim()}'),
                      const SizedBox(height: 4),
                      Text('To: ${_toController.text.trim()}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const SizedBox(height: 250, child: GoogleMapPanel()),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _startingTrip ? null : _startTrip,
                icon: _startingTrip
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.play_arrow_rounded),
                label: const Text('Start trip'),
              ),
            ],
            if (_serviceMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                _serviceMessage!,
                style: const TextStyle(color: AppColors.iceBlue),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.gps_not_fixed, color: AppColors.mutedBlueGrey),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Live tracking unavailable until the trip and GPS APIs are configured.',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
