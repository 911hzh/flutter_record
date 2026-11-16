import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/module/usecase/pages/transition/CustomBackGestureTransition/CustomBackGestureController.dart';
import 'package:flutter_study/module/usecase/pages/transition/CustomBackGestureTransition/CustomBackWrapperView.dart';
import 'package:flutter_study/module/usecase/pages/transition/custom/CustomAnimationPageRoute/CustomTransitionPageRoute.dart';

class CustomBackGesturePageRoute<T> extends CustomTransitionPageRoute<T> {
  CustomBackGesturePageRoute({
    required super.builder,
    this.title = "",
    this.delegatedTransitionBuilder,
    this.builderTransitionContent,
  });
  late final wrapperViewKey = GlobalKey(debugLabel: "${title}");
  final String title;
  DelegatedTransitionBuilder? delegatedTransitionBuilder;
  Function(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child)?
  builderTransitionContent;

  @override
  bool get opaque => true;
  @override
  Color? get barrierColor => Colors.transparent;

  @override
  Widget buildContent(BuildContext context) {
    return builder(context);
  }

  @override
  DelegatedTransitionBuilder? get delegatedTransition {
    Widget? delegatedTransition(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      bool allowSnapshotting,
      Widget? child,
    ) {
      if (delegatedTransitionBuilder != null) {
        final content = delegatedTransitionBuilder!(context, animation, secondaryAnimation, allowSnapshotting, child);

        return content;
      } else {
        return CupertinoPageTransition.delegatedTransition(
          context,
          animation,
          secondaryAnimation,
          allowSnapshotting,
          child,
        );
      }
    }

    return delegatedTransition;
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (builderTransitionContent != null) {
      final builderContent = this.builderTransitionContent!(context, animation, secondaryAnimation, child);
      return BackGestureWrapperView<T>(
        key: wrapperViewKey,
        enabledCallback: () => _isPopGestureEnabled<T>(this),
        onStartPopGesture: () => _startPopGesture<T>(this),
        child: builderContent,
      );
    }
    return super.buildTransitions(
      context,
      animation,
      secondaryAnimation,
      BackGestureWrapperView<T>(
        key: wrapperViewKey,
        enabledCallback: () => _isPopGestureEnabled<T>(this),
        onStartPopGesture: () => _startPopGesture<T>(this),
        child: child,
      ),
    );
  }

  bool _isPopGestureEnabled<T>(PageRoute<T> route) {
    // If there's nothing to go back to, then obviously we don't support
    // the back gesture.
    if (route.isFirst) {
      return false;
    }
    // If the route wouldn't actually pop if we popped it, then the gesture
    // would be really confusing (or would skip internal routes), so disallow it.
    if (route.willHandlePopInternally) {
      return false;
    }
    // If attempts to dismiss this route might be vetoed such as in a page
    // with forms, then do not allow the user to dismiss the route with a swipe.
    if (route.hasScopedWillPopCallback) {
      return false;
    }
    // Fullscreen dialogs aren't dismissible by back swipe.
    if (route.fullscreenDialog) {
      return false;
    }
    // If we're in an animation already, we cannot be manually swiped.
    if (route.animation!.status != AnimationStatus.completed) {
      return false;
    }
    // If we're being popped into, we also cannot be swiped until the pop above
    // it completes. This translates to our secondary animation being
    // dismissed.
    if (route.secondaryAnimation!.status != AnimationStatus.dismissed) {
      return false;
    }
    // If we're in a gesture already, we cannot start another.
    if (isPopGestureInProgress(route)) {
      return false;
    }

    // Looks like a back gesture would be welcome!
    return true;
  }

  bool isPopGestureInProgress(PageRoute<dynamic> route) {
    return route.navigator!.userGestureInProgress;
  }

  BackGestureController<T> _startPopGesture<T>(PageRoute<T> route) {
    assert(_isPopGestureEnabled(route));

    return BackGestureController<T>(
      navigator: route.navigator!,
      controller: route.controller!, // protected access
    );
  }
}
