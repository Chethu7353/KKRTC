import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/models/trip_model.dart';
import '../../shared/widgets/custom_button.dart';

class PassengerAssistedTrackingSheet extends StatefulWidget {
  final TripModel trip;
  final bool initialIsSharing;
  final Function(bool isSharing) onToggleSharing;

  const PassengerAssistedTrackingSheet({
    super.key,
    required this.trip,
    this.initialIsSharing = false,
    required this.onToggleSharing,
  });

  @override
  State<PassengerAssistedTrackingSheet> createState() =>
      _PassengerAssistedTrackingSheetState();
}

class _PassengerAssistedTrackingSheetState
    extends State<PassengerAssistedTrackingSheet> {
  late bool _isSharing;
  bool _consentAcknowledged = false;

  @override
  void initState() {
    super.initState();
    _isSharing = widget.initialIsSharing;
    if (_isSharing) {
      _consentAcknowledged = true;
    }
  }

  void _handleToggle(bool enable) {
    if (enable && !_consentAcknowledged) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please acknowledge the crowdsourcing consent notice below.',
          ),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    if (enable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Passenger-assisted tracking is unavailable until the KKRTC location service is connected.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isSharing = false;
    });

    widget.onToggleSharing(false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Passenger location contribution stopped.'),
        backgroundColor: AppColors.secondaryText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.softYellow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.airline_seat_recline_normal_rounded,
                  color: AppColors.midnightNavy,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      AppStrings.passengerAssistedTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.midnightNavy,
                      ),
                    ),
                    Text(
                      AppStrings.passengerAssistedSubtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.secondaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  color: AppColors.secondaryText,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Bus Details Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.creamBackground,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.directions_bus_rounded,
                  color: AppColors.transportOrange,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.trip.bus.registrationNumber,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryText,
                        ),
                      ),
                      Text(
                        '${widget.trip.route.sourceName} Ã¢Å¾â€ ${widget.trip.route.destinationName} Ã¢â‚¬Â¢ ${widget.trip.bus.serviceType.label}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.secondaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _isSharing
                        ? AppColors.successGreen.withValues(alpha: 0.15)
                        : AppColors.softYellow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _isSharing ? 'CONTRIBUTING' : 'READY',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: _isSharing
                          ? AppColors.successGreen
                          : AppColors.primaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Privacy & Policy Transparency Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.softYellow.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.goldenYellow.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.shield_outlined,
                  size: 20,
                  color: AppColors.deepNavy,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Community Crowdsourcing Disclaimer',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.deepNavy,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your smartphone anonymously sends GPS coordinates while you are inside this bus. '
                        'Passenger GPS is clearly marked as "Passenger-Assisted" and never overrides verified driver GPS.',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.primaryText.withValues(alpha: 0.85),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Consent Checkbox
          CheckboxListTile(
            value: _consentAcknowledged,
            onChanged: (val) {
              setState(() {
                _consentAcknowledged = val ?? false;
                if (!_consentAcknowledged && _isSharing) {
                  _isSharing = false;
                  widget.onToggleSharing(false);
                }
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            dense: true,
            activeColor: AppColors.deepNavy,
            title: const Text(
              'I am currently aboard this KKRTC bus and consent to contributing location data for fellow travelers.',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryText,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Action Buttons
          if (!_isSharing)
            CustomButton(
              text: 'Start Contributing Location',
              icon: Icons.cell_tower_rounded,
              backgroundColor: AppColors.transportOrange,
              onPressed: _consentAcknowledged
                  ? () => _handleToggle(true)
                  : null,
            )
          else ...[
            const Text(
              'Passenger-assisted tracking unavailable',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.mutedBlueGrey),
            ),
            const SizedBox(height: 8),
            CustomButton(
              text: 'Stop Location Contribution',
              icon: Icons.stop_circle_outlined,
              isOutlined: true,
              outlinedBorderColor: AppColors.errorRed,
              onPressed: () => _handleToggle(false),
            ),
          ],
        ],
      ),
    );
  }
}
