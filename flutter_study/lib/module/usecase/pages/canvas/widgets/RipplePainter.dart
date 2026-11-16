import 'dart:math';
import 'package:flutter/material.dart';

/// 水波纹扩散动画
class RipplePainter extends CustomPainter {
  final double progress; // 0.0 到 1.0
  final Color color;
  final int rippleCount;

  RipplePainter({required this.progress, this.color = Colors.blue, this.rippleCount = 3});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = min(size.width, size.height) / 2;

    for (int i = 0; i < rippleCount; i++) {
      final delay = i / rippleCount;
      double rippleProgress = (progress - delay) % 1.0;
      if (rippleProgress < 0) rippleProgress = 0;

      final radius = maxRadius * rippleProgress;
      final opacity = 1.0 - rippleProgress;

      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = color.withOpacity(opacity * 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    }
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

