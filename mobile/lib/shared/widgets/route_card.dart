import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../models/route_model.dart';

class RouteCard extends StatelessWidget {
  final RouteModel route;
  final VoidCallback onTap;

  const RouteCard({super.key, required this.route, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.warmLightYellow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    route.routeNumber,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.deepNavy,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      route.routeName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${route.distanceKm} km • Approx ${route.durationFormatted}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.mutedText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
