# Flutter Platform View 集成指南

这是一个完整的 Flutter 与 iOS 原生视图集成的实现说明。

## 📁 文件结构

```
flutter_study/
├── ios/Runner/
│   ├── AppDelegate.swift                          # 应用启动入口
│   └── flutter-widget/
│       ├── FlutterRegister.swift                  # Platform View 注册器
│       └── test/
│           ├── NativeTestViewFactory.swift        # 视图工厂
│           └── NativeTestView.swift               # 原生视图实现
│
└── lib/module/usecase/pages/platform/
    ├── NativeTestView.dart                        # Flutter 包装组件
    └── NativeTestPage.dart                        # 使用示例页面
```

---

## 🔧 实现步骤

### 步骤 1：iOS 端 - 创建原生视图（NativeTestView.swift）

**文件位置**: `ios/Runner/flutter-widget/test/NativeTestView.swift`

```swift
import UIKit
import Flutter

// 实现 FlutterPlatformView 协议
class NativeTestView: NSObject, FlutterPlatformView {
  private var _view: CustomNativeView
  
  init(frame: CGRect, viewId: Int64, args: Any?) {
    print("🔵 初始 frame: \(frame)")
    _view = CustomNativeView(frame: frame)
    super.init()
  }
  
  // 必须实现：返回原生视图
  func view() -> UIView {
    return _view
  }
}

// 自定义 UIView 来监听布局变化
class CustomNativeView: UIView {
  private var label: UILabel!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    backgroundColor = .systemBlue
    
    // 创建标签
    label = UILabel()
    label.numberOfLines = 0
    label.textAlignment = .center
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    addSubview(label)
  }
  
  // 🔑 关键：在这里接收 Flutter 传递的真正尺寸
  override func layoutSubviews() {
    super.layoutSubviews()
    
    // 这里会接收到真正的布局尺寸
    let width = bounds.size.width
    let height = bounds.size.height
    
    print("✅ layoutSubviews 接收到的尺寸 - 宽: \(width), 高: \(height)")
    
    // 更新标签的 frame 和内容
    label.frame = bounds
    label.text = "Native iOS View\n宽: \(Int(width))\n高: \(Int(height))"
  }
}
```

**要点**：
- `init(frame:viewId:args:)` 的初始 frame 通常为零
- 真正的尺寸通过 `layoutSubviews()` 获取
- 使用 `bounds` 而不是 `frame` 来获取正确的尺寸

---

### 步骤 2：iOS 端 - 创建视图工厂（NativeTestViewFactory.swift）

**文件位置**: `ios/Runner/flutter-widget/test/NativeTestViewFactory.swift`

```swift
import UIKit
import Flutter

class NativeTestViewFactory: NSObject, FlutterPlatformViewFactory {
  // 工厂方法：创建原生视图实例
  func create(
    withFrame frame: CGRect, 
    viewIdentifier viewId: Int64, 
    arguments args: Any?
  ) -> FlutterPlatformView {
    print("create NativeTestView")
    print("frame: \(frame)")
    print("viewId: \(viewId)")
    print("args: \(args)")
    return NativeTestView(frame: frame, viewId: viewId, args: args)
  }
}
```

**要点**：
- 实现 `FlutterPlatformViewFactory` 协议
- `create()` 方法负责创建视图实例
- `viewId` 是 Flutter 分配的唯一 ID
- `args` 可以接收 Flutter 传递的参数

---

### 步骤 3：iOS 端 - 注册视图（FlutterRegister.swift）

**文件位置**: `ios/Runner/flutter-widget/FlutterRegister.swift`

```swift
import Foundation

class FlutterRegister {
    class func registerTestView(appdelegate: AppDelegate) {
        print("registerTestView")
        
        // 获取注册器
        guard let register = appdelegate.registrar(forPlugin: "test_view") else {
            print("registerTestView failed")
            fatalError()
        }
        
        print("registerTestView success")
        
        // 注册视图工厂，viewType 为 "native_test_view"
        register.register(NativeTestViewFactory(), withId: "native_test_view")
        
        print("registerTestView success")
    }
}
```

**要点**：
- `forPlugin` 参数是插件标识符（可以自定义）
- `withId` 参数必须与 Flutter 端的 `viewType` 一致

---

### 步骤 4：iOS 端 - 在 AppDelegate 中调用注册（AppDelegate.swift）

**文件位置**: `ios/Runner/AppDelegate.swift`

```swift
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // 🔑 关键：注册原生视图
    FlutterRegister.registerTestView(appdelegate: self)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

**要点**：
- 必须在 `didFinishLaunchingWithOptions` 中注册
- 在 `GeneratedPluginRegistrant.register` 之后调用

---

### 步骤 5：Flutter 端 - 创建包装组件（NativeTestView.dart）

**文件位置**: `lib/module/usecase/pages/platform/NativeTestView.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NativeTestView extends HookWidget {
  const NativeTestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 🔑 关键：viewType 必须与 iOS 端注册的 ID 一致
    const String viewType = "native_test_view";
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return UiKitView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
```

**要点**：
- 使用 `UiKitView`（iOS）或 `AndroidView`（Android）
- `viewType` 必须与原生端注册的 ID 一致
- `creationParams` 可以传递参数给原生端

---

### 步骤 6：Flutter 端 - 使用示例（NativeTestPage.dart）

**文件位置**: `lib/module/usecase/pages/platform/NativeTestPage.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_study/module/platform/NativeTestView.dart';

class NativeTestPage extends HookWidget {
  NativeTestPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("NativeTestPage")),
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          color: Colors.red.withOpacity(0.2), // 红色边框，用于调试
          child: NativeTestView(),
        ),
      ),
    );
  }
}
```

**要点**：
- 使用 `Center` 打破 `Scaffold` 的强制约束
- 使用 `Container` 或 `SizedBox` 指定尺寸
- Flutter 会自动将尺寸传递给原生视图

---

## 🔄 数据流程

```
Flutter 端                                iOS 端
─────────────────────────────────────────────────────────

1. NativeTestPage.dart
   └─ Container(width: 200, height: 200)
      └─ NativeTestView.dart
         └─ UiKitView(viewType: "native_test_view")
                                           │
                                           ▼
                              2. AppDelegate.swift
                                 └─ FlutterRegister.registerTestView()
                                    └─ register.register(withId: "native_test_view")
                                           │
                                           ▼
                              3. NativeTestViewFactory.swift
                                 └─ create(withFrame: frame) [frame 可能为零]
                                    │
                                    ▼
                              4. NativeTestView.swift
                                 └─ init(frame: frame)
                                    └─ CustomNativeView
                                       │
                                       ▼
                              5. CustomNativeView.layoutSubviews()
                                 └─ 接收真正的尺寸 (200x200) ✅
```

---

## 🎯 关键知识点

### 1. 尺寸传递机制

| 时机 | frame/bounds | 说明 |
|------|--------------|------|
| `create(withFrame:)` | 通常为 (0, 0, 0, 0) | 初始调用时尺寸未确定 |
| `layoutSubviews()` | 正确的尺寸 | Flutter 布局完成后调用 |

### 2. 使用 bounds 而不是 frame

```swift
// ❌ 错误：frame 相对于父视图
let size = self.frame.size

// ✅ 正确：bounds 是视图自身的坐标系
let size = self.bounds.size
```

### 3. Flutter 端尺寸控制

```dart
// ❌ 错误：Container 的尺寸被 Scaffold 覆盖
body: Container(width: 200, height: 200, child: NativeTestView())

// ✅ 正确：使用 Center 打破强制约束
body: Center(
  child: Container(width: 200, height: 200, child: NativeTestView())
)
```

---

## 🐛 常见问题

### Q1: frame 为什么是 (0, 0, 0, 0)？

**A**: 这是正常的。`create(withFrame:)` 在视图添加到布局树之前调用，此时尺寸未确定。真正的尺寸会通过 `layoutSubviews()` 传递。

### Q2: 如何传递参数给原生视图？

**A**: 通过 `creationParams` 传递：

```dart
// Flutter 端
final Map<String, dynamic> creationParams = {
  'title': 'Hello',
  'count': 42,
};
```

```swift
// iOS 端
init(frame: CGRect, viewId: Int64, args: Any?) {
  if let params = args as? [String: Any] {
    let title = params["title"] as? String
    let count = params["count"] as? Int
  }
}
```

### Q3: 如何实现 Flutter 和原生的双向通信？

**A**: 使用 `MethodChannel` 或 `EventChannel`，这是另一个主题。

---

## ✅ 完整的实现清单

- [x] 创建 `NativeTestView.swift` - 实现原生视图
- [x] 创建 `NativeTestViewFactory.swift` - 实现视图工厂
- [x] 创建 `FlutterRegister.swift` - 封装注册逻辑
- [x] 修改 `AppDelegate.swift` - 注册视图
- [x] 创建 `NativeTestView.dart` - Flutter 包装组件
- [x] 创建 `NativeTestPage.dart` - 使用示例

---

## 📚 扩展阅读

- [Flutter Platform Views 官方文档](https://docs.flutter.dev/platform-integration/ios/platform-views)
- [UiKitView API 文档](https://api.flutter.dev/flutter/widgets/UiKitView-class.html)
- [FlutterPlatformView 协议文档](https://api.flutter.dev/objcdoc/Protocols/FlutterPlatformView.html)

---

**创建日期**: 2025-11-11  
**作者**: AI Assistant  
**项目**: flutter_study

