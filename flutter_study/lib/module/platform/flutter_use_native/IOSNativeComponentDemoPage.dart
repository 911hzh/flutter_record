import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_study/module/platform/flutter_use_native/IOSNativeGestureOverlapTestPage.dart';
import 'package:flutter_study/module/platform/flutter_use_native/IOSNativeUIKitView.dart';

/// Flutter 使用 iOS 原生组件的演示页面
///
/// 📱 这个页面展示了如何在 Flutter 中嵌入 iOS 原生 UIView 组件
/// 
/// 使用场景：
/// - 当 Flutter 无法满足某些原生能力时（如相机、地图等）
/// - 需要复用已有的原生 UI 组件库
/// - 需要使用原生的硬件加速能力
/// - 集成第三方 iOS SDK 的原生 UI
///
/// 实现原理：
/// 1. Flutter 通过 PlatformView 机制桥接原生视图
/// 2. iOS 使用 UiKitView 来承载原生的 UIView
/// 3. Flutter 引擎会为每个 PlatformView 创建一个单独的 UIView 层级
/// 
/// 💡 页面中蓝色区域就是通过 Swift/UIKit 实现的 iOS 原生组件
/// 🔴 红色边框是 Flutter 的 Container，用于对比展示
class IOSNativeComponentDemoPage extends HookWidget {
  const IOSNativeComponentDemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("iOS 原生组件演示"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // 说明区域
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "📱 Platform View 示例",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "下方蓝色区域是 iOS 原生 UIView\n"
                  "通过 Swift/UIKit 实现，用 UiKitView 嵌入到 Flutter",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // 原生视图容器
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                // 🎯 这里就是 iOS 原生 UIKit 组件！
                // 内部是用 Swift 编写的 UIView
                child: const IOSNativeUIKitView(),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const IOSNativeGestureOverlapTestPage(),
                    ),
                  );
                },
                child: const Text("打开重叠手势验证页"),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // 提示信息
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              color: Colors.amber.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "🔴 红色边框 = Flutter Container\n"
                        "🔵 蓝色区域 = iOS 原生 UIView (Swift/UIKit)",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.orange.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

