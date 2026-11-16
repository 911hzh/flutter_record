import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_study/module/usecase/pages/inherited_widget/HasDependsWidget.dart';
import 'package:flutter_study/module/usecase/pages/inherited_widget/NoDependsWidget.dart';
import 'package:flutter_study/module/usecase/pages/inherited_widget/SharedCountInheritedWidget.dart';

class InheritedWidgetTestPage extends StatefulWidget {
  const InheritedWidgetTestPage({super.key});

  @override
  State<InheritedWidgetTestPage> createState() =>
      _InheritedWidgetTestPageState();
}

class _InheritedWidgetTestPageState extends State<InheritedWidgetTestPage> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    RenderPadding renderPadding = RenderPadding(padding: EdgeInsets.all(10));
    return Scaffold(
      appBar: AppBar(
        title: const Text('InheritedWidget 测试'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SharedCountInheritedWidget(
        count: count,
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    color: Colors.red,
                    child: Text(
                      "LayoutBuilder: ${constraints.maxWidth} ${constraints.maxHeight}",
                    ),
                  );
                },
              ),
            ),
            const HasDependsWidget(),
            const NoDependsWidget(),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      count++;
                    });
                  },
                  child: const Text('增加计数'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(InheritedWidgetTestPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("InheritedWidgetTestPage didUpdateWidget");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("InheritedWidgetTestPage didChangeDependencies");
  }

  @override
  void dispose() {
    super.dispose();
    print("InheritedWidgetTestPage dispose");
  }
}
