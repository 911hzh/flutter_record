import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_study/base/channel/EventMessageChannelManager.dart';
import 'package:flutter_study/base/channel/MethodChannelManager.dart';

class NativeUseFlutterPage extends HookWidget {
  const NativeUseFlutterPage({super.key});

  @override
  Widget build(BuildContext context) {
    print("🏗️ NativeUseFlutterPage build 执行");

    // ✅ 修复：正确管理 EventChannel 订阅
    useEffect(() {
      print("🎯 NativeUseFlutterPage useEffect 开始执行");

      // 创建 EventChannel 并监听
      final eventMessageChannel = EventChannel("FlutterNativeEventChannelBridge");
      final subscription = eventMessageChannel.receiveBroadcastStream().listen(
        (event) {
          print("📥 EventChannel 收到事件: $event");
        },
        onError: (error) {
          print("❌ EventChannel 错误: $error");
        },
        onDone: () {
          print("✅ EventChannel 流结束");
        },
        cancelOnError: false,
      );

      print("✅ useEffect 初始化完成，已订阅 EventChannel");

      // ✅ 清理函数：在组件销毁时执行
      return () {
        print("🧹🧹🧹 NativeUseFlutterPage 清理函数执行 - 取消事件监听 🧹🧹🧹");
        subscription.cancel();
        print("✅ EventChannel 订阅已取消");
      };
    }, []);
    // return Scaffold(body: Text("Native Use Flutter"));

    return Scaffold(
      appBar: AppBar(title: const Text("Native Use Flutter")),
      body: Column(
        children: [
          const Text("Native Use Flutter"),
          TextButton(
            onPressed: () async {
              print("📤 NativeUseFlutterPage 发送数据到原生");
              final result = await MethodChannelManager.shared.invokeMethod("getLocationInfomation", {
                "beijing": "32,33",
              });
              print("📥 NativeUseFlutterPage 收到原生返回: $result");
            },
            child: const Text("Get Data"),
          ),
        ],
      ),
    );
  }
}
