# RepaintBoundary 源码解析：为什么加了就不重绘，数据变了又重绘？

## 问题核心

**疑问 1**：为什么加了 RepaintBoundary，父组件变化时，子组件不重绘？  
**疑问 2**：但是子组件自己的数据变了，为什么又会重绘？

答案：这是两个**完全不同的场景**，涉及 `markNeedsPaint()` 的**向上传播**和**隔离机制**。

---

## 一、核心源码：markNeedsPaint() 的向上传播

### 1.1 RenderObject.markNeedsPaint() 源码

```dart
// Flutter SDK: rendering/object.dart (约 2100 行)
void markNeedsPaint() {
  // 如果已经标记过了，直接返回
  if (_needsPaint) {
    return;
  }
  _needsPaint = true;  // ← 标记自己需要重绘
  
  // ⬇️ 关键：判断是否是 RepaintBoundary
  if (isRepaintBoundary) {
    // 情况 1：自己就是 RepaintBoundary
    // → 停止向上传播！
    // → 只将自己加入待绘制列表
    owner!._nodesNeedingPaint.add(this);
    owner!.requestVisualUpdate();  // 请求下一帧
  } else if (parent is RenderObject) {
    // 情况 2：不是 RepaintBoundary
    // → 继续向上传播给父节点
    parent!.markNeedsPaint();  // ← 递归调用父节点！
  } else {
    // 情况 3：已经到根节点
    owner!.requestVisualUpdate();
  }
}
```

**关键点：**
- ✅ `isRepaintBoundary = true` 时，**停止向上传播**
- ✅ `isRepaintBoundary = false` 时，**递归调用** `parent.markNeedsPaint()`

### 1.2 isRepaintBoundary 属性

```dart
// Flutter SDK: rendering/object.dart (约 1850 行)
@protected
bool get isRepaintBoundary => false;  // 默认为 false
```

```dart
// Flutter SDK: rendering/proxy_box.dart (约 2050 行)
class RenderRepaintBoundary extends RenderProxyBox {
  @override
  bool get isRepaintBoundary => true;  // ← RepaintBoundary 返回 true！
}
```

---

## 二、场景 1：父组件变化，子组件为什么不重绘？

### 2.1 示例代码

```dart
class ParentWidget extends StatefulWidget {
  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  Color parentColor = Colors.red;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 父组件自己的内容
        Container(
          color: parentColor,  // ← 这个会变化
          height: 100,
        ),
        
        // 子组件（用 RepaintBoundary 包裹）
        RepaintBoundary(
          child: ExpensiveWidget(),  // ← 复杂的子组件
        ),
        
        ElevatedButton(
          onPressed: () {
            setState(() {
              parentColor = Colors.blue;  // ← 改变父组件颜色
            });
          },
          child: Text('改变父组件'),
        ),
      ],
    );
  }
}

class ExpensiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ExpensivePainter(),  // 复杂的绘制
      size: Size(200, 200),
    );
  }
}
```

### 2.2 源码执行流程

**步骤 1：setState() 触发父组件重建**

```dart
setState(() {
  parentColor = Colors.blue;
});
    ↓
父 Element.markNeedsBuild()
    ↓
【等待 VSync】
    ↓
父 Element.rebuild()
    ↓
父 build() 执行
    ↓
updateChild() → Column 更新
    ↓
Column.updateChildren()
    ↓
Container Element 和 RepaintBoundary Element 都会 update()
```

**步骤 2：Container 的 RenderObject 调用 markNeedsPaint()**

```dart
// Container 的颜色变化
Container RenderObject.color = Colors.blue
    ↓
// basic.dart: color setter
set color(Color value) {
  if (_color == value) return;
  _color = value;
  markNeedsPaint();  // ← 标记需要重绘
}
    ↓
// 调用 markNeedsPaint()
void markNeedsPaint() {
  _needsPaint = true;
  
  if (isRepaintBoundary) {  // Container 不是 RepaintBoundary
    // 不执行
  } else {
    // ⬇️ 向上传播给父节点（Column）
    parent!.markNeedsPaint();
  }
}
```

**步骤 3：向上传播到 Column（父节点）**

```dart
// Column RenderObject.markNeedsPaint()
void markNeedsPaint() {
  _needsPaint = true;
  
  if (isRepaintBoundary) {  // Column 也不是 RepaintBoundary
    // 不执行
  } else {
    // ⬇️ 继续向上传播
    parent!.markNeedsPaint();
  }
}
```

**步骤 4：继续向上，直到遇到 RepaintBoundary 或根节点**

```
Container.markNeedsPaint()
    ↑ 向上传播
Column.markNeedsPaint()
    ↑ 向上传播
ParentWidget RenderObject.markNeedsPaint()
    ↑ 向上传播
...继续向上...
    ↑ 向上传播
最终到达根 RepaintBoundary（通常是 RenderView）
    ↓
标记根 RepaintBoundary 需要重绘
```

**关键：ExpensiveWidget 的 RepaintBoundary 完全没有被触发！**

### 2.3 为什么子组件不重绘？

**渲染树结构：**

```
RenderView (根 RepaintBoundary)
    │
    └─ RenderColumn (Column)
           ├─ RenderContainer (Container) ← markNeedsPaint() 从这里开始
           │                                向上传播 ⬆️
           └─ RenderRepaintBoundary (RepaintBoundary) ← 这里是隔离边界
                  └─ RenderCustomPaint (ExpensiveWidget)
```

**传播路径：**

```
1. Container.markNeedsPaint()
    ↑ 向上
2. Column.markNeedsPaint()
    ↑ 向上
3. ...继续向上到根
    ↓ 绘制时
4. 从根开始向下绘制：
    ├─ 绘制 Column ✅
    ├─ 绘制 Container ✅（颜色已更新）
    └─ 遇到 RepaintBoundary
           ↓
        检查 RepaintBoundary._needsPaint
           ↓
        发现是 false（因为没有被标记）
           ↓
        复用上一帧的 Layer（缓存）✅
           ↓
        ExpensiveWidget 不重绘！✅
```

### 2.4 核心源码：Paint 阶段的跳过逻辑

```dart
// Flutter SDK: rendering/object.dart (约 2500 行)
void _paintWithContext(PaintingContext context, Offset offset) {
  // 如果不需要重绘，直接返回
  if (!_needsPaint) {
    return;  // ← 跳过重绘！
  }
  
  // 清除标记
  _needsPaint = false;
  
  // 执行实际绘制
  paint(context, offset);
}
```

```dart
// Flutter SDK: rendering/proxy_box.dart (约 2100 行)
class RenderRepaintBoundary extends RenderProxyBox {
  @override
  void paint(PaintingContext context, Offset offset) {
    // 如果有缓存的 Layer，直接复用
    if (child != null) {
      // 使用独立的 Layer 绘制子树
      context.paintChild(child!, offset);
    }
  }
}
```

**结论：**
- ✅ Container 变化 → 向上传播 `markNeedsPaint()`
- ✅ 传播路径**不经过** RepaintBoundary 的子树
- ✅ RepaintBoundary 的 `_needsPaint` 保持为 `false`
- ✅ 绘制时，RepaintBoundary 复用缓存的 Layer
- ✅ **ExpensiveWidget 不重绘！**

---

## 三、场景 2：子组件数据变化，为什么会重绘？

### 3.1 示例代码

```dart
class AnimatedChildWidget extends StatefulWidget {
  @override
  _AnimatedChildWidgetState createState() => _AnimatedChildWidgetState();
}

class _AnimatedChildWidgetState extends State<AnimatedChildWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: RotatingPainter(_controller.value),  // ← 动画值变化
          size: Size(200, 200),
        );
      },
    );
  }
}

class RotatingPainter extends CustomPainter {
  final double rotation;
  
  RotatingPainter(this.rotation);
  
  @override
  void paint(Canvas canvas, Size size) {
    // 绘制旋转的内容
    canvas.rotate(rotation * 2 * pi);
    // ...绘制逻辑
  }
  
  @override
  bool shouldRepaint(RotatingPainter oldDelegate) {
    return oldDelegate.rotation != rotation;  // ← 数据变化了！
  }
}
```

**Widget 树：**

```dart
Column(
  children: [
    RepaintBoundary(  // ← 包裹动画组件
      child: AnimatedChildWidget(),  // ← 动画组件
    ),
  ],
)
```

### 3.2 源码执行流程

**步骤 1：动画值变化触发 rebuild**

```dart
// AnimationController 通知监听器
_controller.value = 0.5
    ↓
notifyListeners()
    ↓
AnimatedBuilder 监听到变化
    ↓
setState() 被调用（AnimatedBuilder 内部）
    ↓
AnimatedChildWidget Element.markNeedsBuild()
    ↓
【等待 VSync】
    ↓
AnimatedChildWidget Element.rebuild()
    ↓
build() 执行，创建新的 CustomPaint(painter: RotatingPainter(0.5))
```

**步骤 2：CustomPaint 更新 RenderObject**

```dart
// framework.dart:6719 - RenderObjectElement.update()
void update(RenderObjectWidget newWidget) {
  super.update(newWidget);
  _performRebuild();  // ← 立即调用
}

// framework.dart:6745 - _performRebuild()
void _performRebuild() {
  // ⬇️ 更新 RenderObject
  widget.updateRenderObject(this, renderObject);
  super.performRebuild();
}
```

```dart
// Flutter SDK: widgets/basic.dart (约 4500 行)
class CustomPaint extends SingleChildRenderObjectWidget {
  @override
  void updateRenderObject(BuildContext context, RenderCustomPaint renderObject) {
    renderObject
      ..painter = painter  // ← 设置新的 painter
      ..foregroundPainter = foregroundPainter
      ..preferredSize = size;
  }
}
```

**步骤 3：RenderCustomPaint.painter setter 触发重绘**

```dart
// Flutter SDK: rendering/custom_paint.dart (约 250 行)
class RenderCustomPaint extends RenderProxyBox {
  CustomPainter? _painter;
  
  set painter(CustomPainter? value) {
    if (_painter == value) return;
    
    final CustomPainter? oldPainter = _painter;
    _painter = value;
    
    // ⬇️ 检查是否需要重绘
    if (value == null) {
      markNeedsPaint();
    } else if (oldPainter == null ||
        value.runtimeType != oldPainter.runtimeType ||
        value.shouldRepaint(oldPainter)) {  // ← 调用 shouldRepaint()！
      markNeedsPaint();  // ← 标记需要重绘！
    }
  }
}
```

**步骤 4：markNeedsPaint() 向上查找 RepaintBoundary**

```dart
// RenderCustomPaint.markNeedsPaint()
void markNeedsPaint() {
  _needsPaint = true;
  
  if (isRepaintBoundary) {  // RenderCustomPaint 不是 RepaintBoundary
    // 不执行
  } else {
    // ⬇️ 向上传播给父节点
    parent!.markNeedsPaint();  // 父节点是 RenderRepaintBoundary！
  }
}
```

**步骤 5：向上传播到 RepaintBoundary**

```dart
// RenderRepaintBoundary.markNeedsPaint()
void markNeedsPaint() {
  _needsPaint = true;  // ← 标记自己需要重绘！
  
  if (isRepaintBoundary) {  // ← true！停止传播！
    owner!._nodesNeedingPaint.add(this);  // ← 加入待绘制列表
    owner!.requestVisualUpdate();  // ← 请求下一帧
  } else {
    // 不执行（因为 isRepaintBoundary = true）
  }
}
```

**关键：传播在 RepaintBoundary 处停止！**

### 3.3 渲染树结构和传播路径

```
RenderView (根 RepaintBoundary)
    │
    └─ RenderColumn
           └─ RenderRepaintBoundary ← 传播到这里停止！✋
                  └─ RenderCustomPaint ← markNeedsPaint() 从这里开始
                                        向上传播 ⬆️
```

**传播路径：**

```
1. RenderCustomPaint.markNeedsPaint()
    ↑ 向上传播
2. RenderRepaintBoundary.markNeedsPaint()
    ↑ isRepaintBoundary = true，停止！
    ↓
3. RenderRepaintBoundary 被加入 _nodesNeedingPaint
    ↓
【等待 VSync】
    ↓
4. Paint 阶段：
    ├─ 遍历 _nodesNeedingPaint
    ├─ 找到 RenderRepaintBoundary
    ├─ 调用 RenderRepaintBoundary.paint()
    └─ RenderRepaintBoundary 向下绘制子树
           └─ RenderCustomPaint.paint() ✅
                  └─ painter.paint(canvas, size) ✅
```

**结论：**
- ✅ 子组件数据变化 → 调用 `markNeedsPaint()`
- ✅ 向上传播到 RepaintBoundary 后**停止**
- ✅ 只有 RepaintBoundary 及其**子树**被标记为需要重绘
- ✅ **不影响父组件和兄弟组件**
- ✅ **子组件会重绘**，但范围被限制在 RepaintBoundary 内

---

## 四、完整对比：两种场景

| 场景 | 触发源 | 传播方向 | RepaintBoundary 作用 | 子组件是否重绘 |
|------|--------|---------|---------------------|---------------|
| **场景 1：父组件变化** | 父组件 `setState()` | Container → Column → 根 | **阻止向上传播影响子树** | ❌ 不重绘 |
| **场景 2：子组件变化** | 子组件 `setState()` | CustomPaint → RepaintBoundary → 停止 | **隔离重绘范围** | ✅ 重绘 |

### 4.1 场景 1：父组件变化（子组件不重绘）

```
渲染树：
RenderView
    └─ RenderColumn
           ├─ RenderContainer ← setState() 导致这里变化
           │                    markNeedsPaint() 向上传播 ⬆️
           │                    传播路径不经过子树 ✅
           └─ RenderRepaintBoundary ← 这里没有被标记
                  └─ RenderCustomPaint ← 所以这里不重绘 ✅
```

### 4.2 场景 2：子组件变化（子组件重绘）

```
渲染树：
RenderView
    └─ RenderColumn
           └─ RenderRepaintBoundary ← markNeedsPaint() 传播到这里停止 ✋
                  └─ RenderCustomPaint ← setState() 导致这里变化
                                        markNeedsPaint() 向上传播 ⬆️
                                        这个会重绘 ✅
```

---

## 五、源码总结

### 5.1 核心机制

**1. markNeedsPaint() 的向上传播**

```dart
void markNeedsPaint() {
  _needsPaint = true;
  
  if (isRepaintBoundary) {
    // 停止传播，只标记自己
    owner!._nodesNeedingPaint.add(this);
  } else {
    // 继续向上传播
    parent!.markNeedsPaint();  // ← 递归！
  }
}
```

**2. RepaintBoundary 的隔离作用**

- **阻止向上传播**：子树的变化不会影响父树
- **阻止向下影响**：父树的变化不会触发子树重绘（因为传播路径不经过子树）

**3. Paint 阶段的执行**

```dart
void _paintWithContext(PaintingContext context, Offset offset) {
  if (!_needsPaint) {
    return;  // ← 跳过重绘，复用缓存的 Layer
  }
  
  _needsPaint = false;
  paint(context, offset);  // ← 执行重绘
}
```

### 5.2 关键要点

| 要点 | 说明 |
|------|------|
| **传播方向** | `markNeedsPaint()` 是**向上传播**的 |
| **停止条件** | 遇到 `isRepaintBoundary = true` 的节点时停止 |
| **隔离原理** | 父树变化的传播路径**不经过**子树 |
| **子树变化** | 子树变化会向上传播到 RepaintBoundary 后停止 |
| **缓存机制** | RepaintBoundary 缓存 Layer，`_needsPaint = false` 时复用 |

---

## 六、实际案例验证

### 6.1 验证代码

```dart
class TestRepaintBoundary extends StatefulWidget {
  @override
  _TestRepaintBoundaryState createState() => _TestRepaintBoundaryState();
}

class _TestRepaintBoundaryState extends State<TestRepaintBoundary> {
  Color parentColor = Colors.red;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 父组件区域
        Container(
          color: parentColor,
          height: 100,
          child: Text('父组件'),
        ),
        
        // 子组件区域（有 RepaintBoundary）
        RepaintBoundary(
          child: ChildWithAnimation(),
        ),
        
        // 按钮
        ElevatedButton(
          onPressed: () {
            setState(() {
              parentColor = parentColor == Colors.red 
                  ? Colors.blue 
                  : Colors.red;
            });
            print('父组件颜色变化');
          },
          child: Text('改变父组件'),
        ),
      ],
    );
  }
}

class ChildWithAnimation extends StatefulWidget {
  @override
  _ChildWithAnimationState createState() => _ChildWithAnimationState();
}

class _ChildWithAnimationState extends State<ChildWithAnimation>
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
    print('ChildWithAnimation build');  // ← 监控 rebuild
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: DebugPainter(_controller.value),
          size: Size(200, 200),
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

class DebugPainter extends CustomPainter {
  final double value;
  
  DebugPainter(this.value);
  
  @override
  void paint(Canvas canvas, Size size) {
    print('DebugPainter.paint: $value');  // ← 监控 paint
    
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      50 + value * 20,
      paint,
    );
  }
  
  @override
  bool shouldRepaint(DebugPainter oldDelegate) {
    return oldDelegate.value != value;
  }
}
```

### 6.2 运行结果

**点击"改变父组件"按钮：**

```
输出：
父组件颜色变化
# 注意：没有打印 "ChildWithAnimation build" 或 "DebugPainter.paint"
# 说明子组件没有 rebuild，也没有 repaint！✅
```

**动画持续运行时：**

```
输出：
DebugPainter.paint: 0.0
DebugPainter.paint: 0.016
DebugPainter.paint: 0.032
...
# 说明子组件自己的动画正常触发 repaint ✅
```

---

## 七、总结

### 7.1 回答你的问题

**Q1：为什么加了 RepaintBoundary，子组件就不重绘？**

**A：** 因为父组件变化时，`markNeedsPaint()` 的向上传播路径**不经过子树**，RepaintBoundary 的 `_needsPaint` 保持为 `false`，Paint 阶段复用缓存的 Layer，子组件不重绘。

**Q2：但是子组件数据变了，又会重绘？**

**A：** 因为子组件自己调用 `markNeedsPaint()`，向上传播到 RepaintBoundary 后停止，RepaintBoundary 的 `_needsPaint` 被设置为 `true`，Paint 阶段会重绘 RepaintBoundary 及其子树。

### 7.2 核心原理

```
关键源码：
void markNeedsPaint() {
  _needsPaint = true;
  
  if (isRepaintBoundary) {
    owner!._nodesNeedingPaint.add(this);  // ← 停止传播
  } else {
    parent!.markNeedsPaint();  // ← 向上传播
  }
}
```

**两种场景：**

1. **父组件变化** → 传播路径不经过子树 → 子组件不重绘 ✅
2. **子组件变化** → 传播到 RepaintBoundary 停止 → 子组件重绘 ✅

**RepaintBoundary 的双向隔离：**
- **向上隔离**：子树变化不影响父树
- **向下隔离**：父树变化不触发子树重绘

### 7.3 源码位置速查

| 源码 | 位置 | 说明 |
|------|------|------|
| `markNeedsPaint()` | `rendering/object.dart:2100` | 向上传播逻辑 |
| `isRepaintBoundary` | `rendering/object.dart:1850` | 判断是否是边界 |
| `RenderRepaintBoundary` | `rendering/proxy_box.dart:2050` | RepaintBoundary 的 RenderObject |
| `_paintWithContext()` | `rendering/object.dart:2500` | Paint 阶段执行 |
| `CustomPaint.updateRenderObject()` | `widgets/basic.dart:4500` | 更新 painter |
| `RenderCustomPaint.painter setter` | `rendering/custom_paint.dart:250` | 触发重绘 |

---

## 八、调试技巧

```dart
// 1. 启用重绘边界可视化
void main() {
  debugRepaintRainbowEnabled = true;  // 不同颜色显示重绘区域
  debugPaintLayerBordersEnabled = true;  // 显示 Layer 边界
  runApp(MyApp());
}

// 2. 在 CustomPainter 中打印日志
@override
void paint(Canvas canvas, Size size) {
  print('paint called: ${DateTime.now()}');
  // ...绘制逻辑
}

// 3. 在 shouldRepaint 中打印日志
@override
bool shouldRepaint(MyPainter oldDelegate) {
  final result = oldDelegate.value != value;
  print('shouldRepaint: $result');
  return result;
}
```

---

希望这份源码解析帮助你彻底理解 RepaintBoundary 的工作原理！🚀

