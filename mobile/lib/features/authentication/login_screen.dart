import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/models/user_model.dart';
import '../../shared/widgets/custom_button.dart';
import '../../core/storage/app_state_storage.dart';
import '../../shared/widgets/kkrtc_logo.dart';
import '../../shared/widgets/vac_teams_footer.dart';
import 'otp_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.role});

  final UserRole role;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedPhone();
  }

  Future<void> _loadSavedPhone() async {
    final phone = await AppStateStorage.getPhoneNumber();
    if (phone != null && phone.isNotEmpty && mounted) {
      final raw = phone.replaceAll(RegExp(r'^\+91\s*'), '').trim();
      if (raw.length <= 10) {
        setState(() => _phoneController.text = raw);
      }
    }
  }

  void _handleSendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate OTP generation delay
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OtpVerificationScreen(
          phoneNumber: '+91 ${_phoneController.text.trim()}',
          role: widget.role,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                const Center(child: KkrtcLogo(size: 80, showText: false)),
                const SizedBox(height: 24),

                const Text(
                  AppStrings.loginTitle,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryText,
                    letterSpacing: -0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                const Text(
                  AppStrings.loginTitleKn,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.transportOrange,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  AppStrings.loginSubtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.secondaryText,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 36),

                // Card with Phone Input
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          AppStrings.mobileNumber,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Phone Field with +91 Prefix
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 52,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.subtleGrey,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.borderSubtle,
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Text(
                                    '🇮🇳 +91',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryText,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 16,
                                    color: AppColors.secondaryText,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.0,
                                ),
                                decoration: const InputDecoration(
                                  counterText: '',
                                  hintText: 'Enter 10-digit number',
                                ),
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return 'Please enter mobile number';
                                  }
                                  if (val.trim().length != 10) {
                                    return 'Must be 10 digits';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 22),

                        CustomButton(
                          text: AppStrings.sendOtp,
                          isLoading: _isLoading,
                          icon: Icons.sms_outlined,
                          onPressed: _handleSendOtp,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Demonstration Notice Banner
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.warmLightYellow.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.softYellow),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 18,
                        color: AppColors.deepNavy,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Demo Mode: Enter any 10-digit mobile number. Real SMS OTP integration will activate in Phase 2.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primaryText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const VacTeamsFooter(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
