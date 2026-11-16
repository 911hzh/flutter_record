import 'package:flutter/material.dart';

class SharedCountInheritedWidget extends InheritedWidget {
  final int count;
  const SharedCountInheritedWidget({super.key, required this.count, required super.child});
  @override
  bool updateShouldNotify(SharedCountInheritedWidget oldWidget) {
    return oldWidget.count != count;
  }

  static SharedCountInheritedWidget? of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<SharedCountInheritedWidget>();
    return widget;
  }

  static SharedCountInheritedWidget? ofWithoutDependency(BuildContext context) {
    final element = context.getElementForInheritedWidgetOfExactType<SharedCountInheritedWidget>();
    return element?.widget as SharedCountInheritedWidget?;
  }
}
