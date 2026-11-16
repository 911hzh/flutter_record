import 'dart:math';
import 'package:flutter/material.dart';

/// 仪表盘（类似汽车速度表）
class GaugePainter extends CustomPainter {
  final double value; // 当前值 0.0 到 1.0
  final String label;

  GaugePainter({required this.value, this.label = ''});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    // 绘制背景弧
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.8),
      pi * 0.75, // 起始角度
      pi * 1.5, // 扫描角度
      false,
      Paint()
        ..color = Colors.grey[300]!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20,
    );

    // 绘制渐变进度弧
    final progressAngle = pi * 1.5 * value;
    final rect = Rect.fromCircle(center: center, radius: radius * 0.8);

    canvas.drawArc(
      rect,
      pi * 0.75,
      progressAngle,
      false,
      Paint()
        ..shader = SweepGradient(
          colors: [Colors.green, Colors.yellow, Colors.red],
          startAngle: pi * 0.75,
          endAngle: pi * 2.25,
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20
        ..strokeCap = StrokeCap.round,
    );

    // 绘制刻度
    for (int i = 0; i <= 10; i++) {
      final angle = pi * 0.75 + (pi * 1.5 / 10) * i;
      final isMainScale = i % 2 == 0;
      final lineLength = isMainScale ? 15.0 : 8.0;
      final lineWidth = isMainScale ? 2.0 : 1.0;

      final startRadius = radius * 0.8 - 30;
      final endRadius = startRadius - lineLength;

      final startX = center.dx + startRadius * cos(angle);
      final startY = center.dy + startRadius * sin(angle);
      final endX = center.dx + endRadius * cos(angle);
      final endY = center.dy + endRadius * sin(angle);

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        Paint()
          ..color = Colors.black54
          ..strokeWidth = lineWidth,
      );
    }

    // 绘制指针
    final pointerAngle = pi * 0.75 + progressAngle;
    final pointerLength = radius * 0.6;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(pointerAngle);

    final pointerPath = Path()..moveTo(-5, 0)..lineTo(0, -pointerLength)..lineTo(5, 0)..close();

    canvas.drawPath(
      pointerPath,
      Paint()
        ..color = Colors.red
        ..style = PaintingStyle.fill,
    );

    canvas.restore();

    // 绘制中心圆点
    canvas.drawCircle(
      center,
      8,
      Paint()
        ..color = Colors.red
        ..style = PaintingStyle.fill,
    );

    // 绘制数值文字
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${(value * 100).toInt()}',
        style: TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(canvas, Offset(center.dx - textPainter.width / 2, center.dy + radius * 0.3));

    // 绘制标签
    if (label.isNotEmpty) {
      final labelPainter = TextPainter(
        text: TextSpan(text: label, style: TextStyle(color: Colors.black54, fontSize: 14)),
        textDirection: TextDirection.ltr,
      )..layout();

      labelPainter.paint(canvas, Offset(center.dx - labelPainter.width / 2, center.dy + radius * 0.5));
    }
  }

  @override
  bool shouldRepaint(GaugePainter oldDelegate) {
    return oldDelegate.value != value;
  }
}

