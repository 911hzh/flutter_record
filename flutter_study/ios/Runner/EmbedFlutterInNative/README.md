# 在原生中嵌入 Flutter

## 📖 概述

这个目录包含了**在 iOS 原生应用中嵌入 Flutter 页面**的实现代码。

## 🎯 使用场景

```
┌──────────────────────┐
│   iOS 原生应用        │
│  ┌────────────────┐  │
│  │  Flutter 页面   │  │  ← 这是本目录实现的功能
│  │  (Dart/Widget)  │  │
│  └────────────────┘  │
└──────────────────────┘
```

**适用情况：**
- 在现有 iOS 应用中集成 Flutter 功能模块
- 混合开发，部分功能用 Flutter 实现
- 需要在多个地方复用 Flutter UI
- 逐步迁移原生应用到 Flutter

## 📁 文件说明

- **FlutterWidgetVC.swift** - Flutter 视图控制器，用于在原生中显示 Flutter 页面

## 🔑 FlutterEngineGroup

使用 `FlutterEngineGroup` 来优化性能：

| 指标 | 单个 Engine | EngineGroup | 节省 |
|-----|-----------|-------------|-----|
| 首个内存 | 60-80MB | 60-80MB | - |
| 后续内存 | 60-80MB | 10-20MB | **75%** |
| 首次启动 | 300ms | 300ms | - |
| 后续启动 | 300ms | 40ms | **87%** |

## 🚀 使用方法

### 1. Push 导航

```swift
let flutterVC = FlutterWidgetVC(route: "/canvas_page")
navigationController?.pushViewController(flutterVC, animated: true)
```

### 2. Modal 展示

```swift
let flutterVC = FlutterWidgetVC(route: "/home")
flutterVC.modalPresentationStyle = .fullScreen
present(flutterVC, animated: true)
```

### 3. 嵌入容器

```swift
let flutterVC = FlutterWidgetVC(route: "/settings")
addChild(flutterVC)
containerView.addSubview(flutterVC.view)
flutterVC.view.frame = containerView.bounds
flutterVC.didMove(toParent: self)
```

## 📝 注意事项

- ✅ 确保 Flutter 端有对应的路由配置
- ✅ 使用局部变量或 weak 引用，避免内存泄漏
- ✅ 首次启动约 300ms，后续约 40ms
- ✅ `deinit` 会自动清理资源

## 🔗 对应的 Flutter 配置

在 `lib/config/RouterConfig.dart` 中配置路由：

```dart
GoRoute(
  path: "/canvas_page",
  builder: (context, state) => CanvasPage(),
),
```

## 📚 技术原理

**FlutterEngineGroup 工作机制：**
1. 第一个 engine 启动 Dart VM 和加载代码
2. 后续 engine 共享 VM 和代码，只创建新的 isolate
3. 每个 engine 有独立的路由栈和状态
4. 内存和启动速度都得到显著优化

