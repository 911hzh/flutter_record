# Canvas 绘制 Demo 使用说明

## 📱 Demo 功能

这个Demo展示了Flutter自定义绘制的四大核心功能模块：

### 1️⃣ 基础图形绘制
- ⭕ 空心圆和实心圆
- 🟦 矩形和圆角矩形
- ➖ 直线
- 🌙 弧线

### 2️⃣ 路径绘制
- 📐 直线路径（封闭图形）
- 📈 二次贝塞尔曲线
- 📊 三次贝塞尔曲线
- 🌊 波浪线效果

### 3️⃣ 文字与渐变
- 🎨 线性渐变
- 🔵 径向渐变
- 📝 文字绘制
- 💫 阴影/模糊效果

### 4️⃣ 动画绘制
- 🔄 旋转动画
- 💓 脉动效果
- 📊 进度条动画
- 🎯 移动动画

## 🚀 快速开始

### 1. 从首页访问

在应用首页可以看到两个Canvas相关的选项：

- **Canvas Page** 🖌️ - 基础绘制示例（学习用）
- **Canvas 实用案例** 📊 - 6个完整的实战案例（可直接使用）

### 2. 基础示例页面（CancasPage）

页面顶部有4个选项卡：
- 基础图形：圆、矩形、线条等
- 路径绘制：贝塞尔曲线、波浪线等
- 文字&渐变：文字绘制、渐变效果
- 动画绘制：旋转、脉动、移动动画

### 3. 实用案例页面（PracticalExamplesPage）

页面顶部有6个选项卡，展示完整可用的实战案例：
- 进度圆环：带百分比的圆形进度条
- 折线图：数据趋势可视化
- 仪表盘：类似汽车速度表
- 水波纹：扩散动画效果
- 签名板：可手写签名、涂鸦（支持撤销）
- 雷达图：多维度数据对比

## 📂 文件结构

```
lib/testPage/canvas/
  ├── CancasPage.dart              # Canvas绘制基础示例（4个选项卡）
  ├── PracticalExamples.dart       # 实用案例代码库（6个案例的Painter）
  └── PracticalExamplesPage.dart   # 实用案例展示页面（完整可交互）
```

## 🔑 核心代码解析

### CustomPaint 组件使用

```dart
CustomPaint(
  size: Size(300, 300),      // 画布大小
  painter: BasicShapesPainter(),  // 自定义画笔
)
```

### CustomPainter 实现

```dart
class BasicShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 在这里实现具体的绘制逻辑
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // 返回true时重绘，false时不重绘
    return false;
  }
}
```

## 💡 实用技巧

### 1. Paint 对象配置

```dart
Paint()
  ..color = Colors.red           // 颜色
  ..style = PaintingStyle.stroke // stroke(描边) 或 fill(填充)
  ..strokeWidth = 3              // 线条宽度
```

### 2. Canvas 常用方法

| 方法 | 功能 |
|------|------|
| `drawCircle()` | 绘制圆形 |
| `drawRect()` | 绘制矩形 |
| `drawLine()` | 绘制直线 |
| `drawPath()` | 绘制路径 |
| `drawArc()` | 绘制弧线 |
| `save()/restore()` | 保存/恢复画布状态 |
| `translate()` | 平移 |
| `rotate()` | 旋转 |
| `scale()` | 缩放 |

### 3. 动画实现要点

```dart
// 1. 创建动画控制器
final controller = useAnimationController(
  duration: Duration(seconds: 2),
)..repeat();

// 2. 使用AnimatedBuilder
AnimatedBuilder(
  animation: controller,
  builder: (context, child) {
    return CustomPaint(
      painter: AnimatedPainter(controller.value),
    );
  },
)

// 3. shouldRepaint返回true
@override
bool shouldRepaint(AnimatedPainter oldDelegate) {
  return oldDelegate.progress != progress;
}
```

## 🎯 学习路径建议

1. **第一步**: 从基础图形开始，理解 Canvas 和 Paint 的用法
2. **第二步**: 学习 Path 的使用，掌握贝塞尔曲线
3. **第三步**: 尝试渐变和文字绘制，丰富视觉效果
4. **第四步**: 结合动画，创建动态效果

## 📖 扩展阅读

详细的教程和原理说明，请查看：
- [Flutter自定义绘制完全指南.md](../../Flutter自定义绘制完全指南.md)

## 🐛 常见问题

### Q: 为什么看不到绘制的内容？
**A**: 检查以下几点：
- Canvas 的 size 是否为 0
- 颜色是否与背景相同
- 坐标是否超出画布范围

### Q: 如何实现触摸交互？
**A**: 使用 GestureDetector 包裹 CustomPaint：
```dart
GestureDetector(
  onTapDown: (details) {
    final position = details.localPosition;
    // 处理点击事件
  },
  child: CustomPaint(painter: MyPainter()),
)
```

### Q: 动画不流畅怎么办？
**A**: 性能优化建议：
- 避免在 paint() 方法中创建临时对象
- 合理使用 shouldRepaint()
- 复用 Paint 和 Path 对象

## 🎨 自定义修改

你可以轻松修改示例代码来创建自己的效果：

```dart
// 修改颜色
Paint()..color = Colors.yourColor

// 修改大小
CustomPaint(size: Size(yourWidth, yourHeight))

// 修改动画速度
useAnimationController(duration: Duration(seconds: yourDuration))
```

## 📝 代码示例片段

### 绘制带渐变的圆形按钮

```dart
class GradientCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );
    
    final gradient = Paint()
      ..shader = LinearGradient(
        colors: [Colors.blue, Colors.purple],
      ).createShader(rect);
    
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      gradient,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
```

### 绘制虚线边框

```dart
void drawDashedRect(Canvas canvas, Rect rect, Paint paint) {
  const dashWidth = 5.0;
  const dashSpace = 3.0;
  
  // 绘制上边
  double startX = rect.left;
  while (startX < rect.right) {
    canvas.drawLine(
      Offset(startX, rect.top),
      Offset(min(startX + dashWidth, rect.right), rect.top),
      paint,
    );
    startX += dashWidth + dashSpace;
  }
  // ... 类似方式绘制其他三边
}
```

## 💪 挑战任务

尝试实现以下效果来巩固学习：

- [ ] 绘制一个时钟表盘
- [ ] 实现水波纹扩散动画
- [ ] 绘制一个柱状图
- [ ] 创建一个加载动画
- [ ] 实现签名板功能

## 🤝 反馈与建议

如果你在使用过程中遇到问题，或有改进建议，欢迎提交 Issue！

---

**Happy Coding! 🎉**

