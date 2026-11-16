import 'package:flutter/material.dart';

class MyProvider<T extends ChangeNotifier> extends StatefulWidget {
  final T value;
  final Widget Function() builder;

  MyProvider({super.key, required this.value, required this.builder});

  @override
  State<MyProvider<T>> createState() => _MyProviderState<T>();
}

class _MyProviderState<T extends ChangeNotifier> extends State<MyProvider<T>> {
  var count = 0;
  @override
  void didUpdateWidget(covariant MyProvider<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.value.removeListener(_onChanged);
    if (oldWidget.value != widget.value) {
      widget.value.addListener(_onChanged);
    }
  }

  void _onChanged() {
    setState(() {
      count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyProviderWidget(value: widget.value, count: count, child: widget.builder());
  }

  @override
  dispose() {
    widget.value.removeListener(_onChanged);
    super.dispose();
  }

  static MyProviderWidget<T>? of<T extends ChangeNotifier>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyProviderWidget<T>>();
  }

  static MyProviderWidget<T>? ofWithoutDependency<T extends ChangeNotifier>(BuildContext context) {
    return context.getElementForInheritedWidgetOfExactType<MyProviderWidget<T>>()?.widget as MyProviderWidget<T>?;
  }
}

class MyProviderWidget<T extends ChangeNotifier> extends InheritedWidget {
  final T value;
  final int count;
  MyProviderWidget({super.key, required this.value, required this.count, required super.child});

  @override
  bool updateShouldNotify(covariant MyProviderWidget<T> oldWidget) {
    // 如果是被监听的对象都变了，那么肯定就需要触发重建了
    if (oldWidget.value != value) {
      return true;
    }
    // 这里知道是通过setState来触发重建的，所以需要比较count
    return oldWidget.count != count;
  }
}
