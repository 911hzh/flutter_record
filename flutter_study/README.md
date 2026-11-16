# flutter_study

基于 Flutter Foundation Kit 模板组织的 Flutter 学习项目。启动进入学习示例首页。

## 运行

```bash
flutter pub get
flutter run
```

使用 Flutter 3.41.9。运行 `make gen-l10n` 生成国际化资源，运行 `make gen` 生成依赖注入和 Native Channel 代码。

## 原生验收

在专用 iOS 或 Android 模拟器上运行 Native Channel 消息往返测试：

```bash
flutter test -d <device-id> integration_test/module/usecase/pages/platform/native_channel/zh_native_channel_demo_page_test.dart
```

iOS 的 UIKit Platform View 和重叠手势页入口另有测试：

```bash
flutter test -d <ios-device-id> integration_test/module/usecase/pages/platform/flutter_use_native/ios_native_component_demo_page_test.dart
```

## 工程结构

- `lib/module/usecase/pages` 放按学习主题组织的页面。
- `lib/module/route` 和 `lib/module/getIt` 管理路由和依赖注入。
- `lib/base`、`lib/infra` 和 `lib/e_uikit` 放基础接口、具体实现和可复用 UI。

## 演示与教程

- [学习示例首页](lib/module/usecase/pages/home/README.md)
- [列表与布局](lib/module/usecase/pages/list/README.md)
- [Dart 实验](lib/module/usecase/pages/dart/README.md)
- [InheritedWidget](lib/module/usecase/pages/inherited_widget/README.md)
- [Provider](lib/module/usecase/pages/provider/README.md)
- [Navigator 2.0](lib/module/usecase/pages/navigation/README.md)
- [基础组件](lib/module/usecase/pages/components/README.md)
- [分隔线](lib/module/usecase/pages/separator/README.md)
- [Key 与 BLoC](lib/module/usecase/pages/widget_keys/README.md)
- [动画](lib/module/usecase/pages/animation/README.md)
- [Expanded 布局](lib/module/usecase/pages/layout/README.md)
- [Tab 页面](lib/module/usecase/pages/tabs/README.md)
- [转场与手势返回](lib/module/usecase/pages/transition/README.md)
- [Canvas 自定义绘制](lib/module/usecase/pages/canvas/README.md)
- [命中测试](lib/module/usecase/pages/hit_test/README.md)
- [国际化](lib/module/usecase/pages/localization/README.md)
- [平台互操作](lib/module/usecase/pages/platform/README.md)

## 专题文档

- [Flutter布局源码解析-从约束传递到组件定位](docs/Flutter布局源码解析-从约束传递到组件定位.md)
- [Flutter渲染机制深度解析](docs/Flutter渲染机制深度解析.md)
- [RenderBox源码解析-从抽象契约到RenderPadding实现](docs/RenderBox源码解析-从抽象契约到RenderPadding实现.md)
- [RenderObject更新时机说明](docs/RenderObject更新时机说明.md)
- [RepaintBoundary深度解析](docs/RepaintBoundary深度解析.md)
- [RepaintBoundary源码解析](docs/RepaintBoundary源码解析.md)
- [useEffect清理函数不执行的根本原因](docs/useEffect清理函数不执行的根本原因.md)
- [内存泄露和生命周期修复说明](docs/内存泄露和生命周期修复说明.md)
- [原项目说明](docs/原项目说明.md)
- [文件重命名为大驼峰说明](docs/文件重命名为大驼峰说明.md)
- [最终解决方案-测试说明](docs/最终解决方案-测试说明.md)
