# Flutter 使用 iOS 原生组件（Platform View）

## 📖 概述

这个示例展示了如何在 Flutter 中嵌入和使用 iOS 原生 UIView 组件。

## 🗂 文件说明

- [`IOSNativeComponentDemoPage.dart`](IOSNativeComponentDemoPage.dart) - Flutter 页面，展示如何使用原生组件
- [`IOSNativeUIKitView.dart`](IOSNativeUIKitView.dart) - Platform View 桥接组件，连接 Flutter 和原生视图
- [`IOSNativeGestureOverlapTestPage.dart`](IOSNativeGestureOverlapTestPage.dart) 是重叠手势验证页，从主示例点按钮进入。

## 🔗 对应的 iOS 原生文件

iOS 原生实现位于：`ios/Runner/EmbedNativeInFlutter/`
- **IOSNativeView.swift** - 原生 UIView 实现
- **IOSNativeViewFactory.swift** - 视图工厂和注册管理

## 🚀 使用方法

### 1. 在路由中配置（已配置）

```dart
GoRoute(
  path: "/native_test_page",
  builder: (context, state) => const IOSNativeComponentDemoPage(),
),
```

### 2. 在页面中使用

```dart
Container(
  width: 300,
  height: 200,
  child: const IOSNativeUIKitView(),  // 使用原生视图
)
```

## 🎯 实现原理

```
Flutter Widget
    ↓
UiKitView (桥接)
    ↓
FlutterPlatformView
    ↓
iOS UIView
```

## ⚙️ 关键配置

### viewType 标识符必须一致

**Flutter 端：**
```dart
UiKitView(viewType: "native_test_view")
```

**iOS 端：**
```swift
registrar.register(factory, withId: "native_test_view")
```

### 参数传递

**Flutter → iOS：**
```dart
UiKitView(
  viewType: "native_test_view",
  creationParams: {
    "title": "测试",
    "color": "#0000FF"
  },
)
```

**iOS 接收：**
```swift
init(frame: CGRect, viewId: Int64, args: Any?) {
  if let params = args as? [String: Any] {
    let title = params["title"] as? String
  }
}
```

## 💡 注意事项

1. **性能考虑**
   - Platform View 有额外的图层合成开销
   - 避免同时使用大量 Platform View
   - 不要频繁创建和销毁

2. **布局尺寸**
   - `init` 中的 frame 通常是 0
   - 真实尺寸在 `layoutSubviews()` 中获取

3. **注册时机**
   - 必须在 AppDelegate 的 `didFinishLaunchingWithOptions` 中注册
   - 在使用前完成注册

## 🛠 扩展新的原生组件

### Step 1: 创建 Flutter 桥接组件

```dart
// lib/module/usecase/pages/platform/flutter_use_native/MyCustomView.dart
class MyCustomView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UiKitView(
      viewType: "my_custom_view",  // 唯一标识符
      creationParams: {},
      creationParamsCodec: StandardMessageCodec(),
    );
  }
}
```

### Step 2: 创建 iOS 原生视图

```swift
// ios/Runner/EmbedNativeInFlutter/MyCustomView.swift
class MyCustomView: NSObject, FlutterPlatformView {
    private var _view: UIView
    
    init(frame: CGRect, viewId: Int64, args: Any?) {
        _view = UIView(frame: frame)
        _view.backgroundColor = .red
        super.init()
    }
    
    func view() -> UIView {
        return _view
    }
}
```

### Step 3: 创建工厂并注册

```swift
// ios/Runner/EmbedNativeInFlutter/MyCustomViewFactory.swift
class MyCustomViewFactory: NSObject, FlutterPlatformViewFactory {
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return MyCustomView(frame: frame, viewId: viewId, args: args)
    }
}

// 在 FlutterRegister 类中添加注册方法
extension FlutterRegister {
    static func registerMyCustomView(appdelegate: FlutterAppDelegate) {
        guard let registrar = appdelegate.registrar(forPlugin: "MyCustomView") else {
            return
        }
        let factory = MyCustomViewFactory()
        registrar.register(factory, withId: "my_custom_view")
    }
}
```

### Step 4: 在 AppDelegate 中注册

```swift
override func application(...) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    FlutterRegister.registerTestView(appdelegate: self)
    FlutterRegister.registerMyCustomView(appdelegate: self)  // 新增
    
    return super.application(...)
}
```

## 🔍 调试技巧

### 查看日志

代码中已添加详细日志，查看 Xcode 控制台：
- 🔵 表示初始化
- ✅ 表示成功
- ❌ 表示错误

### 常见问题排查

**问题：原生视图不显示**
- 检查 viewType 是否一致
- 检查是否在 AppDelegate 中注册
- 查看控制台是否有错误日志

**问题：尺寸不对**
- 在 `layoutSubviews()` 中处理布局
- 不要依赖 `init` 中的 frame

**问题：参数传递失败**
- 检查参数类型是否可序列化
- 使用 `StandardMessageCodec` 编码器
- 在 iOS 端添加类型判断和容错

## 📚 更多资源

- [Platform Views 官方文档](https://docs.flutter.dev/platform-integration/platform-views)
- [UiKitView API 文档](https://api.flutter.dev/flutter/widgets/UiKitView-class.html)

