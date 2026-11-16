import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_study/module/transition/CustomBackGestureTransition/CustomBackGesturePageRoute.dart';
import 'package:flutter_study/module/transition/page/MindSpaceHomePage.dart';

class MindSpaceFocusDetailPage extends HookWidget {
  final GlobalKey fromGlobalKey;
  final Animation<double>? animation;

  MindSpaceFocusDetailPage({required this.fromGlobalKey, required this.animation});

  (Offset, Size) getPosition() {
    // 通过 GlobalKey 获取组件的 RenderBox
    final renderBox = fromGlobalKey.currentContext?.findRenderObject() as RenderBox?;

    // 获取组件的大小
    final size = renderBox?.size;

    // 获取组件的全局位置
    final position = renderBox?.localToGlobal(Offset.zero);
    return (position!, size!);
  }

  @override
  Widget build(BuildContext context) {
    // 监听 secondaryAnimation：当 DetailPage 被其他页面覆盖时（如点击 tap 跳转到新 HomePage）
    final modalRoute = ModalRoute.of(context);
    final secondaryAnimation = modalRoute?.secondaryAnimation;
    final animation = modalRoute?.animation;
    print("secondaryAnimation: ${secondaryAnimation?.isAnimating}, animation: ${animation?.isAnimating}");

    final positionAndSize = useMemoized(() {
      return getPosition();
    }, []);
    final screenSize = useMemoized(() {
      return MediaQuery.of(context).size;
    });
    // animation：用于 DetailPage 的进入/退出动画
    final controller =
        animation ?? AnimationController(duration: Duration(milliseconds: 300), vsync: useSingleTickerProvider());
    final iconAnimation = useAnimation<double>(
      Tween<double>(
        begin: 1,
        end: 0,
      ).animate(CurvedAnimation(parent: controller, curve: Interval(0.0, 0.8, curve: Curves.easeOut))),
    );
    final textAnimation = useAnimation<Offset>(
      Tween<Offset>(
        begin: Offset(16, 16),
        end: Offset(40, 70),
      ).animate(CurvedAnimation(parent: controller, curve: Interval(0.0, 0.8, curve: Curves.easeOut))),
    );
    final containerAnimationPosition = useAnimation<Offset>(
      Tween<Offset>(
        begin: positionAndSize.$1,
        end: Offset(8, 80),
      ).animate(CurvedAnimation(parent: controller, curve: Interval(0.0, 0.8, curve: Curves.easeOut))),
    );
    final containerAnimationSize = useAnimation<Size>(
      Tween<Size>(
        begin: positionAndSize.$2,
        end: Size(screenSize.width - 16, screenSize.height - 16 - 120),
      ).animate(CurvedAnimation(parent: controller, curve: Interval(0.0, 0.8, curve: Curves.easeOut))),
    );
    // 添加背景色动画，从完全透明渐变到半透明
    final backgroundAnimation = useAnimation<double>(
      Tween<double>(
        begin: 0, // 完全透明
        end: 1, // 半透明（原始值）
      ).animate(CurvedAnimation(parent: controller, curve: Interval(0.4, 1.0, curve: Curves.easeInOut))),
    );

    final buttonOpacityAnimation = useAnimation<double>(
      Tween<double>(
        begin: 0,
        end: 1,
      ).animate(CurvedAnimation(parent: controller, curve: Interval(0.0, 0.8, curve: Curves.easeOut))),
    );
    final defaultIcon = Image.asset("lib/assets/focusItem_defaultIcon.png");

    final bodyContent = Container(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.blue, width: 1),
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: backgroundAnimation,
                  child: Image.asset("lib/assets/mindspace_bg.png", fit: BoxFit.cover),
                ),
              ),
              Positioned(
                top: containerAnimationPosition.dy,
                left: containerAnimationPosition.dx,
                width: containerAnimationSize.width,
                height: containerAnimationSize.height,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0x4DFFFFFF),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0x26FFFFFF), width: 1),
                        boxShadow: [const BoxShadow(offset: Offset(0, 8), blurRadius: 24, color: Color(0x0D000000))],
                      ),
                      child: Stack(
                        children: [
                          // 左上角标题
                          Positioned(
                            left: textAnimation.dx,
                            top: textAnimation.dy,
                            right: 60,
                            child: Text(
                              "test 111 who are you ",
                              style: TextStyle(color: Colors.black),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // 右上角图标
                          Positioned(
                            right: 13,
                            top: 11,
                            child: Opacity(
                              opacity: iconAnimation,
                              child: Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: const Color(0x0D12192B),
                                  borderRadius: BorderRadius.circular(17),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 25,
                                  height: 25,
                                  child: defaultIcon,
                                ), //SingleImageElementViewV2(imageUrl: focus.icon, width: 25, height: 25, borderRadius: 12.5),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 7,
                            right: 7,
                            bottom: -13,
                            child: Container(
                              height: 26,
                              decoration: ShapeDecoration(
                                color: const Color(0xFFD9D9D9),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 200,
                left: 0,
                right: 0,
                child: AnimatedBuilder(
                  animation: animation!,
                  builder: (context, child) {
                    return Opacity(opacity: buttonOpacityAnimation, child: child!);
                  },
                  child: GestureDetector(
                    onTap: () {
                      final route = CustomBackGesturePageRoute(
                        title: "MindSpaceHomePage",
                        builder: (context) => MindSpaceHomePage(),
                        delegatedTransitionBuilder: (context, animation, secondaryAnimation, allowSnapshotting, child) {
                          final route = ModalRoute.of(context);
                          print("route delegatedTransitionBuilder: ${route.toString()}");
                          return ScaleTransition(
                            scale: Tween<double>(begin: 1.0, end: 0.9).animate(secondaryAnimation),
                            child: child,
                          );
                        },
                        builderTransitionContent: (context, animation, secondaryAnimation, child) {
                          final route = ModalRoute.of(context);
                          print("route builderTransitionContent: ${route.toString()}");
                          return ScaleTransition(scale: animation, child: MindSpaceHomePage());
                        },
                      );
                      Navigator.of(context).push(route);
                    },
                    child: Text("tap"),
                  ),
                ),
              ),
              Positioned(
                top: 300,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    final route = CustomBackGesturePageRoute(
                      title: "MindSpaceHomePage",
                      builder: (context) => MindSpaceHomePage(),
                    );
                    Navigator.of(context).push(route);
                  },
                  child: Text("defaultAnimation"),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body:
          secondaryAnimation != null
              ? AnimatedBuilder(
                animation: secondaryAnimation,
                builder: (context, child) {
                  // 当被其他页面覆盖时（如跳转到新 HomePage），执行淡出动画
                  return FadeTransition(
                    opacity: Tween<double>(begin: 1, end: 0).animate(secondaryAnimation),
                    child: child,
                  );
                },
                child: bodyContent,
              )
              : bodyContent,
    );
  }
}
