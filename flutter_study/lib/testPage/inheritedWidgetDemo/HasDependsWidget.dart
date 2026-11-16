import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_study/testPage/inheritedWidgetDemo/SharedCountInheritedWidget.dart';

class HasDependsWidget extends StatelessWidget {
  const HasDependsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final count = SharedCountInheritedWidget.of(context)?.count ?? 0;
    return Container(margin: const EdgeInsets.all(10), color: Colors.blue, child: Text("HasDependsWidget: $count"));
  }
}

// class A extends SingleChildRenderObjectWidget {
//   const A({super.key});

//   @override
//   RenderObject createRenderObject(BuildContext context) {
//     return RenderShiftedBox(child: child);
//   }
// }
class A {
  void test5() {
    print("A test5");
  }
}

extension B on A {
  void test() {
    print("B test");
  }
}

mixin C on A {
  void test2() {
    print("C test");
  }
}

abstract class AB {
  void test3();
}

mixin M implements AB {}

class E extends A with M {
  @override
  void test3() {
    print("E test2");
  }
}

mixin M2 on A {
  void test5() {
    super.test5();
  }
}

// class E implements C {
//   @override
//   void test2() {
//     print("E test2");
//   }
// }
