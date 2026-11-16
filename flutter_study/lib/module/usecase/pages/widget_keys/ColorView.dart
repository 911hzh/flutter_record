import 'dart:math';

import 'package:flutter/material.dart';
import "package:flutter/src/widgets/framework.dart";
import 'package:flutter_study/module/usecase/pages/widget_keys/KeyPage.dart';
import "package:flutter_hooks/flutter_hooks.dart";

class ColorStateLessView extends HookWidget {
  final Color color;

  const ColorStateLessView({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(color: color, child: Padding(padding: EdgeInsets.all(70.0), key: ObjectKey([1, 2])));
  }
}

class ColorStateFullView extends HookWidget {
  const ColorStateFullView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var myColor = useState(UniqueColorGenerator.getColor());
    // TODO: implement build
    return Container(color: myColor.value, child: const Padding(padding: EdgeInsets.all(70.0)));
  }
}
