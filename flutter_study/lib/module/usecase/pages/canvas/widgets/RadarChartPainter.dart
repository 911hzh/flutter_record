import 'dart:math';
import 'package:flutter/material.dart';

/// 雷达图（蜘蛛网图）
class RadarChartPainter extends CustomPainter {
  final List<double> values; // 各维度的值，0.0 到 1.0
  final List<String> labels; // 各维度的标签
  final int sides;
  final Color color;

  RadarChartPainter({required this.values, required this.labels, this.sides = 5, this.color = Colors.blue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 * 0.7;

    // 绘制背景网格
    _drawBackgroundWeb(canvas, center, radius);

    // 绘制数据区域
    _drawDataArea(canvas, center, radius);

    // 绘制标签
    _drawLabels(canvas, center, radius);
  }

  void _drawBackgroundWeb(Canvas canvas, Offset center, double radius) {
    final paint = Paint()..color = Colors.grey[300]!..style = PaintingStyle.stroke..strokeWidth = 1;

    // 绘制同心多边形
    for (int level = 1; level <= 5; level++) {
      final levelRadius = radius * level / 5;
      final path = _createPolygonPath(center, levelRadius);
      canvas.drawPath(path, paint);
    }

    // 绘制从中心到各顶点的线
    for (int i = 0; i < sides; i++) {
      final angle = -pi / 2 + (2 * pi / sides) * i;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      canvas.drawLine(center, Offset(x, y), paint);
    }
  }

  void _drawDataArea(Canvas canvas, Offset center, double radius) {
    final path = Path();

    for (int i = 0; i < values.length; i++) {
      final angle = -pi / 2 + (2 * pi / sides) * i;
      final r = radius * values[i];
      final x = center.dx + r * cos(angle);
      final y = center.dy + r * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    // 绘制填充区域
    canvas.drawPath(
      path,
      Paint()
        ..color = color.withOpacity(0.3)
        ..style = PaintingStyle.fill,
    );

    // 绘制边线
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // 绘制数据点
    for (int i = 0; i < values.length; i++) {
      final angle = -pi / 2 + (2 * pi / sides) * i;
      final r = radius * values[i];
      final x = center.dx + r * cos(angle);
      final y = center.dy + r * sin(angle);

      canvas.drawCircle(
        Offset(x, y),
        4,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill,
      );
    }
  }

  void _drawLabels(Canvas canvas, Offset center, double radius) {
    for (int i = 0; i < labels.length; i++) {
      final angle = -pi / 2 + (2 * pi / sides) * i;
      final x = center.dx + (radius + 30) * cos(angle);
      final y = center.dy + (radius + 30) * sin(angle);

      final textPainter = TextPainter(
        text: TextSpan(text: labels[i], style: TextStyle(color: Colors.black, fontSize: 12)),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout();

      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
    }
  }

  Path _createPolygonPath(Offset center, double radius) {
    final path = Path();
    for (int i = 0; i < sides; i++) {
      final angle = -pi / 2 + (2 * pi / sides) * i;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(RadarChartPainter oldDelegate) => true;
}

