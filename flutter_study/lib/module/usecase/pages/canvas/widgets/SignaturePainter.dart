import 'package:flutter/material.dart';

/// 签名板绘制
class SignaturePainter extends CustomPainter {
  final List<List<Offset?>> strokes; // 笔画列表

  SignaturePainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      if (stroke.isEmpty) continue;

      final path = Path();
      bool isFirstPoint = true;

      for (final point in stroke) {
        if (point == null) {
          // null 表示抬笔
          isFirstPoint = true;
          continue;
        }

        if (isFirstPoint) {
          path.moveTo(point.dx, point.dy);
          isFirstPoint = false;
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) {
    return oldDelegate.strokes != strokes;
  }
}

