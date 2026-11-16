# Flutter 自定义绘制完全指南 - 从入门到实战

## 前言

在Flutter开发中，我们经常需要实现一些自定义的UI效果，比如绘制图表、实现特殊的动画效果、创建独特的UI组件等。这时候，Flutter的自定义绘制功能就显得尤为重要。

本文将通过一个完整的示例项目，带你深入了解Flutter的自定义绘制机制，包括基础图形绘制、路径操作、渐变效果以及动画实现。

## 一、自定义绘制的核心概念

### 1.1 CustomPaint 组件

`CustomPaint` 是Flutter提供的一个强大的组件，允许我们在画布上进行自定义绘制。它的基本用法如下：

```dart
CustomPaint(
  size: Size(300, 300),  // 指定画布大小
  painter: MyPainter(),  // 自定义的绘制器
)
```

### 1.2 CustomPainter 类

`CustomPainter` 是一个抽象类，我们需要继承它并实现两个核心方法：

```dart
class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 在这里进行绘制操作
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // 决定是否需要重绘
    return false;
  }
}
```

- **paint()**: 实际的绘制逻辑在这里实现
- **shouldRepaint()**: 返回true时会触发重绘，用于性能优化

### 1.3 核心绘制工具

- **Canvas**: 画布对象，提供各种绘制方法
- **Paint**: 画笔对象，定义绘制的样式（颜色、粗细、填充方式等）
- **Path**: 路径对象，用于绘制复杂的图形

## 二、基础图形绘制

### 2.1 绘制圆形

圆形是最基础的图形之一，分为空心和实心两种：

```dart
// 绘制空心圆
canvas.drawCircle(
  Offset(100, 100),  // 圆心位置
  40,                // 半径
  Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke  // 空心
    ..strokeWidth = 3,              // 线条粗细
);

// 绘制实心圆
canvas.drawCircle(
  Offset(200, 100),
  40,
  Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.fill,  // 实心
);
```

**关键点：**
- `Offset` 用于指定坐标位置
- `PaintingStyle.stroke` 表示空心，`PaintingStyle.fill` 表示实心
- `strokeWidth` 只在空心模式下有效

### 2.2 绘制矩形

```dart
// 绘制普通矩形
canvas.drawRect(
  Rect.fromCenter(
    center: Offset(100, 200),
    width: 80,
    height: 60,
  ),
  Paint()..color = Colors.green,
);

// 绘制圆角矩形
canvas.drawRRect(
  RRect.fromRectAndRadius(
    Rect.fromCenter(
      center: Offset(200, 200),
      width: 80,
      height: 60,
    ),
    Radius.circular(10),  // 圆角半径
  ),
  Paint()..color = Colors.orange,
);
```

**Rect的创建方式：**
- `Rect.fromLTWH(left, top, width, height)` - 从左上角开始
- `Rect.fromCenter(center, width, height)` - 从中心点开始
- `Rect.fromPoints(p1, p2)` - 从两个点定义

### 2.3 绘制直线和弧线

```dart
// 绘制直线
canvas.drawLine(
  Offset(50, 300),      // 起点
  Offset(250, 300),     // 终点
  Paint()
    ..color = Colors.purple
    ..strokeWidth = 4,
);

// 绘制弧线
canvas.drawArc(
  Rect.fromCenter(
    center: Offset(150, 350),
    width: 100,
    height: 100,
  ),
  0,        // 起始角度（弧度）
  pi,       // 扫过的角度（弧度）
  false,    // 是否使用中心点
  Paint()
    ..color = Colors.teal
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3,
);
```

**注意事项：**
- 角度使用弧度制，需要 `import 'dart:math'`
- `pi` 表示180度，`2 * pi` 表示360度
- `drawArc` 的 `useCenter` 参数为 `true` 时会绘制扇形

## 三、路径绘制

### 3.1 直线路径

```dart
Path straightPath = Path()
  ..moveTo(50, 50)              // 移动到起点
  ..lineTo(250, 50)             // 画线到这个点
  ..lineTo(250, 100)
  ..lineTo(50, 100)
  ..close();                    // 闭合路径

canvas.drawPath(
  straightPath,
  Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2,
);
```

### 3.2 贝塞尔曲线

贝塞尔曲线是绘制平滑曲线的关键：

**二次贝塞尔曲线：**
```dart
Path curvePath = Path()
  ..moveTo(50, 150)
  ..quadraticBezierTo(
    150, 100,  // 控制点
    250, 150,  // 终点
  );

canvas.drawPath(curvePath, Paint()..color = Colors.blue..strokeWidth = 3);
```

**三次贝塞尔曲线：**
```dart
Path cubicPath = Path()
  ..moveTo(50, 200)
  ..cubicTo(
    100, 150,  // 第一个控制点
    200, 250,  // 第二个控制点
    250, 200,  // 终点
  );

canvas.drawPath(cubicPath, Paint()..color = Colors.green..strokeWidth = 3);
```

**应用场景：**
- 二次贝塞尔曲线适合绘制简单的弧形
- 三次贝塞尔曲线可以创建更复杂的S形曲线
- 常用于波浪效果、图表曲线等

### 3.3 绘制波浪线

```dart
Path wavePath = Path()..moveTo(0, 200);

for (double i = 0; i <= 300; i++) {
  wavePath.lineTo(
    i,
    200 + sin(i / 20) * 20,  // 使用正弦函数创建波浪
  );
}

canvas.drawPath(wavePath, Paint()..color = Colors.purple..strokeWidth = 2);
```

## 四、高级效果

### 4.1 线性渐变

```dart
Paint linearGradient = Paint()
  ..shader = LinearGradient(
    colors: [Colors.red, Colors.yellow, Colors.blue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ).createShader(Rect.fromLTWH(50, 20, 200, 80));

canvas.drawRect(
  Rect.fromLTWH(50, 20, 200, 80),
  linearGradient,
);
```

### 4.2 径向渐变

```dart
Paint radialGradient = Paint()
  ..shader = RadialGradient(
    colors: [Colors.purple, Colors.pink, Colors.white],
    center: Alignment.center,
  ).createShader(Rect.fromCircle(
    center: Offset(150, 180),
    radius: 60,
  ));

canvas.drawCircle(Offset(150, 180), 60, radialGradient);
```

### 4.3 绘制文字

```dart
TextPainter textPainter = TextPainter(
  text: TextSpan(
    text: 'Flutter 自定义绘制',
    style: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  textDirection: TextDirection.ltr,
)..layout();  // 必须调用layout()

textPainter.paint(
  canvas,
  Offset(50, 250),  // 文字位置
);
```

**重要提示：**
- 使用 `TextPainter` 而不是直接在 Canvas 上绘制文字
- 必须先调用 `layout()` 方法
- 可以通过 `textPainter.width` 和 `textPainter.height` 获取文字尺寸

### 4.4 阴影和模糊效果

```dart
canvas.drawCircle(
  Offset(150, 300),
  40,
  Paint()
    ..color = Colors.blue
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10),  // 模糊效果
);
```

## 五、动画绘制

### 5.1 实现动画的基本步骤

1. 创建 `AnimationController`
2. 在 `CustomPainter` 中接收动画值
3. 在 `shouldRepaint` 中返回 `true`
4. 使用 `AnimatedBuilder` 触发重绘

### 5.2 完整示例

```dart
class AnimatedWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: Duration(seconds: 2),
    )..repeat();

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(300, 300),
          painter: AnimatedPainter(controller.value),
        );
      },
    );
  }
}

class AnimatedPainter extends CustomPainter {
  final double progress;

  AnimatedPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // 旋转的矩形
    canvas.save();  // 保存画布状态
    canvas.translate(center.dx, center.dy);  // 平移
    canvas.rotate(progress * 2 * pi);        // 旋转
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: 100, height: 100),
      Paint()..color = Colors.blue.withOpacity(0.5),
    );
    canvas.restore();  // 恢复画布状态
  }

  @override
  bool shouldRepaint(AnimatedPainter oldDelegate) {
    return oldDelegate.progress != progress;  // 动画时必须返回true
  }
}
```

### 5.3 常见动画效果

**脉动效果：**
```dart
final radius = 30 + sin(progress * 2 * pi) * 20;
canvas.drawCircle(center, radius, Paint()..color = Colors.red);
```

**移动效果：**
```dart
final x = 50 + (width - 100) * progress;
canvas.drawCircle(Offset(x, y), 15, Paint()..color = Colors.orange);
```

**渐变透明度：**
```dart
final opacity = (sin(progress * 2 * pi) + 1) / 2;  // 0 到 1
Paint()..color = Colors.blue.withOpacity(opacity)
```

## 六、性能优化技巧

### 6.1 合理使用 shouldRepaint

```dart
@override
bool shouldRepaint(MyPainter oldDelegate) {
  // 只有在实际需要更新时才返回true
  return oldDelegate.someValue != someValue;
}
```

### 6.2 避免在 paint 方法中创建对象

❌ **不推荐：**
```dart
void paint(Canvas canvas, Size size) {
  // 每次绘制都创建新对象，影响性能
  final paint = Paint()..color = Colors.red;
  canvas.drawCircle(Offset(100, 100), 50, paint);
}
```

✅ **推荐：**
```dart
class MyPainter extends CustomPainter {
  final Paint _paint = Paint()..color = Colors.red;  // 复用对象

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(100, 100), 50, _paint);
  }
}
```

### 6.3 使用 Canvas.saveLayer 时要谨慎

`saveLayer` 会创建离屏缓冲区，开销较大，只在必要时使用。

### 6.4 缓存复杂路径

```dart
class MyPainter extends CustomPainter {
  Path? _cachedPath;

  Path _getPath(Size size) {
    if (_cachedPath == null) {
      _cachedPath = Path();
      // 创建复杂路径...
    }
    return _cachedPath!;
  }
}
```

## 七、实战案例分析

### 7.1 绘制进度条

```dart
class ProgressPainter extends CustomPainter {
  final double progress;  // 0.0 到 1.0

  ProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    // 背景
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.grey[300]!,
    );

    // 进度
    final progressRect = Rect.fromLTWH(
      0,
      0,
      size.width * progress,
      size.height,
    );

    canvas.drawRect(
      progressRect,
      Paint()
        ..shader = LinearGradient(
          colors: [Colors.blue, Colors.purple],
        ).createShader(progressRect),
    );
  }

  @override
  bool shouldRepaint(ProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
```

### 7.2 绘制饼图

```dart
class PieChartPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;

  PieChartPainter(this.values, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    final total = values.reduce((a, b) => a + b);

    double startAngle = -pi / 2;  // 从顶部开始

    for (int i = 0; i < values.length; i++) {
      final sweepAngle = (values[i] / total) * 2 * pi;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,  // useCenter: true 绘制扇形
        Paint()..color = colors[i],
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) => true;
}
```

### 7.3 绘制虚线

```dart
void drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
  const dashWidth = 5;
  const dashSpace = 3;
  
  double distance = (end - start).distance;
  double normalizedDistance = 0;

  while (normalizedDistance < distance) {
    double startX = start.dx + (end.dx - start.dx) * (normalizedDistance / distance);
    double startY = start.dy + (end.dy - start.dy) * (normalizedDistance / distance);
    
    normalizedDistance += dashWidth;
    
    double endX = start.dx + (end.dx - start.dx) * (normalizedDistance / distance);
    double endY = start.dy + (end.dy - start.dy) * (normalizedDistance / distance);
    
    canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    
    normalizedDistance += dashSpace;
  }
}
```

## 八、常见问题和解决方案

### 8.1 为什么图形绘制不出来？

**可能的原因：**
1. Canvas 的 size 为 0
2. Paint 的颜色和背景相同
3. 坐标超出了画布范围
4. 没有调用 `shouldRepaint` 或返回了 `false`

**解决方案：**
```dart
// 打印调试信息
void paint(Canvas canvas, Size size) {
  print('Canvas size: $size');  // 检查尺寸
  // ...
}
```

### 8.2 如何实现触摸交互？

重写 `hitTest` 方法：

```dart
@override
bool hitTest(Offset position) {
  // 判断触摸点是否在特定区域内
  final rect = Rect.fromLTWH(50, 50, 100, 100);
  return rect.contains(position);
}
```

然后在 Widget 中使用：

```dart
GestureDetector(
  onTapDown: (details) {
    // 获取触摸位置
    final position = details.localPosition;
    // 处理点击事件
  },
  child: CustomPaint(
    painter: MyPainter(),
  ),
)
```

### 8.3 如何绘制图片？

```dart
class ImagePainter extends CustomPainter {
  final ui.Image image;

  ImagePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image, Offset.zero, Paint());
    
    // 或者绘制到指定矩形区域
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint(),
    );
  }

  @override
  bool shouldRepaint(ImagePainter oldDelegate) => false;
}
```

## 九、总结

Flutter的自定义绘制功能强大而灵活，掌握以下几点即可应对大部分场景：

1. **基础图形**: 圆形、矩形、线条、弧线
2. **路径操作**: moveTo、lineTo、贝塞尔曲线
3. **Paint属性**: 颜色、样式（填充/描边）、粗细、渐变
4. **Canvas变换**: translate、rotate、scale、save/restore
5. **性能优化**: 合理使用shouldRepaint、避免创建临时对象
6. **动画实现**: AnimationController + AnimatedBuilder

通过本文的示例代码和实战案例，你应该能够独立完成各种自定义绘制需求。建议多动手实践，从简单的图形开始，逐步实现复杂的效果。

## 十、参考资源

- [Flutter官方文档 - CustomPaint](https://api.flutter.dev/flutter/widgets/CustomPaint-class.html)
- [Flutter官方文档 - Canvas](https://api.flutter.dev/flutter/dart-ui/Canvas-class.html)
- [Flutter实战 - 自定义绘制](https://book.flutterchina.club/chapter10/)

## 完整示例代码

本文所有示例代码均可在以下仓库中找到：
[查看完整代码](../CancasPage.dart)

---

**作者**: [你的名字]  
**发布时间**: 2025-11-07  
**标签**: Flutter, 自定义绘制, CustomPaint, Canvas

如果这篇文章对你有帮助，欢迎点赞👍、收藏⭐、评论💬！

