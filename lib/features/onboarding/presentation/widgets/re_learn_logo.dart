import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

/// Editorial logomark for Re-Learn: a circular ring with a cross
/// drawn through the centre and a serif "R" integrated at the core.
///
/// Geometry follows a 120 × 120 reference viewBox but is drawn
/// scaled to [size], so the widget can be reused at any scale.
class ReLearnLogo extends StatelessWidget {
  const ReLearnLogo({
    super.key,
    this.size = 40,
    this.color = AppColors.primaryGreen,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _ReLearnLogoPainter(color: color, fontFamily: AppFonts.serif),
    );
  }
}

class _ReLearnLogoPainter extends CustomPainter {
  _ReLearnLogoPainter({required this.color, required this.fontFamily});

  final Color color;
  final String fontFamily;

  static const double _viewBox = 120;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / _viewBox;

    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final center = Offset(60 * scale, 60 * scale);

    canvas.drawCircle(center, 52 * scale, stroke);

    canvas.drawLine(
      Offset(34 * scale, 60 * scale),
      Offset(86 * scale, 60 * scale),
      stroke,
    );
    canvas.drawLine(
      Offset(60 * scale, 34 * scale),
      Offset(60 * scale, 86 * scale),
      stroke,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: 'R',
        style: TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w600,
          fontSize: 42 * scale,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _ReLearnLogoPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.fontFamily != fontFamily;
}