import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// iOS 原生 UIKit 视图桥接组件
///
/// 💡 这个组件内部显示的是 iOS 端用 Swift/UIKit 实现的原生 UI
/// 通过 UiKitView 桥接技术将原生 UIView 嵌入到 Flutter 中
///
/// 核心步骤：
/// 1. 使用 UiKitView 来承载 iOS 原生 UIView
/// 2. 通过 viewType 指定原生视图的标识符
/// 3. 通过 creationParams 传递初始化参数给原生
/// 4. 在 iOS 端需要实现对应的 FlutterPlatformViewFactory
///
/// 对应的 iOS 原生实现文件：
/// - ios/Runner/test/platform-views/NativeTestView.swift
/// - ios/Runner/test/platform-views/NativeTestViewFactory.swift
///
/// 注意事项：
/// - viewType 必须与 iOS 端注册的标识符一致
/// - PlatformView 会有性能开销，因为需要额外的图层合成
/// - 在 iOS 上使用 UiKitView，在 Android 上使用 AndroidView
class IOSNativeUIKitView extends HookWidget {
  const IOSNativeUIKitView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 原生视图的唯一标识符，必须与 iOS 端注册时使用的标识符一致
    const String viewType = "native_test_view";

    // 传递给原生视图的初始化参数
    // 可以传递任何可序列化的数据（字符串、数字、Map、List 等）
    final Map<String, dynamic> creationParams = <String, dynamic>{
      // 示例：可以传递配置参数给原生端
      // "title": "Native View",
      // "backgroundColor": "#0000FF",
    };

    return UiKitView(
      // 原生视图类型标识符
      viewType: viewType,

      // 文本方向
      layoutDirection: TextDirection.ltr,

      // 创建参数
      creationParams: creationParams,

      // 参数编码器，用于序列化 creationParams
      creationParamsCodec: const StandardMessageCodec(),

      // 可选：视图创建完成的回调
      onPlatformViewCreated: (int id) {
        print("✅ iOS 原生 UIKit 视图已创建，ID: $id");
      },

      // 可选：手势识别器，用于处理手势冲突
      // gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{},
    );
  }
}
