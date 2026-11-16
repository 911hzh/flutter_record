import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageC extends StatelessWidget {
  const PageC({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class CustomPushPage extends CupertinoPageRoute {
  double progress;
  bool isPushed = false;

  CustomPushPage({
    required WidgetBuilder builder,
    required this.progress,
  }) : super(builder: builder);

  void setProgress(double progress) {
    this.progress = progress;
    this.controller?.value = progress;
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    Animation<Offset> positionAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: const Offset(0, 0.0),
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    ));
    print("progress: $progress, position: ${positionAnimation.value}");
    if (progress == 0) {
      return child;
    }
    return SlideTransition(
      position: positionAnimation,
      transformHitTests: false,
      child: Opacity(
        opacity: 1,
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      ),
    );
  }
}
