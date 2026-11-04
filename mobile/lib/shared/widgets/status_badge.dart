import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../models/trip_model.dart';

class TrackingSourceBadge extends StatelessWidget {
  final TrackingSource source;
  final bool compact;
  final bool isCompact;

  const TrackingSourceBadge({
    super.key,
    required this.source,
    this.compact = false,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color border;
    Color text;
    IconData icon;
    String label;

    switch (source) {
      case TrackingSource.officialDriverGps:
        bg = AppColors.officialDriverGps.withValues(alpha: 0.12);
        border = AppColors.officialDriverGps;
        text = AppColors.officialDriverGps;
        icon = Icons.verified_user_rounded;
        label = 'Official Driver GPS';
        break;
      case TrackingSource.passengerAssistedGps:
      case TrackingSource.passengerAssisted:
        bg = AppColors.passengerAssistedGps.withValues(alpha: 0.12);
        border = AppColors.passengerAssistedGps;
        text = AppColors.passengerAssistedGps;
        icon = Icons.group_rounded;
        label = 'Passenger-Assisted GPS';
        break;
      case TrackingSource.gpsUnavailable:
        bg = AppColors.gpsUnavailable.withValues(alpha: 0.10);
        border = AppColors.gpsUnavailable;
        text = AppColors.gpsUnavailable;
        icon = Icons.location_off_rounded;
        label = 'GPS Unavailable (Stale)';
        break;
    }

    if (compact || isCompact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: border, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: text),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: text,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: text),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: text,
            ),
          ),
        ],
      ),
    );
  }
}

class LiveStatusBadge extends StatelessWidget {
  final bool isLive;
  final bool isDelayed;

  const LiveStatusBadge({
    super.key,
    required this.isLive,
    this.isDelayed = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLive) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.staleGrey.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.staleGrey),
        ),
        child: const Text(
          'SCHEDULED',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.staleGrey,
          ),
        ),
      );
    }

    if (isDelayed) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.warningAmber.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.warningAmber),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 12,
              color: AppColors.warningAmber,
            ),
            SizedBox(width: 3),
            Text(
              'DELAYED',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.warningAmber,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.successGreen.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.successGreen),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.fiber_manual_record,
            size: 10,
            color: AppColors.successGreen,
          ),
          SizedBox(width: 4),
          Text(
            'LIVE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.successGreen,
            ),
          ),
        ],
      ),
    );
  }
}
