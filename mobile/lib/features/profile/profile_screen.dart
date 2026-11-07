import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/storage/app_state_storage.dart';
import '../../shared/widgets/vac_teams_footer.dart';
import '../authentication/role_selection_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isKannada = false;
  bool _notificationsEnabled = true;
  bool _arrivalAlertsEnabled = true;
  String _phoneNumber = '+91 98765 43210';

  @override
  void initState() {
    super.initState();
    _loadStoredUserData();
  }

  Future<void> _loadStoredUserData() async {
    final phone = await AppStateStorage.getPhoneNumber();
    if (phone != null && phone.isNotEmpty && mounted) {
      setState(() => _phoneNumber = phone);
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.phone_in_talk_rounded,
                color: AppColors.transportOrange,
              ),
              SizedBox(width: 8),
              Text(
                'KKRTC Helplines',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHelpRow('KKRTC Central Call Center', '08472-227227'),
              const Divider(height: 16),
              _buildHelpRow('Ballari Depot In-charge', '08392-277112'),
              const Divider(height: 16),
              _buildHelpRow('Gangavathi Depot', '08533-270420'),
              const Divider(height: 16),
              _buildHelpRow('Emergency Assistance', '112'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  static Widget _buildHelpRow(String label, String number) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.secondaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          number,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.deepNavy,
          ),
        ),
      ],
    );
  }

  void _handleLogout() {
    showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Confirm Logout'),
          content: const Text(
            'Are you sure you want to log out of KKRTC Where Is My Bus?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorRed,
                foregroundColor: AppColors.white,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    ).then((confirmed) async {
      if (confirmed == true && mounted) {
        await AppStateStorage.clearSession();
        if (!mounted) return;
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute<void>(builder: (_) => const RoleSelectionScreen()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: const Text(
          AppStrings.profileTitle,
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: AppColors.midnightNavy,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 1. Profile Avatar & Phone
            _buildProfileHeader(),

            const SizedBox(height: 20),

            const SizedBox(height: 20),

            // 3. Language & Display Settings
            _buildSettingsSection(
              title: 'Preferences & Language',
              children: [
                SwitchListTile(
                  title: const Text(
                    'App Language: ಕನ್ನಡ (Kannada)',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    _isKannada ? 'ಕನ್ನಡ ಸಕ್ರಿಯವಾಗಿದೆ' : 'English is active',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  value: _isKannada,
                  activeThumbColor: AppColors.transportOrange,
                  onChanged: (val) {
                    setState(() => _isKannada = val);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          val
                              ? 'ಭಾಷೆಯನ್ನು ಕನ್ನಡಕ್ಕೆ ಬದಲಾಯಿಸಲಾಗಿದೆ'
                              : 'Language set to English',
                        ),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text(
                    'Push Notifications',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text(
                    'Get alerts about bus arrivals and delays',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  value: _notificationsEnabled,
                  activeThumbColor: AppColors.deepNavy,
                  onChanged: (val) =>
                      setState(() => _notificationsEnabled = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text(
                    'Stop Proximity Vibrations',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text(
                    'Vibrate phone when 1 km from destination stop',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  value: _arrivalAlertsEnabled,
                  activeThumbColor: AppColors.deepNavy,
                  onChanged: (val) =>
                      setState(() => _arrivalAlertsEnabled = val),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 4. Support & Info Section
            _buildSettingsSection(
              title: 'Support & Information',
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.help_outline_rounded,
                    color: AppColors.deepNavy,
                  ),
                  title: const Text(
                    'KKRTC Helpline & Depot Contacts',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: _showHelpDialog,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.deepNavy,
                  ),
                  title: const Text(
                    'About KKRTC Where Is My Bus',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text(
                    'Version 1.0.0 • Ballari Division Corridor',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'KKRTC Where Is My Bus?',
                      applicationVersion: '1.0.0',
                      applicationLegalese: 'Kalyana Karnataka Road Transport Corporation (KKRTC)\nGovernment of Karnataka',
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 5. Logout Button
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.errorRed,
                side: const BorderSide(color: AppColors.errorRed),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.logout_rounded),
              label: const Text(
                'Log Out',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              onPressed: _handleLogout,
            ),

            const VacTeamsFooter(padding: EdgeInsets.only(top: 24, bottom: 20)),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkBlue,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.warmLightYellow,
            child: const Icon(
              Icons.person_rounded,
              size: 34,
              color: AppColors.midnightNavy,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Karnataka Commuter',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _phoneNumber,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.secondaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Verified Passenger Account',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.successGreen,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkBlue,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.secondaryText,
                letterSpacing: 0.5,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}
