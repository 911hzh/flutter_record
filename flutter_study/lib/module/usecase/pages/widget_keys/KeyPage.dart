import 'dart:math';

import 'package:flutter/material.dart';
import "package:flutter/src/widgets/framework.dart";
import 'package:flutter_study/module/usecase/pages/widget_keys/ColorView.dart';
import "package:flutter_hooks/flutter_hooks.dart";

class KeyPage extends HookWidget {
  KeyPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _AppBarView(title: "key page"), body: PositionView());
  }
}

class _AppBarView extends AppBar {
  _AppBarView({Key? key, required String title, VoidCallback? onBack})
    : super(
        key: key,
        leading: IconButton(icon: const Icon(Icons.arrow_back, size: 28), onPressed: onBack),
        title: Text(title),
      );
}

class A {
  final name;
  final age;

  A({required this.name, required this.age});
}

class PositionView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    // var colorItems = useState([
    //   ColorStateFullView(
    //     key: const ValueKey("a"),
    //   ),
    //   ColorStateFullView(
    //     key: const ValueKey("b"),
    //   )
    // ]);

    // var colorItems = useState([
    //   ColorStateFullView(
    //     key: UniqueKey(),
    //   ),
    //   ColorStateFullView(
    //     key: UniqueKey(),
    //   )
    // ]);

    var colorItems = useState([
      ColorStateLessView(color: UniqueColorGenerator.getColor()),
      ColorStateLessView(color: UniqueColorGenerator.getColor()),
    ]);
    // var c = ObjectKey(const ["a", "b"]);
    // print("a==c ${a == c}");
    return Column(
      children: [
        Padding(padding: EdgeInsets.fromLTRB(20, 20, 20, 20), child: Wrap(children: [...colorItems.value])),
        FloatingActionButton(
          onPressed: () {
            var colors = colorItems.value;
            colors = colors.reversed.toList();
            colorItems.value = colors;
          },
          child: const Text("switch"),
        ),
        FloatingActionButton(
          onPressed: () {
            var colors = colorItems.value;
            // colors.add(ColorStateFullView(
            //   key: UniqueKey(),
            // ));
            colorItems.value = [...colors];
          },
          child: const Text("add"),
          heroTag: "add",
        ),
        FloatingActionButton(
          onPressed: () {
            var colors = colorItems.value;
            colors.removeAt(0);
            colorItems.value = [...colors];
          },
          child: const Text("remove first"),
          heroTag: "remove first",
        ),
        FloatingActionButton(
          onPressed: () {
            var colors = colorItems.value;
            colors.removeLast();
            colorItems.value = [...colors];
          },
          child: const Text("remove last"),
          heroTag: "remove last",
        ),
      ],
    );
    // TODO: implement build
  }
}

class UniqueColorGenerator {
  static Random random = new Random();

  static Color getColor() {
    return Color.fromARGB(255, random.nextInt(255), random.nextInt(255), random.nextInt(255));
  }
}
