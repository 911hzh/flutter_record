import 'package:flutter/material.dart';
import 'package:flutter_study/testPage/inheritedWidgetDemo/SharedCountInheritedWidget.dart';

class NoDependsWidget extends StatelessWidget {
  const NoDependsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final count = SharedCountInheritedWidget.ofWithoutDependency(context)?.count ?? 0;
    return Container(
      margin: const EdgeInsets.all(10),
      color: Colors.red,
      child: Column(children: [Text("NoDependsWidget: $count")]),
    );
  }
}

class Student {
  var name = "";
  var age = 0;
  var gender = "";
  var address = "";
  var phone = "";
  var email = "";
  var password = "";
  var confirmPassword = "";
  void test() {}
  void test2() {}
}
