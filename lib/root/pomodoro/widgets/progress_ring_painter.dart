import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/pomodoro_settings.dart';

// رسام حلقة التقدم
class ProgressRingPainter extends CustomPainter {
  final double progress;
  final bool isActive;
  final TimerMode mode;

  ProgressRingPainter({
    required this.progress,
    required this.isActive,
    required this.mode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // رسم الحلقة الخلفية
    final backgroundPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, backgroundPaint);

    // رسم حلقة التقدم
    final progressPaint = Paint()
      ..color = mode == TimerMode.work
          ? const Color(0xFFFF6B6B)
          : const Color(0xFF4ECDC4)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 
