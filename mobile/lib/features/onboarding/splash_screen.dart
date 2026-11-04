import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../core/constants/app_colors.dart';
import '../authentication/role_selection_screen.dart';

enum _SplashPhase { ambient, video, fallback }

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const _videoAsset = 'assets/video/kkrtc_logo_reveal.mp4';
  static const _logoAsset = 'assets/images/kkrtc_app_logo.png';

  VideoPlayerController? _videoController;
  late final AnimationController _fallbackFade;
  Timer? _ambientTimer;
  Timer? _fallbackTimer;
  Timer? _completionTimer;
  _SplashPhase _phase = _SplashPhase.ambient;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _fallbackFade = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _ambientTimer = Timer(const Duration(milliseconds: 1500), _startVideo);
  }

  Future<void> _startVideo() async {
    if (!mounted) return;
    setState(() => _phase = _SplashPhase.video);

    final controller = VideoPlayerController.asset(_videoAsset);
    _videoController = controller;
    try {
      await controller.initialize();
      if (!mounted) return;
      setState(() {});
      await controller.setLooping(false);
      controller.addListener(_onVideoUpdate);
      await controller.play();
    } catch (_) {
      _showLogoFallback();
    }
  }

  void _onVideoUpdate() {
    final controller = _videoController;
    if (controller == null || !controller.value.isInitialized) return;

    if (controller.value.hasError) {
      _showLogoFallback();
      return;
    }

    if (controller.value.position >= controller.value.duration &&
        !controller.value.isPlaying &&
        _completionTimer == null) {
      _completionTimer = Timer(
        const Duration(milliseconds: 500),
        _navigateToRoleSelection,
      );
    }
  }

  void _showLogoFallback() {
    if (!mounted || _phase == _SplashPhase.fallback || _navigated) return;
    _videoController?.removeListener(_onVideoUpdate);
    _videoController?.dispose();
    _videoController = null;
    setState(() => _phase = _SplashPhase.fallback);
    _fallbackFade.forward();
    _fallbackTimer = Timer(
      const Duration(milliseconds: 3000),
      _navigateToRoleSelection,
    );
  }

  void _navigateToRoleSelection() {
    if (!mounted || _navigated) return;
    _navigated = true;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const RoleSelectionScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _ambientTimer?.cancel();
    _fallbackTimer?.cancel();
    _completionTimer?.cancel();
    _videoController?.removeListener(_onVideoUpdate);
    _videoController?.dispose();
    _fallbackFade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final video = _videoController;

    return Scaffold(
      backgroundColor: AppColors.deepNavy,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _AmbientLighting(),
          if (_phase == _SplashPhase.video &&
              video != null &&
              video.value.isInitialized)
            FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: video.value.size.width,
                height: video.value.size.height,
                child: VideoPlayer(video),
              ),
            ),
          if (_phase == _SplashPhase.fallback)
            Center(
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: _fallbackFade,
                  curve: Curves.easeOut,
                ),
                child: _FallbackLogo(asset: _logoAsset),
              ),
            ),
        ],
      ),
    );
  }
}

class _AmbientLighting extends StatelessWidget {
  const _AmbientLighting();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.deepNavy,
        gradient: RadialGradient(
          center: Alignment(0, -0.1),
          radius: 0.85,
          colors: [AppColors.oceanBlue, AppColors.deepNavy],
          stops: [0, 1],
        ),
      ),
      child: Center(
        child: Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.brightCyan.withValues(alpha: 0.09),
                blurRadius: 100,
                spreadRadius: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FallbackLogo extends StatelessWidget {
  const _FallbackLogo({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final maxWidth = math.min(size.width * 0.9, 520.0);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        maxHeight: size.height * 0.74,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.brightCyan.withValues(alpha: 0.14),
              blurRadius: 48,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Image.asset(asset, fit: BoxFit.contain),
      ),
    );
  }
}
