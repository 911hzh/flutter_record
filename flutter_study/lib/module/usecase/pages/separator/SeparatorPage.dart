import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import "package:flutter_hooks/flutter_hooks.dart";

class SeparatorPage extends HookWidget {
  SeparatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    var count = useState(1);
    var maxHeight = useState(300.0);
    List<Widget> child1 = useMemoized(() {
      List<Widget> list = [];
      for (var i = 0; i < count.value; i++) {
        list.add(Text("d${i}"));
      }
      return list;
    }, [count.value]);

    useEffect(() {
      var timer;
      timer = Timer.periodic(Duration(milliseconds: 3000), (timer) {
        if (count.value > 20) {
          timer.cancel();
          return;
        }
        count.value += 1;
      });
      // Future.delayed(Duration(milliseconds: 3000), () {
      //   if (count.value >= 20) {
      //     return;
      //   }
      //   count.value += 1;
      // });
      return () {
        timer?.cancel();
        print("dispose");
      };
    }, []);
    final pageList = [
      // ListView.builder(
      //     itemCount: 5,
      //     shrinkWrap: true,
      //     itemBuilder: (context, index) {
      //       var a = "aaa" * index;
      //       return Text("${a}");
      //     }),
      UnconstrainedBox(
          alignment: Alignment.topLeft,
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minWidth: 300, maxWidth: 300, minHeight: 30),
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.green),
              child: SizeChangedLayoutNotifierNew(
                  child: Column(
                children: child1,
                mainAxisSize: MainAxisSize.min,
              )),
            ),
          )),
      SizedBox(
        width: 10,
        height: 5,
      ),
      ConstrainedBox(
        constraints: BoxConstraints(minWidth: 300, minHeight: 20),
        child: DecoratedBox(
          decoration: BoxDecoration(color: Colors.black),
          child: Column(
            children: [Text("d2")],
            mainAxisSize: MainAxisSize.min,
          ),
        ),
      ),
    ];
    // final pageList = useMemoized(() {
    //   return [
    //     // ListView.builder(
    //     //     itemCount: 5,
    //     //     shrinkWrap: true,
    //     //     itemBuilder: (context, index) {
    //     //       var a = "aaa" * index;
    //     //       return Text("${a}");
    //     //     }),
    //     UnconstrainedBox(
    //         alignment: Alignment.topLeft,
    //         child: ConstrainedBox(
    //           constraints: BoxConstraints(
    //               minWidth: 300,
    //               maxWidth: 300,
    //               minHeight: maxHeight.value,
    //               maxHeight: maxHeight.value),
    //           child: DecoratedBox(
    //             decoration: BoxDecoration(color: Colors.green),
    //             child: SizeChangedLayoutNotifierNew(
    //                 child: Column(
    //               children: child1,
    //               mainAxisSize: MainAxisSize.min,
    //             )),
    //           ),
    //         )),
    //     SizedBox(
    //       width: 10,
    //       height: 5,
    //     ),
    //     ConstrainedBox(
    //       constraints: BoxConstraints(minWidth: 300, minHeight: 20),
    //       child: DecoratedBox(
    //         decoration: BoxDecoration(color: Colors.black),
    //         child: Column(
    //           children: [Text("d2")],
    //           mainAxisSize: MainAxisSize.min,
    //         ),
    //       ),
    //     ),
    //   ];
    // }, [child1.length, maxHeight.value]);
    return Container(
        color: Colors.yellow,
        child: NotificationListener<SizeChangedLayoutNotificationNew>(
            onNotification: (notification) {
              if (notification is SizeChangedLayoutNotificationNew) {
                var newHeight = 180 + notification.size.height;
                Timer(Duration(milliseconds: 0), () {
                  maxHeight.value = max(newHeight, maxHeight.value);
                });

                print("maxHeight: ${maxHeight.value} newHeight: ${newHeight}");
              }
              return false;
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints:
                      BoxConstraints(minWidth: 300, maxHeight: maxHeight.value),
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.red),
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(30, 80, 30, 40),
                        child: _ListView(
                          children: pageList,
                        )),
                  ),
                )
              ],
            )));
  }
}

class _ListView extends HookWidget {
  final List<Widget> children;

  const _ListView({required this.children});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
        scrollDirection: Axis.horizontal,
        children: children,
        padding: EdgeInsets.all(30));
  }
}

class SizeChangedLayoutNotificationNew extends Notification {
  final Size size;

  SizeChangedLayoutNotificationNew(this.size);
}

class SizeChangedLayoutNotifierNew extends SingleChildRenderObjectWidget {
  /// Creates a [SizeChangedLayoutNotifier] that dispatches layout changed
  /// notifications when [child] changes layout size.
  const SizeChangedLayoutNotifierNew({
    super.key,
    super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderSizeChangedWithCallbackNew(
      onLayoutChangedCallback: (size) {
        SizeChangedLayoutNotificationNew(size).dispatch(context);
      },
    );
  }
}

class _RenderSizeChangedWithCallbackNew extends RenderProxyBox {
  _RenderSizeChangedWithCallbackNew({
    RenderBox? child,
    required this.onLayoutChangedCallback,
  }) : super(child);

  // There's a 1:1 relationship between the _RenderSizeChangedWithCallback and
  // the `context` that is captured by the closure created by createRenderObject
  // above to assign to onLayoutChangedCallback, and thus we know that the
  // onLayoutChangedCallback will never change nor need to change.

  final Function(Size size) onLayoutChangedCallback;

  Size? _oldSize;

  @override
  void performLayout() {
    super.performLayout();
    // Don't send the initial notification, or this will be SizeObserver all
    // over again!
    if (_oldSize != null && size != _oldSize) {
      onLayoutChangedCallback(size);
    }
    _oldSize = size;
  }
}
