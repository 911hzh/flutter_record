import 'package:flutter_study/module/usecase/pages/transition/custom/CustomPageRoute/CustomFadeRouteWithGesture.dart';
import 'package:flutter_study/module/usecase/pages/transition/custom/HTPageJump/TransitionHomePage.dart';
import 'package:flutter_study/module/usecase/pages/transition/custom/HTPageJump/PageB.dart';
import 'package:flutter/material.dart';

class PageA extends StatefulWidget {
  final ValueNotifier<double> progressNotifier;
  final ValueNotifier<TransactionAnimation?> transactionAnimation;
  const PageA({Key? key, required this.progressNotifier, required this.transactionAnimation}) : super(key: key);

  @override
  State<PageA> createState() => _PageAState();
}

class _PageAState extends State<PageA> {
  @override
  void initState() {
    super.initState();
    widget.progressNotifier.addListener(_onProgressChanged);
    widget.transactionAnimation.addListener(_onTransactionAnimationChanged);
  }

  var count = 0;

  @override
  void dispose() {
    widget.progressNotifier.removeListener(_onProgressChanged);
    widget.transactionAnimation.removeListener(_onTransactionAnimationChanged);
    super.dispose();
  }

  void _onProgressChanged() {
    setState(() {});
  }

  void _onTransactionAnimationChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final transactionAnimation = widget.transactionAnimation.value;
    if (transactionAnimation == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('PageA')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20)),
                child: Center(child: Text('静止状态', style: const TextStyle(fontSize: 20, color: Colors.white))),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // 获取当前路由
                  final currentRoute = ModalRoute.of(context);
                  if (currentRoute != null) {
                    Navigator.of(context).removeRoute(currentRoute);
                  }
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('返回首页'),
              ),
              ElevatedButton(
                onPressed: () {
                  final progressNotifier = ValueNotifier(0.0);
                  final transactionAnimation = ValueNotifier<TransactionAnimation?>(null);
                  Navigator.of(context).push(
                    CustomFadeRouteWithGesture(
                      builder: (context) {
                        return PageB(progressNotifier: progressNotifier, transactionAnimation: transactionAnimation);
                      },
                      title: "PageB",
                      transactionAnimation: transactionAnimation,
                    ),
                  );
                },
                child: const Text('to PageB'),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: const Text('PageA')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: transactionAnimation.isPush ? 200 + (100) * transactionAnimation.animation.value : 300,
                height: 200,
                decoration: BoxDecoration(
                  color: transactionAnimation.isGesturePop ? Colors.red : Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    '当前进度: ${transactionAnimation.isPush ? 'push' : 'pop'} isGesturePop: ${transactionAnimation.isGesturePop} ${(transactionAnimation.animation.value * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // 获取当前路由
                  final currentRoute = ModalRoute.of(context);
                  if (currentRoute != null && currentRoute is PageRoute) {
                    TransitionHomePage.lastPage = currentRoute;
                    // Navigator.of(context).removeRoute(currentRoute);
                  }
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('返回首页'),
              ),
              ElevatedButton(
                onPressed: () {
                  final progressNotifier = ValueNotifier(0.0);
                  final transactionAnimation = ValueNotifier<TransactionAnimation?>(null);
                  Navigator.of(context).push(
                    CustomFadeRouteWithGesture(
                      builder: (context) {
                        return PageB(progressNotifier: progressNotifier, transactionAnimation: transactionAnimation);
                      },
                      title: "PageB",
                      transactionAnimation: transactionAnimation,
                    ),
                  );
                },
                child: const Text('to PageB'),
              ),
              ElevatedButton(
                onPressed: () {
                  final progressNotifier = ValueNotifier(0.0);
                  final transactionAnimation = ValueNotifier<TransactionAnimation?>(null);
                  Navigator.of(context).push(
                    CustomFadeRouteWithGesture(
                      builder: (context) {
                        return PageB(progressNotifier: progressNotifier, transactionAnimation: transactionAnimation);
                      },
                      title: "PageB",
                      transactionAnimation: transactionAnimation,
                      delegatedTransitionBuilder: (context, animation, secondaryAnimation, allowSnapshotting, child) {
                        return child;
                      },
                      customTransitionBuilder: (context, animation, secondaryAnimation, child, pop, push, gesturePop) {
                        // return AnimatedBuilder(
                        //   animation: animation,
                        //   builder: (context, child) {
                        //     return FadeTransition(
                        //       opacity: animation,
                        //       child: ,
                        //     );
                        //   },
                        //   child: child,
                        // );
                        return FadeTransition(
                          opacity: gesturePop ? animation.drive(Tween<double>(begin: 1, end: 1)) : animation,
                          child: SlideTransition(
                            position:
                                gesturePop
                                    ? animation.drive(
                                      Tween<Offset>(begin: const Offset(1, 0.0), end: const Offset(0, 0.0)),
                                    )
                                    : animation.drive(
                                      Tween<Offset>(begin: const Offset(0, 0.0), end: const Offset(0, 0.0)),
                                    ),
                            child: child,
                          ),
                        );
                      },
                    ),
                  );
                },
                child: const Text('to PageB'),
              ),
            ],
          ),
        ),
      );
    }
  }
}
