import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/models/user_model.dart';
import '../../shared/widgets/custom_button.dart';
import '../driver/driver_dashboard_screen.dart';
import '../passenger/passenger_main_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final UserRole role;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.role,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _timerSeconds = 30;
  Timer? _timer;
  bool _isVerifying = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _timerSeconds = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timerSeconds > 0) {
        setState(() => _timerSeconds--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _verifyOtp() async {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length != 6) {
      setState(() => _errorMessage = 'Please enter all 6 digits');
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    // Simulate verification delay
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    setState(() => _isVerifying = false);

    final dashboard = widget.role == UserRole.pilot
        ? const DriverDashboardScreen()
        : const PassengerMainScreen();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => dashboard),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: const Text('Verify Phone'),
        backgroundColor: AppColors.deepNavy,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              const Icon(
                Icons.mark_email_read_outlined,
                size: 64,
                color: AppColors.deepNavy,
              ),
              const SizedBox(height: 20),

              const Text(
                AppStrings.verifyOtp,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                '${AppStrings.enterOtpPrompt} ${widget.phoneNumber}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // 6-digit OTP Input Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 46,
                    height: 54,
                    child: TextFormField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.deepNavy,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                        filled: true,
                        fillColor: AppColors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.borderSubtle,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.deepNavy,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (val) {
                        if (val.isNotEmpty && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (val.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 14),
                Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: AppColors.errorRed,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              const SizedBox(height: 28),

              CustomButton(
                text: 'Confirm & Continue',
                isLoading: _isVerifying,
                onPressed: _verifyOtp,
              ),

              const SizedBox(height: 20),

              // Resend Countdown
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _timerSeconds > 0
                        ? '${AppStrings.resendOtpIn} 00:${_timerSeconds.toString().padLeft(2, '0')}'
                        : "Didn't receive code?",
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  if (_timerSeconds == 0)
                    TextButton(
                      onPressed: _startCountdown,
                      child: const Text(
                        AppStrings.resendOtp,
                        style: TextStyle(
                          color: AppColors.transportOrange,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
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
