import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../bus_search/bus_search_screen.dart';

class TripsTab extends StatelessWidget {
  const TripsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My trips')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.confirmation_number_outlined,
                size: 48,
                color: AppColors.brightCyan,
              ),
              const SizedBox(height: 16),
              const Text(
                'Trip history unavailable',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                'The KKRTC trips service is not connected yet. No sample trips are shown.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.mutedBlueGrey),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const BusSearchScreen(),
                  ),
                ),
                icon: const Icon(Icons.search),
                label: const Text('Search buses'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
