# 原生宿主中的 Flutter 页面

入口为 `/native_use_flutter_page`，由 iOS 的 `FlutterWidgetVC` 传入。页面监听 `FlutterNativeEventChannelBridge`，并演示通过 `FlutterNativeBridge` 调用宿主。在 iOS 的 Flutter 首页点击「原生ViewController」打开原生页面，再点击「打开 Flutter 页面」进入此页。原生页面上的「向 Flutter 获取数据」按钮通过 MethodChannel 向首页所在的 Flutter 引擎请求数据，并弹窗显示结果。

## 代码

- [NativeUseFlutterPage.dart](NativeUseFlutterPage.dart)
