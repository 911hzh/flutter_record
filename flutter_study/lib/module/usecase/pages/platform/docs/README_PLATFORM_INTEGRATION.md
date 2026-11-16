# 🚀 Flutter 与 iOS 原生交互项目

## 📁 快速导航

本项目包含两种 Flutter 与 iOS 原生交互的完整示例：

### 📘 [完整指南](Flutter与iOS原生交互完整指南.md)
详细的技术文档，包含原理、实现、性能对比等

---

## 🎯 两种使用场景

### 场景一：Flutter 使用 iOS 原生组件

**目录位置：**
```
lib/module/usecase/pages/platform/flutter_use_native/
├── IOSNativeComponentDemoPage.dart         # Flutter 页面
├── IOSNativeUIKitView.dart         # Platform View 桥接
└── README.md                   # 详细说明

ios/Runner/EmbedNativeInFlutter/
├── IOSNativeView.swift        # 原生视图实现
└── IOSNativeViewFactory.swift # 工厂和注册
```

**使用场景：**
- 使用原生相机、地图、WebView
- 复用已有的 iOS UI 组件
- Flutter 无法满足的原生需求

**核心技术：** UiKitView + FlutterPlatformView

**📚 [查看详细文档](../flutter_use_native/README.md)**

---

### 场景二：iOS 原生使用 Flutter Widget

**目录位置：**
```
ios/Runner/EmbedFlutterInNative/
├── FlutterWidgetVC.swift       # Flutter 视图控制器
└── README.md                   # 详细说明
```

**使用场景：**
- 在现有 iOS 应用中集成 Flutter
- 混合开发，部分功能用 Flutter 实现
- 需要在多个地方复用 Flutter UI

**核心技术：** FlutterEngineGroup + FlutterViewController

**📚 [查看详细文档](../../../../../../ios/Runner/EmbedFlutterInNative/README.md)**

---

## ⚡️ 快速开始

### 运行项目

```bash
# 1. 安装依赖
flutter pub get

# 2. 运行 iOS 模拟器或真机
flutter run

# 3. 在首页选择对应的示例
```

### 测试场景一（Flutter 使用原生）

1. 运行应用
2. 点击首页的 **"Native Test"**
3. 查看嵌入的蓝色 iOS 原生视图

### 测试场景二（原生使用 Flutter）

1. 运行应用
2. 等待 3 秒出现 **"打开 Flutter 页面"** 按钮
3. 点击按钮打开 Canvas 页面
4. 这是在原生 iOS 中加载的 Flutter 页面

---

## 🔑 关键技术点

### FlutterEngineGroup 优势

| 特性 | 单个 Engine | EngineGroup | 节省 |
|-----|-----------|-------------|-----|
| 首个内存 | 60-80MB | 60-80MB | - |
| 后续内存 | 60-80MB | 10-20MB | **75%** |
| 首次启动 | 300ms | 300ms | - |
| 后续启动 | 300ms | 40ms | **87%** |

### Platform View 注意事项

✅ **推荐：**
- 适量使用原生组件
- 在 `layoutSubviews()` 中处理布局
- 保证 viewType 标识符一致

❌ **避免：**
- 同时使用大量 Platform View
- 频繁创建和销毁
- 深层嵌套

---

## 📊 目录结构对比

```
Flutter 使用原生          ←→          原生使用 Flutter
══════════════════                   ══════════════════

Flutter 端：                         iOS 端：
lib/module/usecase/pages/platform/                        ios/Runner/
  flutter_use_native/                  EmbedFlutterInNative/
    ├── IOSNativeComponentDemoPage.dart              └── FlutterWidgetVC.swift
    └── IOSNativeUIKitView.dart
                                     Flutter 端：
iOS 端：                              需要在 RouteConfig.dart
ios/Runner/                          中配置对应的路由
  EmbedNativeInFlutter/
    ├── IOSNativeView.swift
    └── IOSNativeViewFactory.swift

注册位置：                            使用位置：
AppDelegate.swift                    任何 iOS 原生代码
```

---

## 🛠 扩展指南

### 添加新的原生组件

1. 在 `lib/module/usecase/pages/platform/flutter_use_native/` 创建 Flutter 桥接
2. 在 `ios/Runner/EmbedNativeInFlutter/` 创建原生实现
3. 在 `AppDelegate.swift` 注册
4. 在 `RouteConfig.dart` 添加路由

### 添加新的 Flutter 页面供原生使用

1. 在 Flutter 中创建页面
2. 在 `RouteConfig.dart` 添加路由
3. 在 iOS 代码中使用：
   ```swift
   let vc = FlutterWidgetVC(route: "/your_route")
   present(vc, animated: true)
   ```

---

## 📝 代码规范

### 命名规范

- **Platform View ID：** 下划线命名 `native_test_view`
- **Swift 类名：** 大驼峰命名 `IOSNativeView`
- **Dart 文件名：** 大驼峰命名 `IOSNativeComponentDemoPage.dart`

### 日志规范

项目中使用 emoji 标记不同类型的日志：

- 🚀 创建/启动
- 📱 设备/平台相关
- 🔵 初始化
- ✅ 成功
- ❌ 错误
- 🗑️ 清理/销毁
- ⏱ 性能计时

---

## 📚 学习路径

### 初学者

1. 阅读 [完整指南](Flutter与iOS原生交互完整指南.md)
2. 运行并测试两个示例
3. 查看代码中的详细注释
4. 尝试修改参数观察效果

### 进阶开发者

1. 理解 FlutterEngineGroup 的内存共享机制
2. 学习 MethodChannel 双向通信
3. 实现自定义的 Platform View
4. 优化性能和内存占用

### 实战应用

1. 在现有项目中集成示例代码
2. 根据业务需求扩展功能
3. 处理复杂的通信场景
4. 优化混合导航体验

---

## 🐛 故障排查

### 常见问题

| 问题 | 可能原因 | 解决方案 |
|-----|---------|---------|
| 原生视图不显示 | viewType 不一致 | 检查 Flutter 和 iOS 端的标识符 |
| 白屏 | 路由未配置 | 在 RouteConfig.dart 添加路由 |
| 内存泄漏 | 强引用 VC | 使用局部变量或 weak 引用 |
| 启动慢 | 未使用 Group | 使用 FlutterEngineGroup |

### 调试技巧

```bash
# 查看 Flutter 日志
flutter logs

# 查看 iOS 日志（Xcode）
# Product → Scheme → Edit Scheme → Run → Arguments
# 添加环境变量：OS_ACTIVITY_MODE = disable

# 性能分析
flutter run --profile
```

---

## 🎓 相关资源

### 官方文档
- [Platform Views](https://docs.flutter.dev/platform-integration/platform-views)
- [Add Flutter to iOS](https://docs.flutter.dev/add-to-app/ios)
- [Platform Channels](https://docs.flutter.dev/platform-integration/platform-channels)

### 项目文档
- [完整指南](Flutter与iOS原生交互完整指南.md)
- [Flutter 使用原生](../flutter_use_native/README.md)
- [原生使用 Flutter](../../../../../../ios/Runner/EmbedFlutterInNative/README.md)

---

## 💡 最佳实践总结

### ✅ 推荐做法

1. **使用 FlutterEngineGroup** - 多次使用 Flutter 时必备
2. **详细的日志** - 方便调试和问题定位
3. **资源及时清理** - 在 deinit 中释放资源
4. **统一的命名规范** - 提高代码可维护性
5. **完善的注释** - 帮助团队理解代码

### ❌ 避免做法

1. **不要强引用 VC** - 会导致内存泄漏
2. **不要过度使用 Platform View** - 有性能开销
3. **不要忽略 viewType 一致性** - 会导致找不到视图
4. **不要在 init 中依赖 frame** - 尺寸可能是 0
5. **不要忘记注册** - Platform View 需要注册

---

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request！

在提交代码前请确保：
- 代码符合项目规范
- 添加了详细的注释
- 更新了相关文档
- 测试通过

---

## 📄 许可证

MIT License

---

## 📮 联系方式

如有问题，欢迎通过以下方式联系：
- 提交 GitHub Issue
- 发送邮件

---

**祝你学习愉快！🎉**

