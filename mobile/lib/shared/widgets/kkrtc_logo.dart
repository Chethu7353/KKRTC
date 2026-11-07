import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Reusable Vector-drawn KKRTC Emblem Logo Widget
/// Clean, high-resolution drawing matching Section 3 specifications.
class KkrtcLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool isLightOnDark;

  const KkrtcLogo({
    super.key,
    this.size = 72,
    this.showText = true,
    this.isLightOnDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.deepNavy, AppColors.midnightNavy],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(size * 0.28),
            boxShadow: [
              BoxShadow(
                color: AppColors.deepNavy.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(
              color: AppColors.goldenYellow,
              width: size * 0.035,
            ),
          ),
          child: CustomPaint(painter: _KkrtcEmblemPainter()),
        ),
        if (showText) ...[
          SizedBox(height: size * 0.16),
          Text(
            'KKRTC',
            style: TextStyle(
              fontSize: size * 0.28,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
              color: isLightOnDark ? AppColors.white : AppColors.primaryText,
            ),
          ),
          Text(
            'ಕೆ.ಕೆ.ಆರ್.ಟಿ.ಸಿ',
            style: TextStyle(
              fontSize: size * 0.16,
              fontWeight: FontWeight.w600,
              color: isLightOnDark
                  ? AppColors.softYellow
                  : AppColors.secondaryText,
            ),
          ),
        ],
      ],
    );
  }
}

class _KkrtcEmblemPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Bus body outline
    final busPaint = Paint()
      ..color = AppColors.goldenYellow
      ..style = PaintingStyle.fill;

    final busRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.5),
        width: w * 0.58,
        height: h * 0.44,
      ),
      Radius.circular(w * 0.08),
    );
    canvas.drawRRect(busRect, busPaint);

    // Windshield (Navy)
    final windowPaint = Paint()
      ..color = AppColors.midnightNavy
      ..style = PaintingStyle.fill;

    final windowRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.42),
        width: w * 0.46,
        height: h * 0.16,
      ),
      Radius.circular(w * 0.04),
    );
    canvas.drawRRect(windowRect, windowPaint);

    // Headlights (Transport Orange)
    final lightPaint = Paint()..color = AppColors.transportOrange;
    canvas.drawCircle(Offset(w * 0.3, h * 0.60), w * 0.04, lightPaint);
    canvas.drawCircle(Offset(w * 0.7, h * 0.60), w * 0.04, lightPaint);

    // Radiator Grille Lines
    final grillePaint = Paint()
      ..color = AppColors.midnightNavy
      ..strokeWidth = w * 0.02
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(w * 0.40, h * 0.58),
      Offset(w * 0.60, h * 0.58),
      grillePaint,
    );
    canvas.drawLine(
      Offset(w * 0.42, h * 0.63),
      Offset(w * 0.58, h * 0.63),
      grillePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
