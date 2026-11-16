import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_study/module/usecase/pages/transition/CustomBackGestureTransition/CustomBackGesturePageRoute.dart';
import 'package:flutter_study/module/usecase/pages/transition/page/MindSpaceHomePage.dart';

class MindSpaceHomePagetest extends HookWidget {
  const MindSpaceHomePagetest({super.key});

  @override
  Widget build(BuildContext context) {
    // 创建一个静态的 GlobalKey 用于 MindSpaceHomePage
    // 注意：这里使用 useMemoized 确保 key 在整个生命周期中保持不变

    return Scaffold(
      appBar: AppBar(title: Text("测试入口 - 点击跳转到主页")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // 🎬 动画职责分离示例
                final route = CustomBackGesturePageRoute(
                  title: "MindSpaceHomePage",
                  builder: (context) {
                    return MindSpaceHomePage();
                  },
                  // 📌 delegatedTransitionBuilder:
                  // 作用：让系统知道 HomePage 支持 delegated transition
                  // 当 HomePage 被其他页面覆盖时，这里会被调用
                  // 但实际动画由 HomePage 内部的 secondaryAnimation 控制
                  delegatedTransitionBuilder: (context, animation, secondaryAnimation, allowSnapshotting, child) {
                    print("delegatedTransitionBuilder: ${secondaryAnimation.value}");
                    return ScaleTransition(
                      scale: Tween<double>(begin: 1.0, end: 0.2).animate(secondaryAnimation),
                      child: child,
                    );
                  },
                  // 📌 builderTransitionContent:
                  // 作用：控制 HomePage 的进入/退出动画（使用 animation）
                  // - 进入时：animation 0 → 1，HomePage 从 0 缩放到 1
                  // - 退出时：animation 1 → 0，HomePage 从 1 缩放到 0
                  builderTransitionContent: (context, animation, secondaryAnimation, child) {
                    return ScaleTransition(
                      scale: animation, // 🎯 使用 animation 控制进入/退出
                      child: MindSpaceHomePage(),
                    );
                  },
                );
                Navigator.of(context).push(route);
              },
              child: Text("跳转到 MindSpaceHomePage (完整示例)", style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 方案2：如果 TestPage 需要透明，让 HomePage 显示在上面
                final route = CustomBackGesturePageRoute(
                  builder: (context) {
                    return MindSpaceHomePage();
                  },
                  builderTransitionContent: (context, animation, secondaryAnimation, child) {
                    return ScaleTransition(scale: animation, child: MindSpaceHomePage());
                  },
                );
                // 让 HomePage 的路由不透明，这样 TestPage 不会被看到
                Navigator.of(context).push(route);
              },
              child: Text("跳转到 MindSpaceHomePage (无透明背景)", style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 20),
            Text(
              "使用 GlobalKey 方案的原理：\n"
              "1. builder 和 builderTransitionContent 使用相同的 key\n"
              "2. Flutter 认为它们是同一个 Widget\n"
              "3. 保持状态和手势识别器的连续性\n"
              "4. 从 HomePage 可以正常返回到 TestPage",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
