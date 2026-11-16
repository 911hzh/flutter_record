# 原生宿主中的 Flutter 页面

入口为 `/native_use_flutter_page`，由 iOS 的 `FlutterWidgetVC` 传入。页面监听 `FlutterNativeEventChannelBridge`，并演示通过 `FlutterNativeBridge` 调用宿主。在当前 iOS 启动代码中，浮动按钮调用消息通道，打开此页面的方法另行定义。

## 代码

- [NativeUseFlutterPage.dart](NativeUseFlutterPage.dart)
