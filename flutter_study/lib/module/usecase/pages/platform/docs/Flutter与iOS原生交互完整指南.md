# Flutter 与 iOS 原生交互完整指南

本项目包含两种 Flutter 与 iOS 原生交互的完整示例，适合初学者快速理解和上手。

---

## 📋 目录结构

```
flutter_study/
├── lib/examples/
│   ├── flutter_use_native/          # 场景一：Flutter 中使用 iOS 原生组件
│   │   ├── NativeTestPage.dart      # Flutter 页面
│   │   └── NativeTestView.dart      # Platform View 桥接组件
│   └── native_use_flutter/          # 场景二：iOS 原生中使用 Flutter Widget（预留）
│
└── ios/Runner/
    ├── platform-views/              # 场景一：原生 Platform View 实现
    │   ├── NativeTestView.swift     # 原生视图实现
    │   └── NativeTestViewFactory.swift  # 视图工厂和注册管理
    └── flutter-engines/             # 场景二：原生使用 Flutter 引擎
        └── FlutterWidgetVC.swift    # Flutter 视图控制器
```

---

## 🎯 场景一：Flutter 中使用 iOS 原生组件（Platform View）

### 使用场景

- 需要使用 iOS 原生的相机、地图、WebView 等组件
- 复用已有的 iOS UI 组件库
- 需要使用原生的硬件加速能力
- Flutter 无法满足某些原生 UI 需求

### 实现原理

```
Flutter Widget Tree
       ↓
   UiKitView (桥接层)
       ↓
FlutterPlatformView 协议
       ↓
   iOS UIView (原生视图)
```

### 实现步骤

#### 1. Flutter 端实现

**创建 Platform View 组件** (`NativeTestView.dart`)

```dart
class NativeTestView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    const String viewType = "native_test_view";  // 与 iOS 端注册的标识符一致
    
    return UiKitView(
      viewType: viewType,
      creationParams: <String, dynamic>{},  // 传递给原生的参数
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
```

**在页面中使用** (`NativeTestPage.dart`)

```dart
class NativeTestPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("原生组件示例")),
      body: Container(
        width: 300,
        height: 200,
        child: NativeTestView(),  // 使用原生组件
      ),
    );
  }
}
```

#### 2. iOS 端实现

**创建原生视图** (`NativeTestView.swift`)

```swift
class NativeTestView: NSObject, FlutterPlatformView {
    private var _view: CustomNativeView
    
    init(frame: CGRect, viewId: Int64, args: Any?) {
        _view = CustomNativeView(frame: frame)
        super.init()
    }
    
    func view() -> UIView {
        return _view
    }
}

class CustomNativeView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 设置你的 UI
        backgroundColor = .systemBlue
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 这里可以获取到真实的布局尺寸
        print("真实尺寸: \(bounds.size)")
    }
}
```

**创建视图工厂** (`NativeTestViewFactory.swift`)

```swift
class NativeTestViewFactory: NSObject, FlutterPlatformViewFactory {
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return NativeTestView(frame: frame, viewId: viewId, args: args)
    }
}

// 注册管理类
class FlutterRegister {
    static func registerTestView(appdelegate: FlutterAppDelegate) {
        guard let registrar = appdelegate.registrar(forPlugin: "NativeTestView") else {
            return
        }
        
        let factory = NativeTestViewFactory()
        registrar.register(factory, withId: "native_test_view")  // 标识符与 Flutter 端一致
    }
}
```

**在 AppDelegate 中注册** (`AppDelegate.swift`)

```swift
@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        // 注册 Platform View
        FlutterRegister.registerTestView(appdelegate: self)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
```

#### 3. 注册路由

在 `RouterConfig.dart` 中添加路由：

```dart
GoRoute(
  path: "/native_test_page",
  builder: (context, state) => NativeTestPage(),
),
```

### 关键点说明

1. **viewType 标识符必须一致**
   - Flutter: `UiKitView(viewType: "native_test_view")`
   - iOS: `registrar.register(factory, withId: "native_test_view")`

2. **参数传递**
   - Flutter 端通过 `creationParams` 传递
   - iOS 端在 `init(frame:viewId:args:)` 中接收

3. **布局尺寸**
   - `init` 中的 frame 通常是 0
   - 真实尺寸在 `layoutSubviews()` 中获取

4. **性能考虑**
   - Platform View 有额外的图层合成开销
   - 适量使用，避免嵌套过深

---

## 🎯 场景二：iOS 原生中使用 Flutter Widget

### 使用场景

- 在现有 iOS 应用中集成 Flutter 功能模块
- 将 Flutter 页面作为原生应用的一部分
- 混合开发场景，部分功能用 Flutter 实现

### 为什么使用 FlutterEngineGroup？

#### 传统方案的问题

使用单个 `FlutterEngine`：
```swift
let engine = FlutterEngine()  // 每次创建约占用 60-80MB 内存
```

**缺点：**
- 每个 engine 独立占用内存（60-80MB）
- 启动时间长（首次约 300ms）
- 资源无法共享

#### FlutterEngineGroup 的优势

```swift
static let engineGroup = FlutterEngineGroup(name: "MyGroup", project: nil)
let engine = engineGroup.makeEngine(with: options)
```

**优点对比：**

| 特性 | 单个 Engine | EngineGroup |
|-----|------------|-------------|
| 首次启动 | 约 300ms | 约 300ms |
| 后续启动 | 约 300ms | 约 30-50ms ⚡️ |
| 首个内存 | 60-80MB | 60-80MB |
| 后续内存 | 60-80MB | 10-20MB 💾 |
| Dart VM | 每个独立 | 共享同一个 ✅ |
| 资源共享 | 不共享 | 共享代码、资源 ✅ |
| 路由隔离 | ✅ | ✅ |
| 状态隔离 | ✅ | ✅ |

**资源共享机制：**
- **共享：** Dart VM、Isolate Group Snapshot、代码、资源文件
- **独立：** Widget Tree、State、路由栈、内存状态

### 实现步骤

#### 1. 创建 FlutterWidgetVC (`FlutterWidgetVC.swift`)

```swift
class FlutterWidgetVC: UIViewController {
    // 静态的 EngineGroup，全局共享
    static let engineGroup = FlutterEngineGroup(
        name: "FlutterWidgetVCGroup",
        project: nil
    )
    
    private var engine: FlutterEngine?
    private var flutterVC: FlutterViewController?
    var targetRoute: String = "/"
    
    // 便捷初始化
    convenience init(route: String) {
        self.init(nibName: nil, bundle: nil)
        self.targetRoute = route
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFlutterVC()
    }
    
    private func loadFlutterVC() {
        // 配置选项
        let options = FlutterEngineGroupOptions()
        options.initialRoute = targetRoute  // 设置初始路由
        
        // 从 group 创建 engine（复用资源）
        let flutterEngine = Self.engineGroup.makeEngine(with: options)
        self.engine = flutterEngine
        flutterEngine.run()
        
        // 创建 FlutterViewController
        let newVC = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        self.flutterVC = newVC
        
        // 添加到视图层级
        if let flutterView = newVC.view {
            flutterView.frame = self.view.bounds
            flutterView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.addSubview(flutterView)
            
            self.addChild(newVC)
            newVC.didMove(toParent: self)
        }
    }
    
    deinit {
        // 清理资源
        flutterVC?.willMove(toParent: nil)
        flutterVC?.view.removeFromSuperview()
        flutterVC?.removeFromParent()
        engine = nil
    }
}
```

#### 2. 在 iOS 原生代码中使用

**方式一：Push 导航**
```swift
let flutterVC = FlutterWidgetVC(route: "/canvas_page")
navigationController?.pushViewController(flutterVC, animated: true)
```

**方式二：Modal 展示**
```swift
let flutterVC = FlutterWidgetVC(route: "/home")
flutterVC.modalPresentationStyle = .fullScreen
present(flutterVC, animated: true)
```

**方式三：嵌入容器**
```swift
let flutterVC = FlutterWidgetVC(route: "/settings")
addChild(flutterVC)
containerView.addSubview(flutterVC.view)
flutterVC.view.frame = containerView.bounds
flutterVC.didMove(toParent: self)
```

#### 3. Flutter 端配置路由

在 `RouterConfig.dart` 中确保有对应的路由：

```dart
GoRoute(
  path: "/canvas_page",
  builder: (context, state) => CanvasPage(),
),
```

### 性能对比示例

假设你的 iOS 应用需要在 5 个地方使用 Flutter 页面：

**使用单个 FlutterEngine：**
- 总内存：5 × 70MB = 350MB
- 每次启动：300ms

**使用 FlutterEngineGroup：**
- 总内存：70MB + 4 × 15MB = 130MB（节省 220MB）
- 首次启动：300ms
- 后续启动：40ms（快 7.5 倍）

### 生命周期管理

```swift
// ✅ 正确的使用方式
func openFlutter() {
    let vc = FlutterWidgetVC(route: "/page")
    present(vc, animated: true)
    // 当 vc 被 dismiss 时，会自动执行 deinit 清理资源
}

// ❌ 错误的使用方式
class MyViewController {
    var flutterVC: FlutterWidgetVC?  // 强引用
    
    func openFlutter() {
        flutterVC = FlutterWidgetVC(route: "/page")
        present(flutterVC!, animated: true)
        // 导致 flutterVC 无法释放，内存泄漏
    }
}
```

---

## 🔄 两种场景的对比

| 维度 | Flutter 使用原生 | 原生使用 Flutter |
|-----|----------------|----------------|
| **方向** | Flutter → iOS | iOS → Flutter |
| **核心技术** | Platform View | Flutter Engine |
| **Flutter 文件** | `UiKitView` | 路由配置 |
| **iOS 文件** | Factory + View | `FlutterViewController` |
| **注册位置** | AppDelegate | 无需注册 |
| **性能开销** | 图层合成开销 | 内存占用 |
| **适用场景** | 调用原生能力 | 混合应用开发 |
| **通信方式** | MethodChannel | MethodChannel |

---

## 📝 快速开始

### 测试场景一：Flutter 使用原生组件

1. 运行应用
2. 在首页点击 "Native Test"
3. 查看蓝色的 iOS 原生 UIView

### 测试场景二：原生使用 Flutter

1. 运行应用
2. 等待 3 秒，会出现 "打开 Flutter 页面" 按钮
3. 点击按钮打开 Flutter Canvas 页面
4. 这个页面是在原生 iOS 中加载的 Flutter Widget

---

## 🛠 常见问题

### Q1: Platform View 性能问题？
**A:** Platform View 会创建额外的图层，有性能开销。建议：
- 避免频繁创建和销毁
- 避免大量 Platform View 同时存在
- 考虑使用 Hybrid Composition（iOS 13+）

### Q2: FlutterEngineGroup 何时使用？
**A:** 当你需要在原生应用中多次使用 Flutter 页面时：
- 1-2 个页面：可以用单个 Engine
- 3+ 个页面：强烈建议使用 EngineGroup

### Q3: 如何传递复杂数据？
**A:** 两种场景都可以使用 MethodChannel：
```dart
// Flutter 端
static const platform = MethodChannel('com.example/channel');
await platform.invokeMethod('getData');

// iOS 端
let channel = FlutterMethodChannel(name: "com.example/channel", binaryMessenger: controller)
channel.setMethodCallHandler { (call, result) in
    if call.method == "getData" {
        result("返回的数据")
    }
}
```

### Q4: 如何调试？
**A:** 
- Flutter 端：使用 `print()` 和 DevTools
- iOS 端：使用 `print()` 和 Xcode 控制台
- 查看日志中的 emoji 标记（🔵、✅、❌）定位问题

---

## 📚 学习资源

- [Flutter Platform Views 官方文档](https://docs.flutter.dev/platform-integration/platform-views)
- [Flutter Engine Group 官方文档](https://api.flutter.dev/flutter/dart-ui/PlatformDispatcher/views.html)
- [Add Flutter to existing app](https://docs.flutter.dev/add-to-app)

---

## 💡 最佳实践

1. **命名规范**
   - Platform View ID 使用下划线：`native_test_view`
   - Swift 类名使用大驼峰：`NativeTestView`

2. **目录组织**
   - Flutter 代码放在 `lib/examples/`
   - iOS 代码按功能分类到 `platform-views/` 和 `flutter-engines/`

3. **资源清理**
   - 始终在 `deinit` 中清理资源
   - 使用 weak 引用避免循环引用

4. **错误处理**
   - 添加详细的日志输出
   - 使用 emoji 标记不同类型的日志
   - 处理所有可能的 nil 情况

---

## 🎓 总结

- **场景一（Flutter 使用原生）**：当 Flutter 能力不足时，桥接原生组件
- **场景二（原生使用 Flutter）**：在原生应用中集成 Flutter 功能模块
- **FlutterEngineGroup**：多次使用 Flutter 时的最佳实践，节省内存和启动时间

通过本项目的示例代码，你可以快速理解和实现这两种场景，开始你的 Flutter 混合开发之旅！🚀

