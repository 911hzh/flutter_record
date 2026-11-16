# Flutter 与 iOS 原生交互核心技术

## 一、iOS 嵌入 Flutter 页面

### 1.1 实现原理

在现有 iOS 应用中嵌入 Flutter 页面，需要使用 `FlutterEngineGroup` 和 `FlutterViewController`。

**核心流程：**
1. 创建全局共享的 `FlutterEngineGroup` 实例
2. 从 group 创建 `FlutterEngine`（复用共享资源）
3. 设置 `initialRoute` 指定要打开的 Flutter 路由
4. 用 engine 创建 `FlutterViewController`
5. 将 FlutterViewController 添加到视图层级
6. 在 `deinit` 中清理资源

**关键点：**
- 使用 static 的 `FlutterEngineGroup` 实现资源共享
- 通过 `initialRoute` 指定 Flutter 路由
- 正确管理视图控制器的生命周期


**效果图：**


**完整实现代码：**

```swift
class FlutterWidgetVC: UIViewController {
    // 全局共享的 EngineGroup
    static let engineGroup = FlutterEngineGroup(name: "MyGroup", project: nil)
    
    private var engine: FlutterEngine?
    private var flutterVC: FlutterViewController?
    var targetRoute: String = "/"
    
    convenience init(route: String) {
        self.init(nibName: nil, bundle: nil)
        self.targetRoute = route
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. 配置路由
        let options = FlutterEngineGroupOptions()
        options.initialRoute = targetRoute
        
        // 2. 从 group 创建 engine（共享资源）
        let flutterEngine = Self.engineGroup.makeEngine(with: options)
        self.engine = flutterEngine
        flutterEngine.run()
        
        // 3. 创建 FlutterViewController
        let newVC = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        self.flutterVC = newVC
        
        // 4. 添加到视图
        newVC.view.frame = self.view.bounds
        newVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(newVC.view)
        self.addChild(newVC)
        newVC.didMove(toParent: self)
    }
    
    deinit {
        flutterVC?.willMove(toParent: nil)
        flutterVC?.view.removeFromSuperview()
        flutterVC?.removeFromParent()
        engine = nil
    }
}
```

**使用示例：**

```swift
// 打开 Flutter 页面
let flutterVC = FlutterWidgetVC(route: "/canvas_page")
present(flutterVC, animated: true)
```

---

## 二、Flutter 嵌入 iOS 原生组件

### 2.1 实现原理

在 Flutter 中嵌入 iOS 原生组件使用 `PlatformView` 机制。

**核心流程：**
1. iOS 端创建视图类，实现 `FlutterPlatformView` 协议
2. iOS 端创建工厂类，实现 `FlutterPlatformViewFactory` 协议
3. 在 `AppDelegate` 中注册工厂类和 viewType 标识符
4. Flutter 端使用 `UiKitView` 组件，通过 viewType 引用原生视图

**关键点：**
- `viewType` 标识符必须在 Flutter 和 iOS 端保持一致
- 参数通过 `creationParams` 传递到 iOS 的 `args`
- 真实尺寸在 `layoutSubviews()` 中获取，使用 `bounds` 而非 `frame`
- 初始化时的 `frame` 通常为 (0,0,0,0)

### 2.2 参数传递协议

| Flutter 端 | iOS 端 | 说明 |
|-----------|--------|------|
| `creationParams` | `args: Any?` | 初始化参数 |
| `Map<String, dynamic>` | `[String: Any]?` | 字典类型 |
| `StandardMessageCodec` | `FlutterStandardMessageCodec` | 序列化编码器 |
| `onPlatformViewCreated` | - | 视图创建完成回调 |

**参数解析示例：**
```swift
// 在 init 中解析 Flutter 传递的参数
init(frame: CGRect, viewId: Int64, args: Any?) {
    if let params = args as? [String: Any] {
        let title = params["title"] as? String
        let color = params["color"] as? String
    }
}
```

### 2.3 FlutterPlatformView 协议实现

协议要求实现 `view()` 方法，返回要显示的 UIView。

**iOS 视图实现代码：**

```swift
class IOSNativeView: NSObject, FlutterPlatformView {
    private var _view: CustomNativeView
    
    init(frame: CGRect, viewId: Int64, args: Any?) {
        // 解析 Flutter 传递的参数
        let params = (args as? [String: Any]) ?? [:]
        _view = CustomNativeView(frame: frame, params: params)
        super.init()
    }
    
    // 必须实现：返回原生 UIView
    func view() -> UIView {
        return _view
    }
}

class CustomNativeView: UIView {
    private let params: [String: Any]
    
    init(frame: CGRect, params: [String: Any]) {
        self.params = params
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBlue
        // 根据 params 配置 UI
    }
    
    // 真实尺寸在这里获取
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = bounds.size  // 使用 bounds 而非 frame
        // 布局子视图
    }
}
```

### 2.4 工厂类实现

工厂类负责创建 PlatformView 实例。

**工厂类代码：**

```swift
class IOSNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return IOSNativeView(frame: frame, viewId: viewId, args: args)
    }
    
    // 指定参数编码器
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
```

### 2.5 注册 Platform View

在 `AppDelegate` 的启动方法中注册 PlatformView。

**注册代码：**

```swift
@main
class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        // 注册 Platform View
        guard let registrar = registrar(forPlugin: "IOSNativeView") else {
            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
        
        let factory = IOSNativeViewFactory()
        // withId 的值必须与 Flutter 端的 viewType 一致
        registrar.register(factory, withId: "native_test_view")
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
```

### 2.6 Flutter 端使用

使用 `UiKitView` 组件引用原生视图。

**Flutter 端代码：**

```dart
class IOSNativeUIKitView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // viewType 必须与 iOS 注册的 ID 一致
    const String viewType = "native_test_view";
    
    // 传递给原生的参数
    final Map<String, dynamic> creationParams = {
      'title': 'Hello',
      'color': '#0000FF',
    };

    return UiKitView(
      viewType: viewType,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: (int id) {
        print('原生视图已创建，ID: $id');
      },
    );
  }
}
```

---

## 三、FlutterEngine vs FlutterEngineGroup

### 3.1 为什么使用 FlutterEngineGroup

当在原生应用中多次使用 Flutter 页面时，使用独立的 `FlutterEngine` 会导致严重的内存浪费和启动延迟。`FlutterEngineGroup` 通过资源共享机制解决了这个问题。

### 3.2 内存占用对比

**官方数据（来源：Flutter 官方文档）：**

| 方案 | 首个 Engine | 后续每个 Engine | 5 个 Engine 总计 |
|-----|-----------|---------------|----------------|
| 单独的 FlutterEngine | 60-80MB | 60-80MB | 300-400MB |
| FlutterEngineGroup | 60-80MB | **约 180KB** | **约 61MB** |

**节省：** 使用 FlutterEngineGroup 可节省约 **75-85% 的内存**。

**数据来源：** [Flutter 官方文档 - Multiple Flutter instances](https://docs.flutter.dev/add-to-app/multiple-flutters)

### 3.3 启动速度对比

| 方案 | 首次启动 | 后续启动 |
|-----|---------|---------|
| 单独的 FlutterEngine | ~300ms | ~300ms |
| FlutterEngineGroup | ~300ms | **~40ms** |

**提升：** 后续启动速度提升约 **87%**。

### 3.4 资源共享机制

**FlutterEngineGroup 共享的资源：**
- Dart VM 虚拟机实例（所有 engine 共享同一个 VM）
- Isolate Group Snapshot
- GPU 渲染上下文
- 字体度量数据
- 已加载的 Dart 代码
- 资源文件（images、assets）

**每个 Engine 独立的部分：**
- Widget Tree 结构
- State 状态管理
- 路由栈
- 运行时内存状态

### 3.5 使用场景选择

**内存计算示例：**

```
❌ 不推荐：多次使用单独的 Engine
let engine1 = FlutterEngine()  // 占用 70MB
let engine2 = FlutterEngine()  // 再占用 70MB
let engine3 = FlutterEngine()  // 再占用 70MB
总计：210MB

✅ 推荐：使用 FlutterEngineGroup
static let group = FlutterEngineGroup(name: "MyGroup", project: nil)
let engine1 = group.makeEngine(with: options)  // 占用 70MB
let engine2 = group.makeEngine(with: options)  // 仅增加 180KB
let engine3 = group.makeEngine(with: options)  // 仅增加 180KB
总计：约 70.4MB，节省 139.6MB（66%）
```

**选择建议：**
- 仅使用 1-2 个 Flutter 页面 → 可以使用单个 FlutterEngine
- 使用 3 个以上 Flutter 页面 → 强烈推荐使用 FlutterEngineGroup

---

## 四、核心要点总结

### 4.1 iOS 嵌入 Flutter 关键点

| 技术点 | 要点 |
|-------|------|
| 核心类 | `FlutterEngineGroup` + `FlutterViewController` |
| 路由设置 | `options.initialRoute = "/your_route"` |
| 内存优化 | 使用 static 单例的 EngineGroup |
| 资源清理 | 在 `deinit` 中释放 engine 和 flutterVC |

### 4.2 Flutter 嵌入原生关键点

| 技术点 | 要点 |
|-------|------|
| 协议实现 | `FlutterPlatformView` 协议的 `view()` 方法 |
| 工厂类 | `FlutterPlatformViewFactory` |
| 注册位置 | `AppDelegate.didFinishLaunchingWithOptions` |
| 标识符一致性 | Flutter `viewType` = iOS `withId` |
| 参数传递 | `creationParams` → `args: Any?` → `[String: Any]` |
| 尺寸获取 | `layoutSubviews()` 中的 `bounds.size` |
| 参数编码 | `StandardMessageCodec` ↔ `FlutterStandardMessageCodec` |

### 4.3 参数传递方式

**PlatformView 初始化参数：**
```
Flutter creationParams → iOS init(args:)
```

此参数在创建原生视图时传递，用于视图的初始化配置。

---

## 五、完整示例代码位置

```
flutter_study/
├── ios/Runner/
│   ├── AppDelegate.swift                    # 应用启动入口，注册 PlatformView
│   ├── PlatformViewRegister.swift           # PlatformView 注册管理类
│   ├── EmbedFlutterInNative/
│   │   └── FlutterWidgetVC.swift            # iOS 嵌入 Flutter 的实现
│   └── EmbedNativeInFlutter/
│       ├── IOSNativeView.swift              # 原生视图实现
│       └── IOSNativeViewFactory.swift       # 视图工厂实现
└── lib/module/platform/flutter_use_native/
    ├── IOSNativeUIKitView.dart              # Flutter 桥接组件
    └── IOSNativeComponentDemoPage.dart      # 使用示例页面
```

---

## 六、关键细节注意事项

### 6.1 viewType 标识符必须一致

Flutter 和 iOS 端的标识符必须完全一致，否则会找不到对应的原生视图：

```dart
// Flutter 端
UiKitView(viewType: "native_test_view")

// iOS 端
registrar.register(factory, withId: "native_test_view")
```

### 6.2 尺寸传递时机

| 方法 | frame/bounds 值 | 说明 |
|------|----------------|------|
| `create(withFrame:)` | 通常为 (0,0,0,0) | 初始调用时尺寸未确定 |
| `init(frame:)` | 通常为 (0,0,0,0) | 视图初始化时 |
| `layoutSubviews()` | **正确的尺寸** | Flutter 布局完成后调用 |

**正确做法：** 在 `layoutSubviews()` 中使用 `bounds.size` 获取尺寸。

### 6.3 资源清理

**iOS 嵌入 Flutter：** 必须在 `deinit` 中清理资源，避免内存泄漏。

**Flutter 嵌入原生：** PlatformView 由 Flutter 引擎自动管理生命周期。

---

**参考文档：**
- [Flutter Platform Views](https://docs.flutter.dev/platform-integration/platform-views)
- [Add Flutter to iOS app](https://docs.flutter.dev/add-to-app/ios)
- [Multiple Flutter instances](https://docs.flutter.dev/add-to-app/multiple-flutters)
