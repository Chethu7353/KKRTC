import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../shared/models/user_model.dart';
import '../../core/storage/app_state_storage.dart';
import '../../shared/widgets/kkrtc_logo.dart';
import '../../shared/widgets/vac_teams_footer.dart';
import 'login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  void _select(BuildContext context, UserRole role) {
    AppStateStorage.saveRole(role);
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => LoginScreen(role: role)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose account type')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 20),
            const Center(child: KkrtcLogo(size: 76, showText: false)),
            const SizedBox(height: 24),
            Text(
              'Welcome to KKRTC',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Select how you use the service. Your account type stays active until you sign out.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.mutedBlueGrey),
            ),
            const SizedBox(height: 32),
            _RoleCard(
              title: 'Passenger',
              description: 'Search journeys and check bus tracking.',
              icon: Icons.person_pin_circle_rounded,
              onTap: () => _select(context, UserRole.passenger),
            ),
            const SizedBox(height: 16),
            _RoleCard(
              title: 'Pilot',
              description:
                  'Choose a trip and share your location after starting it.',
              icon: Icons.badge_rounded,
              onTap: () => _select(context, UserRole.pilot),
            ),
            const SizedBox(height: 24),
            const VacTeamsFooter(padding: EdgeInsets.symmetric(vertical: 16)),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, color: AppColors.brightCyan, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(color: AppColors.mutedBlueGrey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.brightCyan),
            ],
          ),
        ),
      ),
    );
  }
}
