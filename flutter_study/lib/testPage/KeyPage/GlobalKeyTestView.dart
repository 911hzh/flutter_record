import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class GlobalKeyTestView extends HookWidget {
  GlobalKeyTestView();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        children: [
          ParentView(),
          ParentView(),
          ParentView(),
        ],
      ),
    );
  }
}

class ParentView extends HookWidget {
  ParentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ChildView(),
    );
  }
}

class ChildView extends HookWidget {
  ChildView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("ChildView"),
    );
  }
}
