import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Editorial illustration for the final onboarding screen, drawing the
/// READ → LEARN → REMEMBER journey in the same hand as
/// [BookLearningIllustration]: an open book, a single rising card, and
/// a small dashed loop (recall/repetition) that returns to the book.
///
/// Pure Flutter drawing, scaled from a 240 × 240 design grid so it
/// works at any [size] without external image assets.
class ReadingJourneyIllustration extends StatelessWidget {
  const ReadingJourneyIllustration({
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
      painter: _ReadingJourneyIllustrationPainter(ink: ink, accent: accent),
    );
  }
}

class _ReadingJourneyIllustrationPainter extends CustomPainter {
  _ReadingJourneyIllustrationPainter({required this.ink, required this.accent});

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
    _drawRise(canvas, s);
    _drawCard(canvas, s: s, paint: cardLine);
    _drawRecallLoop(canvas, s, line);
  }

  void _drawBook(Canvas canvas, double s, Paint line) {
    final pageFill = Paint()..color = AppColors.paper;

    final left = Path()
      ..moveTo(120 * s, 122 * s)
      ..cubicTo(84 * s, 120 * s, 56 * s, 126 * s, 44 * s, 136 * s)
      ..cubicTo(40 * s, 143 * s, 40 * s, 152 * s, 46 * s, 158 * s)
      ..cubicTo(70 * s, 164 * s, 100 * s, 162 * s, 120 * s, 160 * s)
      ..close();
    final right = Path()
      ..moveTo(120 * s, 122 * s)
      ..cubicTo(156 * s, 120 * s, 184 * s, 126 * s, 196 * s, 136 * s)
      ..cubicTo(200 * s, 143 * s, 200 * s, 152 * s, 194 * s, 158 * s)
      ..cubicTo(170 * s, 164 * s, 140 * s, 162 * s, 120 * s, 160 * s)
      ..close();

    canvas.drawPath(left, pageFill);
    canvas.drawPath(right, pageFill);
    canvas.drawPath(left, line);
    canvas.drawPath(right, line);

    canvas.drawLine(Offset(120 * s, 122 * s), Offset(120 * s, 160 * s), line);

    _drawPageText(canvas, s, line, from: 62, to: 108, y: 138);
    _drawPageText(canvas, s, line, from: 62, to: 108, y: 149);
    _drawPageText(canvas, s, line, from: 132, to: 178, y: 138);
    _drawPageText(canvas, s, line, from: 132, to: 178, y: 149);
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

  void _drawRise(Canvas canvas, double s) {
    final dot = Paint()..color = accent;
    for (var i = 0; i < 3; i++) {
      canvas.drawCircle(Offset(120 * s, (172 + i * 7) * s), 1.3 * s, dot);
    }
  }

  void _drawCard(Canvas canvas, {required double s, required Paint paint}) {
    canvas.save();
    canvas.translate(120 * s, 78 * s);
    canvas.rotate(-0.06);

    final card = Rect.fromCenter(
      center: Offset.zero,
      width: 42 * s,
      height: 54 * s,
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

    final textPaint = Paint()
      ..color = ink
      ..strokeWidth = 1.8 * s
      ..strokeCap = StrokeCap.round;
    const widths = [19.0, 13.0, 15.0];
    for (var i = 0; i < widths.length; i++) {
      final width = widths[i];
      final y = (-2 + i * 8) * s;
      canvas.drawLine(
        Offset((-width / 2) * s, y),
        Offset((width / 2) * s, y),
        textPaint,
      );
    }

    canvas.drawCircle(Offset(14 * s, -16 * s), 2 * s, Paint()..color = accent);

    canvas.restore();
  }

  void _drawRecallLoop(Canvas canvas, double s, Paint line) {
    final start = Offset(176 * s, 96 * s);
    final end = Offset(186 * s, 138 * s);

    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(210 * s, 96 * s, 216 * s, 128 * s, end.dx, end.dy);

    _drawDashed(canvas, path, line, dashOn: 5 * s, dashOff: 4 * s);

    final tip = Offset(192 * s, 118 * s);
    canvas.drawCircle(tip, 2 * s, Paint()..color = accent);
  }

  void _drawDashed(
    Canvas canvas,
    Path path,
    Paint paint, {
    required double dashOn,
    required double dashOff,
  }) {
    final metric = path.computeMetrics().first;
    var distance = 0.0;
    while (distance < metric.length) {
      final end = math.min(distance + dashOn, metric.length);
      canvas.drawPath(metric.extractPath(distance, end), paint);
      distance = end + dashOff;
    }
  }

  @override
  bool shouldRepaint(
    covariant _ReadingJourneyIllustrationPainter oldDelegate,
  ) => oldDelegate.ink != ink || oldDelegate.accent != accent;
}
