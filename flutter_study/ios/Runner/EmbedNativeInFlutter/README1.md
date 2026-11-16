# 在 Flutter 中嵌入原生组件

## 📖 概述

这个目录包含了**在 Flutter 中嵌入 iOS 原生 UIView 组件**的实现代码。

## 🎯 使用场景

```
┌──────────────────────┐
│   Flutter 页面        │
│  ┌────────────────┐  │
│  │  iOS 原生 UIView │  │  ← 这是本目录实现的功能
│  │  (Swift/UIKit)  │  │
│  └────────────────┘  │
└──────────────────────┘
```

**适用情况：**
- Flutter 无法实现某些原生功能（相机、地图等）
- 需要复用已有的 iOS UI 组件库
- 需要使用原生的硬件加速能力
- 集成第三方 iOS SDK 的原生 UI

## 📁 文件说明

- **IOSNativeView.swift** - iOS 原生 UIView 实现
- **IOSNativeViewFactory.swift** - 工厂类和注册管理

## 🔗 对应的 Flutter 文件

Flutter 端实现位于：`lib/module/platform/flutter_use_native/`
- **IOSNativeUIKitView.dart** - Platform View 桥接组件
- **IOSNativeComponentDemoPage.dart** - 演示页面

## ⚙️ 使用步骤

### 1. iOS 端注册（AppDelegate.swift）

```swift
PlatformViewRegister.registerIOSNativeView(appDelegate: self)
```

### 2. Flutter 端使用

```dart
Container(
  width: 300,
  height: 200,
  child: IOSNativeUIKitView(),  // iOS 原生组件
)
```

## 💡 关键点

- **viewType 标识符：** `"native_test_view"`（Flutter 和 iOS 必须一致）
- **参数传递：** 通过 `creationParams` 传递，在 `init(args:)` 接收
- **真实尺寸：** 在 `layoutSubviews()` 中获取

## 🚀 扩展新组件

1. 创建新的 View 类，继承 `NSObject` 并实现 `FlutterPlatformView`
2. 创建对应的 Factory 类
3. 在 `PlatformViewRegister` 中添加注册方法
4. 在 AppDelegate 中调用注册
5. 在 Flutter 端创建对应的 UiKitView

## 📚 技术原理

**Platform View 机制：**
- Flutter 使用 `UiKitView` 创建一个占位符
- iOS 端通过 `FlutterPlatformView` 协议提供真实的 UIView
- Flutter 引擎会将 UIView 嵌入到渲染树中
- 需要额外的图层合成，有一定性能开销

