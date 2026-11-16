# Canvas 实用案例集

本文档提供了6个实际项目中常用的Canvas绘制案例，每个案例都可以直接应用到你的项目中。

## 🎯 快速访问

在应用首页点击 **"Canvas 实用案例"** 即可查看所有案例的实际运行效果！

所有案例都已经集成到 `PracticalExamplesPage` 页面中，可以：
- ✅ 实时查看效果
- ✅ 查看动画演示
- ✅ 测试交互功能（如签名板）
- ✅ 复制代码直接使用

## 📦 案例列表

1. **圆形进度条** - 显示任务完成度
2. **折线图** - 数据可视化
3. **仪表盘** - 类似汽车速度表
4. **水波纹效果** - 点击反馈动画
5. **签名板** - 手写签名功能
6. **雷达图** - 多维度数据对比
7. **渐变文字** - 炫酷的渐变色文字效果

---

## 1️⃣ 圆形进度条

### 效果预览
显示一个圆环进度条，中间显示百分比数字。

### 使用方法

```dart
CircularProgressDemo(
  progress: 0.75, // 75%
)
```

### 自定义参数

```dart
CircularProgressPainter(
  progress: 0.65,
  backgroundColor: Colors.grey,
  progressColor: Colors.blue,
  strokeWidth: 10.0,
)
```

### 应用场景
- 下载/上传进度
- 任务完成度
- 健身目标追踪
- 学习进度显示

### 关键技术点
- `drawArc` 绘制圆弧
- `StrokeCap.round` 实现圆角端点
- `TextPainter` 绘制中心文字

---

## 2️⃣ 折线图

### 效果预览
显示数据趋势的折线图，支持区域填充。

### 使用方法

```dart
CustomPaint(
  size: Size(300, 200),
  painter: LineChartPainter(
    dataPoints: [10, 20, 15, 30, 25, 40, 35],
    lineColor: Colors.blue,
    showArea: true,
  ),
)
```

### 自定义参数

| 参数 | 类型 | 说明 |
|------|------|------|
| dataPoints | List<double> | 数据点列表 |
| lineColor | Color | 线条颜色 |
| areaColor | Color | 填充区域颜色 |
| showArea | bool | 是否显示区域填充 |

### 应用场景
- 股票走势图
- 温度变化曲线
- 销售数据趋势
- 健康数据记录

### 关键技术点
- 数据归一化处理
- `Path.lineTo` 连接数据点
- 半透明填充效果
- 数据点的圆点标记

### 扩展建议
可以添加：
- 坐标轴和刻度
- 数据点标签
- 触摸交互显示具体数值
- 多条折线对比

---

## 3️⃣ 仪表盘

### 效果预览
类似汽车速度表的仪表盘，带刻度和指针。

### 使用方法

```dart
CustomPaint(
  size: Size(250, 250),
  painter: GaugePainter(
    value: 0.68,
    label: 'Speed',
  ),
)
```

### 自定义参数

```dart
GaugePainter(
  value: 0.68,        // 当前值 0.0 到 1.0
  label: '速度 km/h',  // 标签文字
)
```

### 应用场景
- 速度显示
- 压力/温度指示
- 满意度评分
- 资源使用率

### 关键技术点
- `SweepGradient` 扫描渐变
- `canvas.save/restore` 保存和恢复画布状态
- 刻度线绘制
- 指针旋转变换

### 视觉特点
- 渐变色弧线（绿→黄→红）
- 动态指针
- 主刻度和次刻度
- 中心数值显示

---

## 4️⃣ 水波纹效果

### 效果预览
点击时产生的水波纹扩散动画，类似Material Design的涟漪效果。

### 使用方法

```dart
class RippleDemo extends StatefulWidget {
  @override
  _RippleDemoState createState() => _RippleDemoState();
}

class _RippleDemoState extends State<RippleDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(200, 200),
          painter: RipplePainter(
            progress: _controller.value,
            color: Colors.blue,
            rippleCount: 3,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### 自定义参数

| 参数 | 类型 | 说明 |
|------|------|------|
| progress | double | 动画进度 0.0 到 1.0 |
| color | Color | 波纹颜色 |
| rippleCount | int | 波纹圈数 |

### 应用场景
- 按钮点击反馈
- 位置标记动画
- 雷达扫描效果
- 声波可视化

### 关键技术点
- 多个同心圆动画
- 透明度随距离递减
- 延迟启动实现波纹序列

---

## 5️⃣ 签名板

### 效果预览
支持手写签名的画板功能。

### 完整实现

```dart
class SignatureBoard extends StatefulWidget {
  @override
  _SignatureBoardState createState() => _SignatureBoardState();
}

class _SignatureBoardState extends State<SignatureBoard> {
  List<List<Offset?>> _strokes = [];
  List<Offset?> _currentStroke = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.white,
          ),
          child: GestureDetector(
            onPanStart: (details) {
              setState(() {
                _currentStroke = [];
                _currentStroke.add(details.localPosition);
              });
            },
            onPanUpdate: (details) {
              setState(() {
                _currentStroke.add(details.localPosition);
              });
            },
            onPanEnd: (details) {
              setState(() {
                _strokes.add(List.from(_currentStroke));
                _currentStroke = [];
              });
            },
            child: CustomPaint(
              painter: SignaturePainter([..._strokes, _currentStroke]),
            ),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _strokes.clear();
              _currentStroke.clear();
            });
          },
          child: Text('清除'),
        ),
      ],
    );
  }
}
```

### 应用场景
- 电子签名
- 手写笔记
- 涂鸦板
- 手势识别

### 关键技术点
- `GestureDetector` 捕获触摸事件
- `onPanStart/Update/End` 追踪笔画
- 多个笔画的存储和绘制
- null 值标记抬笔

### 扩展功能
可以添加：
- 撤销/重做
- 笔画粗细调节
- 颜色选择
- 保存为图片
- 橡皮擦功能

---

## 6️⃣ 雷达图（蜘蛛网图）

### 效果预览
多维度数据对比的雷达图。

### 使用方法

```dart
CustomPaint(
  size: Size(300, 300),
  painter: RadarChartPainter(
    values: [0.8, 0.6, 0.9, 0.7, 0.5],
    labels: ['力量', '速度', '防御', '智力', '魔法'],
    sides: 5,
    color: Colors.blue,
  ),
)
```

### 自定义参数

| 参数 | 类型 | 说明 |
|------|------|------|
| values | List<double> | 各维度的值（0.0-1.0） |
| labels | List<String> | 各维度的标签 |
| sides | int | 多边形边数 |
| color | Color | 数据区域颜色 |

### 应用场景
- 能力值展示（游戏角色属性）
- 产品对比
- 绩效评估
- 技能评分

### 关键技术点
- 正多边形绘制
- 极坐标计算
- 同心多边形网格
- 数据区域填充

### 数学计算
```dart
// 极坐标转直角坐标
final angle = -pi / 2 + (2 * pi / sides) * i;
final x = centerX + radius * cos(angle);
final y = centerY + radius * sin(angle);
```

---

## 7️⃣ 渐变文字

### 效果预览
使用Canvas实现多彩的渐变色文字效果，包含线性渐变、彩虹色、金色光泽等。

### 使用方法

**方式一：使用 GradientText 组件（推荐）**

```dart
GradientText(
  text: '渐变文字',
  style: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  ),
  gradient: LinearGradient(
    colors: [Colors.purple, Colors.blue, Colors.pink],
  ),
)
```

**方式二：使用 CustomPaint**

```dart
CustomPaint(
  size: Size(200, 50),
  painter: GradientTextPainter(
    text: '渐变文字',
    textStyle: TextStyle(fontSize: 32),
    gradient: LinearGradient(
      colors: [Colors.red, Colors.orange],
    ),
  ),
)
```

### 自定义参数

| 参数 | 类型 | 说明 |
|------|------|------|
| text | String | 要显示的文字 |
| style/textStyle | TextStyle | 文字样式（大小、粗细等） |
| gradient | Gradient | 渐变类型（Linear/Radial/Sweep） |

### 应用场景
- App Logo 和品牌标识
- 重要标题和口号
- 价格和促销标签
- 按钮和CTA元素
- VIP勋章和等级标识
- 特殊效果的标题

### 关键技术点
- `TextStyle.foreground` 属性应用自定义Paint
- `gradient.createShader()` 创建渐变着色器
- `TextPainter` 绘制文字
- 支持多行文字渐变

### 常用配色方案

**彩虹色：**
```dart
LinearGradient(
  colors: [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
  ],
)
```

**金色光泽：**
```dart
LinearGradient(
  colors: [
    Color(0xFFFFD700),
    Color(0xFFFFE55C),
    Color(0xFFFFD700),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
)
```

**海洋蓝：**
```dart
LinearGradient(
  colors: [
    Color(0xFF0077BE),
    Color(0xFF00C9FF),
    Color(0xFF92FE9D),
  ],
)
```

### 展示效果

在 `PracticalExamplesPage` 中展示了4种效果：
1. **线性渐变文字** - 紫→蓝→粉
2. **彩虹色效果** - 全彩虹光谱
3. **金色渐变** - 高级金色光泽
4. **多行渐变** - 支持换行的渐变文字

### 扩展功能
可以添加：
- 动态渐变动画
- 文字描边效果
- 阴影和光晕
- 不同的渐变方向
- 自定义渐变停止点

### 详细教程
查看 `渐变文字使用指南.md` 了解更多用法和技巧。

---

## 🎯 综合应用示例

### 创建一个实用案例展示页面

```dart
class PracticalExamplesPage extends StatefulWidget {
  @override
  _PracticalExamplesPageState createState() => _PracticalExamplesPageState();
}

class _PracticalExamplesPageState extends State<PracticalExamplesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Canvas实用案例')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSection('圆形进度条', CircularProgressDemo(progress: 0.75)),
            _buildSection('折线图', _buildLineChart()),
            _buildSection('仪表盘', _buildGauge()),
            _buildSection('水波纹', _buildRipple()),
            _buildSection('雷达图', _buildRadarChart()),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(child: child),
        ),
        SizedBox(height: 30),
      ],
    );
  }

  Widget _buildLineChart() {
    return CustomPaint(
      size: Size(300, 150),
      painter: LineChartPainter(
        dataPoints: [10, 25, 15, 35, 20, 40, 30],
        lineColor: Colors.blue,
      ),
    );
  }

  Widget _buildGauge() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(200, 200),
          painter: GaugePainter(
            value: (_controller.value),
            label: '速度',
          ),
        );
      },
    );
  }

  Widget _buildRipple() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(150, 150),
          painter: RipplePainter(
            progress: _controller.value,
            color: Colors.blue,
          ),
        );
      },
    );
  }

  Widget _buildRadarChart() {
    return CustomPaint(
      size: Size(250, 250),
      painter: RadarChartPainter(
        values: [0.8, 0.6, 0.9, 0.7, 0.5],
        labels: ['攻击', '防御', '速度', '技巧', '耐力'],
        color: Colors.purple,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

---

## 🔧 性能优化建议

### 1. 复用Paint对象

❌ **不推荐**：
```dart
void paint(Canvas canvas, Size size) {
  canvas.drawCircle(center, radius, Paint()..color = Colors.red);
}
```

✅ **推荐**：
```dart
class MyPainter extends CustomPainter {
  final Paint _paint = Paint()..color = Colors.red;

  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(center, radius, _paint);
  }
}
```

### 2. 缓存复杂计算

```dart
class MyPainter extends CustomPainter {
  Path? _cachedPath;
  Size? _cachedSize;

  Path _getPath(Size size) {
    if (_cachedPath == null || _cachedSize != size) {
      _cachedPath = _createComplexPath(size);
      _cachedSize = size;
    }
    return _cachedPath!;
  }
}
```

### 3. 合理使用 shouldRepaint

```dart
@override
bool shouldRepaint(MyPainter oldDelegate) {
  // 只有在必要时才重绘
  return oldDelegate.value != value;
}
```

---

## 📚 学习路径

1. **初级**：从圆形进度条开始，理解基本的绘制流程
2. **中级**：尝试折线图和仪表盘，掌握路径和变换
3. **高级**：实现签名板和雷达图，融合交互和复杂计算

---

## 💡 提示

- 所有示例代码都位于 `lib/testPage/canvas/PracticalExamples.dart`
- 每个案例都可以独立使用，复制即可
- 建议结合主教程文档 `Flutter自定义绘制完全指南.md` 一起学习
- 尝试修改参数，观察效果变化

---

**祝你学习愉快！🎉**

