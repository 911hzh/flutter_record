import 'dart:math';
import 'package:flutter/material.dart';

/// 简单的折线图
class LineChartPainter extends CustomPainter {
  final List<double> dataPoints; // 数据点
  final Color lineColor;
  final Color areaColor;
  final bool showArea; // 是否显示区域填充

  LineChartPainter({
    required this.dataPoints,
    this.lineColor = Colors.blue,
    this.areaColor = Colors.blue,
    this.showArea = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    final maxValue = dataPoints.reduce(max);
    final minValue = dataPoints.reduce(min);
    final range = maxValue - minValue;

    // 创建路径
    final path = Path();
    final areaPath = Path();

    for (int i = 0; i < dataPoints.length; i++) {
      final x = (size.width / (dataPoints.length - 1)) * i;
      final normalizedValue = (dataPoints[i] - minValue) / range;
      final y = size.height - (normalizedValue * size.height * 0.8 + size.height * 0.1);

      if (i == 0) {
        path.moveTo(x, y);
        areaPath.moveTo(x, size.height);
        areaPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        areaPath.lineTo(x, y);
      }
    }

    // 绘制区域填充
    if (showArea) {
      areaPath.lineTo(size.width, size.height);
      areaPath.close();

      canvas.drawPath(
        areaPath,
        Paint()
          ..color = areaColor.withOpacity(0.3)
          ..style = PaintingStyle.fill,
      );
    }

    // 绘制折线
    canvas.drawPath(
      path,
      Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // 绘制数据点
    for (int i = 0; i < dataPoints.length; i++) {
      final x = (size.width / (dataPoints.length - 1)) * i;
      final normalizedValue = (dataPoints[i] - minValue) / range;
      final y = size.height - (normalizedValue * size.height * 0.8 + size.height * 0.1);

      // 外圈
      canvas.drawCircle(
        Offset(x, y),
        5,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill,
      );

      // 内圈
      canvas.drawCircle(
        Offset(x, y),
        3,
        Paint()
          ..color = lineColor
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(LineChartPainter oldDelegate) {
    return oldDelegate.dataPoints != dataPoints;
  }
}

