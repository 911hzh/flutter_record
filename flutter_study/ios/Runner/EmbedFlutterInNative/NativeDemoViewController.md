# 原生ViewController

在 iOS 的 Flutter 首页点第一项「原生ViewController」。首页通过 `FlutterNativeBridge` 调用 `openNativeViewController`，由 `AppDelegate` 弹出 UIKit 页面。点右上角关闭按钮返回首页。

## 页面按钮

- **打开 Flutter 页面**：通过 `FlutterWidgetVC` 弹出路由为 `/native_use_flutter_page` 的 Flutter 页面，演示在 iOS 原生界面中嵌入 Flutter。
- **向 Flutter 获取数据**：通过 MethodChannel 向首页所在的 Flutter 引擎发送 `GETFlutterDataMsg`。示例处理器返回 `data`，原生页会用「Flutter 响应」弹窗显示结果。

## 代码入口

- [NativeDemoViewController.swift](NativeDemoViewController.swift)
- [AppDelegate.swift](../AppDelegate.swift)
- [HomePage.dart](../../../lib/module/usecase/pages/home/HomePage.dart)
