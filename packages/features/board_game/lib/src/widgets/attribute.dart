// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:math';

import 'package:flutter/material.dart';

class AttributeWidget extends StatelessWidget {
  const AttributeWidget({
    required this.size,
    required this.progress,
    this.child,
    required this.text,
    super.key,
  });
  final double size;
  final double progress;
  final Widget? child;
  final String text;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: AttributePainter(progressPercent: progress),
      child: Container(
        padding: EdgeInsets.all(size / 3.8),
        width: size,
        height: size,
        child: child,
      ),
    );
  }
}

class AttributePainter extends CustomPainter {
  final double progressPercent;
  final double strokeWidth;
  final double filledStrokeWidth;

  final bgPaint;
  final strokeBgPaint;
  final strokeFilledPaint;

  final Color color;

  AttributePainter({
    required this.progressPercent,
    this.color = Colors.red,
    this.strokeWidth = 4.0,
    this.filledStrokeWidth = 6.0,
  })  : bgPaint = Paint()..color = Colors.white.withAlpha((0.25 * 255).toInt()),
        strokeBgPaint = Paint()..color = color,
        strokeFilledPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = filledStrokeWidth
          ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawCircle(center, radius - strokeWidth, strokeBgPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - (strokeWidth / 2)),
      -pi / 2,
      (progressPercent / 100) * pi * 2,
      false,
      strokeFilledPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
