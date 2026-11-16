import 'package:flutter/material.dart';

class CustomGradientWidget extends StatelessWidget {
  const CustomGradientWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: GradientPainterTest(), child: Container(width: 100, height: 100, color: Colors.red));
  }
}

class GradientPainterTest extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..shader = LinearGradient(
            colors: [Colors.red, Colors.blue],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
