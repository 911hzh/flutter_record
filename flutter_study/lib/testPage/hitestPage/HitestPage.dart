import 'package:flutter/material.dart';

class HitestPage extends StatefulWidget {
  const HitestPage({super.key});

  @override
  State<HitestPage> createState() => _HitestPageState();
}

class _HitestPageState extends State<HitestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HitestPage')),
      body: Stack(
        children: <Widget>[
          Listener(
            child: ConstrainedBox(
              constraints: BoxConstraints.tight(Size(300.0, 300.0)),
              child: DecoratedBox(decoration: BoxDecoration(color: Colors.red)),
            ),
            onPointerDown: (event) => print("first child"),
          ),
          Listener(
            child: ConstrainedBox(
              constraints: BoxConstraints.tight(Size(200.0, 200.0)),
              child: Center(child: Text("左上角200*200范围内-空白区域点击")),
            ),
            onPointerDown: (event) => print("second child"),
            //放开此行注释后，单词点击 first ,second都会响应，HitTestBehavior.opaque是不行的
            behavior: HitTestBehavior.translucent,
          ),
        ],
      ),
    );
  }
}
