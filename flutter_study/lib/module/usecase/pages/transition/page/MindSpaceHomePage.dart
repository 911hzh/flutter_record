import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_study/module/usecase/pages/transition/CustomBackGestureTransition/CustomBackGesturePageRoute.dart';
import 'package:flutter_study/module/usecase/pages/transition/page/FocusItemView.dart';
import 'package:flutter_study/module/usecase/pages/transition/page/MindSpaceFocusDetailPage.dart';

class MindSpaceHomePage extends HookWidget {
  MindSpaceHomePage({super.key});

  void gotoDetail(GlobalKey key, BuildContext context) {
    final route = CustomBackGesturePageRoute(
      title: "MindSpaceFocusDetailPage",
      builder: (context) =>
          MindSpaceFocusDetailPage(fromGlobalKey: key, animation: null),
      // 📌 delegatedTransitionBuilder:
      // 返回 child，让 HomePage 通过自己内部的 secondaryAnimation 处理被覆盖动画
      // 不要创建新实例，否则会破坏 Widget 树导致手势返回失效
      delegatedTransitionBuilder:
          (context, animation, secondaryAnimation, allowSnapshotting, child) {
            return child; // ✅ 保持 Widget 树稳定，手势返回有效
          },
      // 📌 builderTransitionContent:
      // 使用 animation 控制 DetailPage 的进入/退出动画
      builderTransitionContent:
          (context, animation, secondaryAnimation, child) {
            return MindSpaceFocusDetailPage(
              fromGlobalKey: key,
              animation: animation, // 🎯 传递 animation 给 DetailPage 做自定义动画
            );
          },
    );
    final route1 = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return MindSpaceFocusDetailPage(
          fromGlobalKey: key,
          animation: animation, // 🎯 传递 animation 给 DetailPage 做自定义动画
        );
      },
    );
    Navigator.of(context).push(route);
  }

  @override
  Widget build(BuildContext context) {
    // 🎬 动画职责说明：
    // 1. animation（进入/退出动画）：由外部 builderTransitionContent 控制
    // 2. secondaryAnimation（被覆盖动画）：由这里监听并控制
    // ✅ 从路由中获取 secondaryAnimation，当被其他页面覆盖时会触发动画
    final modalRoute = ModalRoute.of(context);
    final secondaryAnimation = modalRoute?.secondaryAnimation;

    final widgetList = ["1", "2"];
    final itemKeyList = useRef<List<(GlobalKey, GlobalKey)>>([]);

    useEffect(() {
      for (var i = 0; i < widgetList.length; i++) {
        itemKeyList.value.add((GlobalKey(), GlobalKey()));
      }
      return null;
    }, []);
    final itemlist = widgetList
        .asMap()
        .map((key, value) {
          final widget = LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - 24) / 2;
              final itemHeight = itemWidth;
              final globalKey = itemKeyList.value[key].$1;
              final globalKey2 = itemKeyList.value[key].$2;
              return Column(
                children: [
                  Row(
                    spacing: 0,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        key: globalKey,
                        onTap: () {
                          gotoDetail(globalKey, context);
                        },
                        child: Container(
                          width: itemWidth,
                          height: itemHeight,
                          child: FocusItemView(),
                        ),
                      ),
                      GestureDetector(
                        key: globalKey2,
                        onTap: () {
                          gotoDetail(globalKey2, context);
                        },
                        child: Container(
                          width: itemWidth,
                          height: itemHeight,
                          child: FocusItemView(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                ],
              );
            },
          );
          return MapEntry(key, widget);
        })
        .values
        .toList();

    // 将 itemlist 包装为一个独立的 Widget，便于复用
    final itemContent = Column(children: itemlist);
    final container = Visibility(
      visible: false,
      maintainState: true,
      child: Opacity(
        opacity: 0.5,
        child: Container(color: Colors.red, width: 100, height: 100),
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Container(color: Colors.white)),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: secondaryAnimation != null
                ? AnimatedBuilder(
                    animation: secondaryAnimation,
                    builder: (context, child) {
                      // 🎯 secondaryAnimation 动画说明：
                      // - 当 DetailPage push 上来时：0 → 1（缩小到 0.2，淡出到 0）
                      // - 当 DetailPage pop 下去时：1 → 0（放大回 1，淡入回 1）
                      return ScaleTransition(
                        scale: Tween<double>(
                          begin: 1,
                          end: 0.2,
                        ).animate(secondaryAnimation),
                        child: FadeTransition(
                          opacity: Tween<double>(
                            begin: 1,
                            end: 0,
                          ).animate(secondaryAnimation),
                          child: child,
                        ),
                      );
                    },
                    child: itemContent,
                  )
                : itemContent,
          ),
          // Container(color: Colors.red, width: 100, height: 100),
        ],
      ),
    );
  }
}
