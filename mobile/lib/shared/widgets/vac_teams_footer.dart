import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Persistent branding footer displaying "Powered by VAC Teams".
/// Designed with subtle typography in the KKRTC navy/cyan palette,
/// fully SafeArea-aware, and unobtrusive across all form factors.
class VacTeamsFooter extends StatelessWidget {
  const VacTeamsFooter({
    super.key,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
  });

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      left: false,
      right: false,
      child: Padding(
        padding: padding,
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 0.6,
                fontWeight: FontWeight.w500,
                color: AppColors.mutedBlueGrey,
              ),
              children: [
                TextSpan(text: 'Powered by '),
                TextSpan(
                  text: 'VAC Teams',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.brightCyan,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
