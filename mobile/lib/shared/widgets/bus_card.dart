import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../models/trip_model.dart';
import 'status_badge.dart';

class BusCard extends StatelessWidget {
  final TripModel trip;
  final VoidCallback onTap;

  const BusCard({super.key, required this.trip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Registration, Service Type, Status Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.deepNavy.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.directions_bus_filled_rounded,
                          size: 20,
                          color: AppColors.deepNavy,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trip.bus.registrationNumber,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryText,
                              letterSpacing: 0.2,
                            ),
                          ),
                          Text(
                            trip.bus.serviceTypeDisplayName,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  LiveStatusBadge(
                    isLive: trip.isLive,
                    isDelayed: trip.isDelayed,
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Route & Stops Line
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Route Corridor',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.mutedText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          trip.route.routeName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warmLightYellow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Estimated Arrival',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.midnightNavy,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          trip.etaDisplay,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.deepNavy,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 10),

              // Bottom Row: Next Stop & Tracking Source
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.near_me_outlined,
                          size: 14,
                          color: AppColors.transportOrange,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'Next: ${trip.nextStop}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryText,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TrackingSourceBadge(
                    source: trip.trackingSource,
                    compact: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
