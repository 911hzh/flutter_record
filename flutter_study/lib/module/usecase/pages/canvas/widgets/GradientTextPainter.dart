import 'package:flutter/material.dart';

/// 渐变色文字绘制
class GradientTextPainter extends CustomPainter {
  final String text;
  final TextStyle textStyle;
  final Gradient gradient;
  final TextAlign textAlign;

  GradientTextPainter({
    required this.text,
    required this.textStyle,
    required this.gradient,
    this.textAlign = TextAlign.center,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 创建渐变着色器（先创建一个临时 textPainter 用于计算尺寸）
    final tempTextSpan = TextSpan(text: text, style: textStyle);
    final tempTextPainter = TextPainter(text: tempTextSpan, textDirection: TextDirection.ltr, textAlign: textAlign)
      ..layout(maxWidth: size.width);

    // 计算文字位置（居中）
    final offset = Offset((size.width - tempTextPainter.width) / 2, (size.height - tempTextPainter.height) / 2);

    // 创建渐变着色器
    final rect = Rect.fromLTWH(offset.dx, offset.dy, tempTextPainter.width, tempTextPainter.height);
    final shader = gradient.createShader(rect);

    // 使用渐变绘制文字
    final paint = Paint()..shader = shader;
    final gradientTextSpan = TextSpan(text: text, style: textStyle.copyWith(foreground: paint));
    final gradientTextPainter = TextPainter(
      text: gradientTextSpan,
      textDirection: TextDirection.ltr,
      textAlign: textAlign,
    )..layout(maxWidth: size.width);

    // 直接绘制渐变文字
    gradientTextPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(GradientTextPainter oldDelegate) {
    return oldDelegate.text != text || oldDelegate.textStyle != textStyle || oldDelegate.gradient != gradient;
  }
}

/// 渐变文字组件（便于使用）
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;

  const GradientText({Key? key, required this.text, required this.style, required this.gradient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GradientTextPainter(text: text, textStyle: style, gradient: gradient),
      child: Text(text, style: style.copyWith(color: Colors.transparent)),
    );
  }
}

/// 多种渐变文字效果展示
class GradientTextShowcase extends StatelessWidget {
  const GradientTextShowcase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 1. 线性渐变文字
        _buildGradientText('线性渐变文字', LinearGradient(colors: [Colors.purple, Colors.blue, Colors.pink]), fontSize: 32),
        SizedBox(height: 30),

        // 2. 彩虹渐变
        _buildGradientText(
          '彩虹色效果',
          LinearGradient(colors: [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue, Colors.purple]),
          fontSize: 28,
        ),
        SizedBox(height: 30),

        // 3. 金色渐变
        _buildGradientText(
          'GOLD',
          LinearGradient(
            colors: [Color(0xFFFFD700), Color(0xFFFFE55C), Color(0xFFFFD700)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: 30),

        // 4. 渐变多行文字
        Container(
          width: 300,
          child: _buildGradientText(
            '多行渐变文字示例\nMultiline Gradient',
            LinearGradient(
              colors: [Colors.cyan, Colors.indigo],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            fontSize: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildGradientText(
    String text,
    Gradient gradient, {
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    final textStyle = TextStyle(fontSize: fontSize, fontWeight: fontWeight);

    // 计算文字尺寸
    final textPainter = TextPainter(text: TextSpan(text: text, style: textStyle), textDirection: TextDirection.ltr)
      ..layout();

    return CustomPaint(
      size: Size(textPainter.width, textPainter.height),
      painter: GradientTextPainter(text: text, textStyle: textStyle, gradient: gradient),
    );
  }
}

/// 带动画效果的渐变文字组件
/// 通过改变 gradient 的 begin/end 实现流动效果
class AnimatedGradientText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final List<Color> colors;
  final Duration duration;
  final AnimationType animationType;

  const AnimatedGradientText({
    Key? key,
    required this.text,
    required this.style,
    required this.colors,
    this.duration = const Duration(seconds: 3),
    this.animationType = AnimationType.slide,
  }) : super(key: key);

  @override
  State<AnimatedGradientText> createState() => _AnimatedGradientTextState();
}

class _AnimatedGradientTextState extends State<AnimatedGradientText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final gradient = _createAnimatedGradient(_controller.value);

        // 计算文字尺寸
        final textPainter = TextPainter(
          text: TextSpan(text: widget.text, style: widget.style),
          textDirection: TextDirection.ltr,
        )..layout();

        return CustomPaint(
          size: Size(textPainter.width, textPainter.height),
          painter: GradientTextPainter(text: widget.text, textStyle: widget.style, gradient: gradient),
        );
      },
    );
  }

  /// 根据动画类型创建不同的渐变效果
  Gradient _createAnimatedGradient(double value) {
    switch (widget.animationType) {
      case AnimationType.slide:
        // 滑动效果：渐变从左到右流动
        return LinearGradient(
          colors: widget.colors,
          begin: Alignment(-1.0 + value * 2, 0.0),
          end: Alignment(1.0 + value * 2, 0.0),
        );

      case AnimationType.rotate:
        // 旋转效果：渐变旋转360度
        return LinearGradient(
          colors: widget.colors,
          begin: Alignment(0.0 + 1.0 * (1 - value * 2).abs() * (value < 0.5 ? 1 : -1), -1.0 + value * 2),
          end: Alignment(0.0 - 1.0 * (1 - value * 2).abs() * (value < 0.5 ? 1 : -1), 1.0 - value * 2),
        );

      case AnimationType.wave:
        // 波浪效果：渐变来回流动
        final waveValue = (value < 0.5 ? value * 2 : (1 - value) * 2);
        return LinearGradient(
          colors: widget.colors,
          begin: Alignment(-1.0 + waveValue * 2, 0.0),
          end: Alignment(1.0 + waveValue * 2, 0.0),
        );

      case AnimationType.pulse:
        // 脉冲效果：颜色在列表中循环
        final colorCount = widget.colors.length;
        final shiftedColors = List<Color>.generate(colorCount, (index) {
          final shiftIndex = ((index + (value * colorCount).floor()) % colorCount);
          return widget.colors[shiftIndex];
        });
        return LinearGradient(colors: shiftedColors);
    }
  }
}

/// 动画类型枚举
enum AnimationType {
  slide, // 滑动流动
  rotate, // 旋转
  wave, // 波浪往返
  pulse, // 脉冲变色
}

/// 带动画的渐变文字效果展示
class AnimatedGradientTextShowcase extends StatelessWidget {
  const AnimatedGradientTextShowcase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 1. 滑动流动效果
        AnimatedGradientText(
          text: '滑动流动效果',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          colors: [Colors.purple, Colors.blue, Colors.pink],
          animationType: AnimationType.slide,
        ),
        SizedBox(height: 30),

        // 2. 彩虹波浪效果
        AnimatedGradientText(
          text: '彩虹波浪效果',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          colors: [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue, Colors.purple],
          animationType: AnimationType.wave,
          duration: Duration(seconds: 2),
        ),
        SizedBox(height: 30),

        // 3. 金色旋转效果
        AnimatedGradientText(
          text: 'GOLD ROTATE',
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          colors: [Color(0xFFFFD700), Color(0xFFFFE55C), Color(0xFFFFD700)],
          animationType: AnimationType.rotate,
          duration: Duration(seconds: 4),
        ),
        SizedBox(height: 30),

        // 4. 脉冲变色效果
        AnimatedGradientText(
          text: '脉冲变色效果',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          colors: [Colors.cyan, Colors.teal, Colors.green, Colors.lightGreen],
          animationType: AnimationType.pulse,
          duration: Duration(seconds: 2),
        ),
      ],
    );
  }
}
