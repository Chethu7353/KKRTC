import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../core/constants/app_colors.dart';
import '../authentication/role_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _videoAsset = 'assets/video/kkrtc_logo_reveal.mp4';

  VideoPlayerController? _videoController;
  bool _videoReady = false;
  bool _videoFailed = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    final controller = VideoPlayerController.asset(_videoAsset);
    _videoController = controller;
    try {
      await controller.initialize();
      if (!mounted) return;
      controller.addListener(_onVideoUpdate);
      setState(() => _videoReady = true);
      await controller.play();
    } catch (_) {
      if (mounted) setState(() => _videoFailed = true);
    }
  }

  void _onVideoUpdate() {
    final controller = _videoController;
    if (controller != null &&
        controller.value.isInitialized &&
        controller.value.position >= controller.value.duration &&
        !controller.value.isPlaying) {
      _navigateToRoleSelection();
    }
  }

  void _navigateToRoleSelection() {
    if (!mounted || _navigated) return;
    _navigated = true;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const RoleSelectionScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _videoController?.removeListener(_onVideoUpdate);
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepNavy,
      body: Center(
        child: _videoReady && _videoController != null
            ? AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              )
            : _videoFailed
            ? Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'KKRTC intro video could not be played.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.white),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _navigateToRoleSelection,
                      child: const Text('Continue'),
                    ),
                  ],
                ),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
