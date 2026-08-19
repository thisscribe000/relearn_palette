import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/learning_bite.dart';

/// Editorial line-art illustration displayed at the top of a Learning Bite.
///
/// Drawn on a 240x240 design grid with [AppColors.primaryGreen] linework and
/// small muted-gold accent dots, matching the onboarding illustration style.
class LearningBiteIllustration extends StatelessWidget {
  const LearningBiteIllustration({
    super.key,
    required this.visual,
    this.size = 200,
    this.ink = AppColors.primaryGreen,
    this.accent = AppColors.mutedGold,
  });

  final BiteVisual visual;
  final double size;
  final Color ink;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _LearningBiteIllustrationPainter(visual, ink, accent),
    );
  }
}

class _LearningBiteIllustrationPainter extends CustomPainter {
  const _LearningBiteIllustrationPainter(this.visual, this.ink, this.accent);

  final BiteVisual visual;
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
    final thin = Paint()
      ..color = ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3 * s
      ..strokeCap = StrokeCap.round;
    final dot = Paint()
      ..color = ink
      ..style = PaintingStyle.fill;
    final fill = Paint()
      ..color = accent
      ..style = PaintingStyle.fill;

    switch (visual) {
      case BiteVisual.observe:
        _paintObserve(canvas, s, line, thin, fill);
      case BiteVisual.control:
        _paintControl(canvas, s, line, fill);
      case BiteVisual.wonder:
        _paintWonder(canvas, s, line, dot, fill);
    }
  }

  void _paintObserve(
    Canvas canvas,
    double s,
    Paint line,
    Paint thin,
    Paint fill,
  ) {
    final baseline = 194 * s;
    canvas
      ..drawLine(Offset(66 * s, baseline), Offset(174 * s, baseline), line)
      ..drawLine(Offset(120 * s, 176 * s), Offset(120 * s, baseline), line)
      ..drawPath(
        Path()
          ..moveTo(66 * s, baseline)
          ..quadraticBezierTo(66 * s, 166 * s, 120 * s, 176 * s),
        line,
      )
      ..drawPath(
        Path()
          ..moveTo(120 * s, 176 * s)
          ..quadraticBezierTo(174 * s, 166 * s, 174 * s, baseline),
        line,
      );

    final lens = Offset(148 * s, 112 * s);
    final radius = 44 * s;
    canvas
      ..drawCircle(lens, radius, line)
      ..drawLine(
        Offset(lens.dx - radius, lens.dy),
        Offset(lens.dx + radius, lens.dy),
        thin,
      )
      ..drawLine(
        Offset(lens.dx, lens.dy - radius),
        Offset(lens.dx, lens.dy + radius),
        thin,
      )
      ..drawLine(
        Offset(184 * s, 134 * s),
        Offset(212 * s, 166 * s),
        line..strokeWidth = 4.5 * s,
      )
      ..drawCircle(lens, 6 * s, fill)
      ..drawCircle(Offset(74 * s, 116 * s), 3 * s, fill)
      ..drawCircle(Offset(210 * s, 100 * s), 3 * s, fill);
  }

  void _paintControl(Canvas canvas, double s, Paint line, Paint fill) {
    final cx = 120 * s;
    final cy = 118 * s;
    canvas
      ..drawCircle(Offset(cx, cy), 62 * s, line)
      ..drawCircle(
        Offset(cx, cy),
        40 * s,
        Paint()
          ..color = ink
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6 * s,
      );

    void arrow(Offset tail, Offset head) {
      final angle = (head - tail).direction;
      canvas.drawLine(tail, head, line);
      canvas.drawLine(
        head - Offset.fromDirection(angle + 0.35, 9 * s),
        head,
        line,
      );
      canvas.drawLine(
        head - Offset.fromDirection(angle - 0.35, 9 * s),
        head,
        line,
      );
    }

    arrow(Offset(cx + 64 * s, cy), Offset(cx + 48 * s, cy));
    arrow(Offset(cx - 64 * s, cy), Offset(cx - 48 * s, cy));
    arrow(Offset(cx, cy - 64 * s), Offset(cx, cy - 48 * s));
    arrow(Offset(cx, cy + 64 * s), Offset(cx, cy + 48 * s));

    canvas.drawCircle(Offset(cx, cy), 5.5 * s, fill);
  }

  void _paintWonder(
    Canvas canvas,
    double s,
    Paint line,
    Paint dot,
    Paint fill,
  ) {
    final archCenter = Offset(120 * s, 168 * s);
    final archRadius = 36 * s;
    final arch = Path()
      ..addArc(
        Rect.fromCircle(center: archCenter, radius: archRadius),
        math.pi,
        math.pi,
      );
    canvas
      ..drawPath(arch, line)
      ..drawLine(
        Offset(archCenter.dx - archRadius, archCenter.dy),
        Offset(archCenter.dx - archRadius, archCenter.dy + 24 * s),
        line,
      )
      ..drawLine(
        Offset(archCenter.dx + archRadius, archCenter.dy),
        Offset(archCenter.dx + archRadius, archCenter.dy + 24 * s),
        line,
      )
      ..drawLine(
        Offset(archCenter.dx - archRadius - 4 * s, archCenter.dy + 24 * s),
        Offset(archCenter.dx + archRadius + 4 * s, archCenter.dy + 24 * s),
        line,
      );

    final pathToDoor = Path()
      ..moveTo(52 * s, 214 * s)
      ..cubicTo(52 * s, 180 * s, 80 * s, 176 * s, 102 * s, 158 * s);
    canvas.drawPath(_dotted(pathToDoor, s), dot);

    final pathBeyond = Path()
      ..moveTo(102 * s, 158 * s)
      ..cubicTo(126 * s, 138 * s, 150 * s, 126 * s, 180 * s, 84 * s);
    canvas.drawPath(_dotted(pathBeyond, s), dot);

    final tip = Offset(180 * s, 84 * s);
    canvas
      ..drawCircle(tip, 5 * s, fill)
      ..drawCircle(Offset(tip.dx + 11 * s, tip.dy - 7 * s), 2.6 * s, fill);
  }

  /// Re-strokes [path] as a sequence of small filled dots.
  Path _dotted(Path path, double s) {
    final dotted = Path()..fillType = PathFillType.nonZero;
    final spacing = 5 * s;
    final radius = 2 * s;
    for (final metric in path.computeMetrics()) {
      final length = metric.length;
      for (var d = 3 * s; d < length; d += spacing) {
        final tangent = metric.getTangentForOffset(d);
        if (tangent != null) {
          dotted.addOval(
            Rect.fromCircle(center: tangent.position, radius: radius),
          );
        }
      }
    }
    return dotted;
  }

  @override
  bool shouldRepaint(covariant _LearningBiteIllustrationPainter oldDelegate) =>
      oldDelegate.visual != visual ||
      oldDelegate.ink != ink ||
      oldDelegate.accent != accent;
}
