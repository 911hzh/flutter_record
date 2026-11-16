// import 'package:flutter_study/CustomPageRoute/BackGestureWidget.dart';
import 'package:flutter_study/module/usecase/pages/transition/custom/CustomPageRoute/CustomFadeRouteWithGesture.dart';
import 'package:flutter_study/module/usecase/pages/transition/custom/HTPageJump/PageC.dart';
import 'package:flutter_study/module/usecase/pages/transition/custom/HTPageJump/PageD.dart';
import 'package:flutter_study/module/usecase/pages/transition/custom/HTPageJump/RightEdgeAreaWidget.dart';
import 'package:flutter/material.dart';
import 'PageA.dart';

class TransitionHomePage extends StatefulWidget {
  static PageRoute? lastPage;
  static GlobalKey globalKey = GlobalKey();
  const TransitionHomePage({Key? key}) : super(key: key);

  @override
  State<TransitionHomePage> createState() => _TransitionHomePageState();
}

class _TransitionHomePageState extends State<TransitionHomePage> with SingleTickerProviderStateMixin {
  final progressNotifier = ValueNotifier(0.0);
  final dragNotifier = ValueNotifier(0.0);
  final transactionAnimation = ValueNotifier<TransactionAnimation?>(null);
  bool isDragging = false;
  late AnimationController _animationController;
  AnimationController? homePagePushAnimationController;
  double _startDragX = 0.0;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  CustomPushPage? pushPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('首页')),
      body: Stack(
        children: [
          Column(
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final transactionAnimation = ValueNotifier<TransactionAnimation?>(null);
                    Navigator.of(context).push(
                      CustomFadeRouteWithGesture(
                        builder: (context) {
                          return PageA(progressNotifier: progressNotifier, transactionAnimation: transactionAnimation);
                        },
                        title: "PageA",
                        transactionAnimation: transactionAnimation,
                      ),
                    );
                  },
                  child: const Text('跳转到PageA'),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final a = MaterialPageRoute(builder: (context) => PageD());
                    Navigator.of(context).push(a);
                  },
                  child: const Text('跳转到PageD'),
                ),
              ),
            ],
          ),

          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: RightEdgeAreaWidget(
              createPage: (context) {
                final page = CustomFadeRouteWithGesture(
                  builder: (context) {
                    return PageA(progressNotifier: progressNotifier, transactionAnimation: transactionAnimation);
                  },
                  title: "PageA1",
                  transactionAnimation: transactionAnimation,
                  delegatedTransitionBuilder: (context, animation, secondaryAnimation, allowSnapshotting, child) {
                    final Animatable<Offset> _kMiddleLeftTween = Tween<Offset>(
                      begin: Offset.zero,
                      end: const Offset(-1, 0.0),
                    );
                    final CurvedAnimation animation = CurvedAnimation(
                      parent: secondaryAnimation,
                      curve: Curves.easeOut,
                      reverseCurve: Curves.easeIn,
                    );
                    final Animation<Offset> delegatedPositionAnimation = animation.drive(_kMiddleLeftTween);
                    animation.dispose();

                    assert(debugCheckHasDirectionality(context));
                    final TextDirection textDirection = Directionality.of(context);
                    return SlideTransition(
                      position: delegatedPositionAnimation,
                      textDirection: textDirection,
                      transformHitTests: false,
                      child: child,
                    );
                  },
                  customTransitionBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                    isPop,
                    isPush,
                    linearTransition,
                  ) {
                    Animation<Offset> positionAnimation = Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: const Offset(0, 0.0),
                    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut, reverseCurve: Curves.easeIn));
                    // print("progress: $progress, position: ${positionAnimation.value}");
                    if (animation.value == 0) {
                      return child;
                    }
                    return SlideTransition(position: positionAnimation, transformHitTests: false, child: child);
                  },
                );
                return page;
              },
            ),
          ),
        ],
      ),
    );
  }
}
