import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Canvas绘制示例页面
class CanvasPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);
    final animationController = useAnimationController(duration: Duration(seconds: 2))..repeat();

    return Scaffold(
      appBar: AppBar(title: Text('Flutter 自定义绘制示例'), backgroundColor: Colors.blue),
      body: Column(
        children: [
          // 选项卡
          _buildTabBar(selectedIndex),
          // 内容区域
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: Center(child: _buildContent(selectedIndex.value, animationController)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(ValueNotifier<int> selectedIndex) {
    final tabs = ['基础图形', '路径绘制', '文字&渐变', '动画绘制', 'CheckSize'];
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex.value == index;
          return GestureDetector(
            onTap: () => selectedIndex.value = index,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: isSelected ? Colors.blue : Colors.transparent, width: 2)),
              ),
              child: Text(
                tabs[index],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.blue : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(int index, AnimationController controller) {
    switch (index) {
      case 0:
        return CustomPaint(size: Size(300, 300), painter: BasicShapesPainter());
      case 1:
        return CustomPaint(size: Size(300, 300), painter: PathPainter());
      case 2:
        return CustomPaint(size: Size(300, 300), painter: TextAndGradientPainter());
      case 3:
        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return CustomPaint(size: Size(300, 300), painter: AnimatedPainter(controller.value));
          },
        );
      case 4:
        return Container(
          color: Colors.red,
          width: 300,
          height: 300,
          child: Column(
            children: [
              Expanded(
                child: CustomPaint(
                  size: Size(300, 300),
                  painter: CheckSizePainter(text: 'Hello, World!'),
                ),
              ),
              Opacity(opacity: 0.5, child: Container(width: 200, height: 200, color: Colors.black)),
            ],
          ),
        );
      default:
        return Container();
    }
  }
}

/// 1. 基础图形绘制示例
class BasicShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 绘制背景
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = Colors.white);

    // 1. 绘制圆形（空心）
    canvas.drawCircle(
      Offset(size.width * 0.25, size.height * 0.25),
      40,
      Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // 2. 绘制实心圆
    canvas.drawCircle(
      Offset(size.width * 0.75, size.height * 0.25),
      40,
      Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.fill,
    );

    // 3. 绘制矩形
    canvas.drawRect(
      Rect.fromCenter(center: Offset(size.width * 0.25, size.height * 0.5), width: 80, height: 60),
      Paint()
        ..color = Colors.green
        ..style = PaintingStyle.fill,
    );

    // 4. 绘制圆角矩形
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(size.width * 0.75, size.height * 0.5), width: 80, height: 60),
        Radius.circular(10),
      ),
      Paint()
        ..color = Colors.orange
        ..style = PaintingStyle.fill,
    );

    // 5. 绘制直线
    canvas.drawLine(
      Offset(50, size.height * 0.75),
      Offset(size.width - 50, size.height * 0.75),
      Paint()
        ..color = Colors.purple
        ..strokeWidth = 4,
    );

    // 6. 绘制弧线
    canvas.drawArc(
      Rect.fromCenter(center: Offset(size.width * 0.5, size.height * 0.85), width: 100, height: 100),
      0,
      pi,
      false,
      Paint()
        ..color = Colors.teal
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(BasicShapesPainter oldDelegate) => false;
}

/// 2. 路径绘制示例
class PathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = Colors.white);

    // 1. 绘制直线路径
    Path straightPath = Path()
      ..moveTo(50, 50)
      ..lineTo(size.width - 50, 50)
      ..lineTo(size.width - 50, 100)
      ..lineTo(50, 100)
      ..close();

    canvas.drawPath(
      straightPath,
      Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // 2. 绘制贝塞尔曲线
    Path curvePath = Path()
      ..moveTo(50, 150)
      ..quadraticBezierTo(
        size.width / 2,
        100, // 控制点
        size.width - 50,
        150, // 终点
      );

    canvas.drawPath(
      curvePath,
      Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // 3. 绘制三次贝塞尔曲线
    Path cubicPath = Path()
      ..moveTo(50, 200)
      ..cubicTo(
        100,
        150, // 第一个控制点
        200,
        250, // 第二个控制点
        size.width - 50,
        200, // 终点
      );

    canvas.drawPath(
      cubicPath,
      Paint()
        ..color = Colors.green
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // 4. 绘制波浪线
    Path wavePath = Path()..moveTo(0, size.height * 0.7);

    for (double i = 0; i <= size.width; i++) {
      wavePath.lineTo(i, size.height * 0.7 + sin(i / 20) * 20);
    }

    canvas.drawPath(
      wavePath,
      Paint()
        ..color = Colors.purple
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(PathPainter oldDelegate) => false;
}

/// 3. 文字和渐变绘制示例
class TextAndGradientPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = Colors.white);

    // 1. 线性渐变
    Paint linearGradient = Paint()
      ..shader = LinearGradient(
        colors: [Colors.red, Colors.yellow, Colors.blue],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(50, 20, 200, 80));

    canvas.drawRect(Rect.fromLTWH(50, 20, 200, 80), linearGradient);

    // 2. 径向渐变
    Paint radialGradient = Paint()
      ..shader = RadialGradient(
        colors: [Colors.purple, Colors.pink, Colors.white],
        center: Alignment.center,
      ).createShader(Rect.fromCircle(center: Offset(size.width * 0.5, 180), radius: 60));

    canvas.drawCircle(Offset(size.width * 0.5, 180), 60, radialGradient);

    // 3. 绘制文字
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: 'Flutter 自定义绘制',
        style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(canvas, Offset((size.width - textPainter.width) / 2, size.height * 0.65));

    // 4. 阴影效果
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.85),
      40,
      Paint()
        ..color = Colors.blue
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10),
    );
  }

  @override
  bool shouldRepaint(TextAndGradientPainter oldDelegate) => false;
}

/// 4. 动画绘制示例
class AnimatedPainter extends CustomPainter {
  final double progress;

  AnimatedPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = Colors.white);

    final center = Offset(size.width / 2, size.height / 2);

    // 1. 旋转的矩形
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(progress * 2 * pi);
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: 100, height: 100),
      Paint()
        ..color = Colors.blue.withOpacity(0.5)
        ..style = PaintingStyle.fill,
    );
    canvas.restore();

    // 2. 脉动的圆
    final radius = 30 + sin(progress * 2 * pi) * 20;
    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.3),
      radius,
      Paint()
        ..color = Colors.red.withOpacity(0.6)
        ..style = PaintingStyle.fill,
    );

    // 3. 进度条
    final progressRect = Rect.fromLTWH(50, size.height - 80, (size.width - 100) * progress, 20);

    canvas.drawRect(
      Rect.fromLTWH(50, size.height - 80, size.width - 100, 20),
      Paint()
        ..color = Colors.grey[300]!
        ..style = PaintingStyle.fill,
    );

    canvas.drawRect(
      progressRect,
      Paint()..shader = LinearGradient(colors: [Colors.green, Colors.blue]).createShader(progressRect),
    );

    // 4. 移动的圆
    final moveX = 50 + (size.width - 100) * progress;
    canvas.drawCircle(Offset(moveX, size.height * 0.7), 15, Paint()..color = Colors.orange);
  }

  @override
  bool shouldRepaint(AnimatedPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class CheckSizePainter extends CustomPainter {
  final String text;
  CheckSizePainter({required this.text});
  @override
  void paint(Canvas canvas, Size size) {
    // canvas.drawColor(Colors.blue, BlendMode.src);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = Colors.lightGreen);
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width);
    textPainter.paint(canvas, Offset(0, 0));
  }

  @override
  bool shouldRepaint(CheckSizePainter oldDelegate) {
    return oldDelegate.text != text;
  }
}
