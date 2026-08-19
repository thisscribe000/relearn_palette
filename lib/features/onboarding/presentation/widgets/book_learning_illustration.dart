import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Editorial illustration conveying the Re-Learn concept:
/// an open book with small "learning bite" cards emerging from it.
///
/// Pure Flutter drawing, scaled from a 240 × 240 design grid so it
/// works at any [size] without external image assets.
class BookLearningIllustration extends StatelessWidget {
  const BookLearningIllustration({
    super.key,
    this.size = 240,
    this.ink = AppColors.primaryGreen,
    this.accent = AppColors.mutedGold,
  });

  final double size;
  final Color ink;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _BookLearningIllustrationPainter(ink: ink, accent: accent),
    );
  }
}

enum _CardSymbol { summary, audio, idea }

class _BookLearningIllustrationPainter extends CustomPainter {
  _BookLearningIllustrationPainter({required this.ink, required this.accent});

  final Color ink;
  final Color accent;

  static const double _grid = 240;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide / _grid;

    final line = Paint()
      ..color = ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final cardLine = Paint()
      ..color = ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s
      ..strokeCap = StrokeCap.round;

    _drawBook(canvas, s, line);
    _drawEmergence(canvas, s, line);
    _drawCard(
      canvas,
      s: s,
      center: const Offset(98, 62),
      tilt: -0.14,
      paint: cardLine,
      symbol: _CardSymbol.summary,
    );
    _drawCard(
      canvas,
      s: s,
      center: const Offset(120, 42),
      tilt: 0.02,
      paint: cardLine,
      symbol: _CardSymbol.audio,
    );
    _drawCard(
      canvas,
      s: s,
      center: const Offset(146, 66),
      tilt: 0.12,
      paint: cardLine,
      symbol: _CardSymbol.idea,
    );
  }

  void _drawBook(Canvas canvas, double s, Paint line) {
    final pageFill = Paint()..color = AppColors.paper;

    final left = Path()
      ..moveTo(120 * s, 118 * s)
      ..cubicTo(84 * s, 116 * s, 56 * s, 122 * s, 44 * s, 134 * s)
      ..cubicTo(40 * s, 142 * s, 40 * s, 152 * s, 46 * s, 158 * s)
      ..cubicTo(70 * s, 164 * s, 100 * s, 162 * s, 120 * s, 160 * s)
      ..close();
    final right = Path()
      ..moveTo(120 * s, 118 * s)
      ..cubicTo(156 * s, 116 * s, 184 * s, 122 * s, 196 * s, 134 * s)
      ..cubicTo(200 * s, 142 * s, 200 * s, 152 * s, 194 * s, 158 * s)
      ..cubicTo(170 * s, 164 * s, 140 * s, 162 * s, 120 * s, 160 * s)
      ..close();

    canvas.drawPath(left, pageFill);
    canvas.drawPath(right, pageFill);
    canvas.drawPath(left, line);
    canvas.drawPath(right, line);

    canvas.drawLine(Offset(120 * s, 118 * s), Offset(120 * s, 160 * s), line);

    _drawPageText(canvas, s, line, from: 64, to: 106, y: 136);
    _drawPageText(canvas, s, line, from: 64, to: 106, y: 147);
    _drawPageText(canvas, s, line, from: 134, to: 176, y: 136);
    _drawPageText(canvas, s, line, from: 134, to: 176, y: 147);
  }

  void _drawPageText(
    Canvas canvas,
    double s,
    Paint line, {
    required double from,
    required double to,
    required double y,
  }) {
    final gap = (to - from) / 3;
    canvas.drawLine(
      Offset(from * s, y * s),
      Offset((from + gap) * s, y * s),
      line,
    );
    canvas.drawLine(Offset((to - gap) * s, y * s), Offset(to * s, y * s), line);
  }

  void _drawEmergence(Canvas canvas, double s, Paint line) {
    canvas.drawLine(Offset(120 * s, 164 * s), Offset(120 * s, 184 * s), line);
    canvas.drawCircle(
      Offset(120 * s, 192 * s),
      1.5 * s,
      Paint()..color = accent,
    );
  }

  void _drawCard(
    Canvas canvas, {
    required double s,
    required Offset center,
    required double tilt,
    required Paint paint,
    required _CardSymbol symbol,
  }) {
    canvas.save();
    canvas.translate(center.dx * s, center.dy * s);
    canvas.rotate(tilt);

    final card = Rect.fromCenter(
      center: Offset.zero,
      width: 40 * s,
      height: 52 * s,
    );
    final cardPaint = Paint()..color = AppColors.paper;
    canvas.drawRRect(
      RRect.fromRectAndRadius(card, Radius.circular(6 * s)),
      cardPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(card, Radius.circular(6 * s)),
      paint,
    );

    _drawSymbol(canvas, s, symbol);

    canvas.restore();
  }

  void _drawSymbol(Canvas canvas, double s, _CardSymbol symbol) {
    switch (symbol) {
      case _CardSymbol.summary:
        final paint = Paint()
          ..color = ink
          ..strokeWidth = 1.8 * s
          ..strokeCap = StrokeCap.round;
        for (var i = 0; i < 3; i++) {
          final width = switch (i) {
            0 => 18.0,
            1 => 13.0,
            _ => 15.0,
          };
          final y = (-2 + i * 8) * s;
          canvas.drawLine(
            Offset((-width / 2) * s, y),
            Offset((width / 2) * s, y),
            paint,
          );
        }
      case _CardSymbol.audio:
        final paint = Paint()
          ..color = ink
          ..strokeWidth = 2 * s
          ..strokeCap = StrokeCap.round;
        const bars = [4.0, 8.0, 12.0, 8.0, 4.0];
        for (var i = 0; i < bars.length; i++) {
          final x = (i - 2) * 5.5;
          final h = bars[i];
          canvas.drawLine(
            Offset(x * s, (12 - h) / 2 * s),
            Offset(x * s, (12 + h) / 2 * s),
            paint,
          );
        }
      case _CardSymbol.idea:
        final fill = Paint()..color = accent;
        final bulbCenter = Offset(0, -4 * s);
        canvas.drawCircle(bulbCenter, 5.5 * s, fill);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(0, 8 * s),
              width: 2.4 * s,
              height: 4 * s,
            ),
            Radius.circular(s),
          ),
          fill,
        );
        final ray = Paint()
          ..color = accent
          ..strokeWidth = 1.6 * s
          ..strokeCap = StrokeCap.round;
        for (final angle in [-0.9, -0.5, 0.5, 0.9]) {
          final dx = math.cos(angle);
          final dy = math.sin(angle);
          canvas.drawLine(
            bulbCenter + Offset(dx * 8 * s, dy * 8 * s),
            bulbCenter + Offset(dx * 10.5 * s, dy * 10.5 * s),
            ray,
          );
        }
    }
  }

  @override
  bool shouldRepaint(covariant _BookLearningIllustrationPainter oldDelegate) =>
      oldDelegate.ink != ink || oldDelegate.accent != accent;
}
