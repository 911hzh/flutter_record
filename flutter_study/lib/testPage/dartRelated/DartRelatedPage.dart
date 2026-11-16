import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_study/testPage/dartRelated/IsolateTest.dart';

class DartRelatedPage extends StatefulWidget {
  final String title;
  DartRelatedPage({super.key, required this.title});

  @override
  State<DartRelatedPage> createState() => _DartRelatedPageState();
}

class _DartRelatedPageState extends State<DartRelatedPage> {
  final testStream = StreamController<String>.broadcast(sync: true);
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(DartRelatedPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 方法1: 比较具体的属性
    if (widget.title != oldWidget.title) {
      print('Title 发生了变化: ${oldWidget.title} -> ${widget.title}');
      // 在这里执行需要的更新逻辑
      // 例如：重新加载数据、更新动画等
    }

    // 方法2: 使用多个条件判断
    bool needsUpdate = widget.title != oldWidget.title;

    if (needsUpdate) {
      print('检测到属性变化，执行更新操作');
      _handleWidgetUpdate(oldWidget);
    } else {
      print('属性未变化，跳过更新操作');
    }
  }

  // 集中处理更新逻辑
  void _handleWidgetUpdate(DartRelatedPage oldWidget) {
    // 在这里执行实际的更新操作
    // 比如重新订阅 Stream、更新控制器等
  }

  @override
  void reassemble() {
    super.reassemble();
  }

  void sendMessage() {
    testStream.add("test");
    print("sended Message: test");
  }

  void receiveMessage() {
    testStream.stream.listen((event) {
      print("receiveMessage: $event");
    });
  }

  void receiveMultipleMessage() async {
    testStream.stream.listen((event) {
      print("receiveMultipleMessage1: $event");
    });
    testStream.stream.listen((event) {
      print("receiveMultipleMessage2: $event");
    });
    testStream.stream.listen((event) {
      print("receiveMultipleMessage3: $event");
    });
    await for (final event in testStream.stream) {
      print("receiveMultipleMessage4: $event");
    }
    print("-------");
  }

  void futureMessage() async {
    final future = Future(() {});
    final List<Future<String>> futures = [];
    Future.wait(futures).then((value) {});
    Future.any(futures).then((value) {
      print("futureMessage: $value");
    });
    final a = Future.delayed(Duration(seconds: 1), () {
      print("futureMessage: test");
      return "test";
    });
    print("futureMessage: $a");
    final value = await a;
    print("futureMessage: $value");
    final value2 = await a;
    print("futureMessage: $value2");
  }

  void test() {
    final a = A();
    a.test();
    final ab = AB();
    ab.test();
    if (a is AB) {
      print("a is AB");
    }
    if (a is A) {
      print("ab is A");
    }
    if (ab is A) {
      print("ab is AB");
    }
    dynamic d = a;
    final asA = d as A?;
  }

  @override
  void activate() {
    // TODO: implement activate
    super.activate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dart 相关')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Stream 相关")]),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              color: Colors.red,
              child: Column(
                spacing: 10,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [ElevatedButton(onPressed: sendMessage, child: Text('发送消息'))],
                  ),
                  ElevatedButton(onPressed: receiveMessage, child: Text('接收消息')),
                  ElevatedButton(onPressed: receiveMultipleMessage, child: Text('接收多条消息')),
                  ElevatedButton(
                    onPressed: () {
                      testStream.close();
                    },
                    child: Text('close stream'),
                  ),
                ],
              ),
            ),

            Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Future 相关")]),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              color: Colors.red,
              child: Column(
                spacing: 10,
                children: [ElevatedButton(onPressed: futureMessage, child: Text('Future 消息'))],
              ),
            ),

            Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Isolate 相关")]),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              color: Colors.red,
              child: Column(
                spacing: 10,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final date = DateTime.now();
                      await IsolateTest().testSpawn();
                      print("time duration: ${DateTime.now().difference(date).inMilliseconds}ms");
                    },
                    child: Text('Future 消息'),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                print("class to string: ${ABA3().runtimeType.toString()}");
              },
              child: Container(
                width: 20,
                height: 30,
                color: Colors.red,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "test1111111",
                        style: TextStyle(fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class M {
  const M({required this.a});
  final A a;
}

class A {
  late String name = () {
    print("name");
    return "name";
  }();
  A();
  void test() {
    String a(String name) {
      print("a: $name");
      return "a: $name";
    }

    a("11");

    name = "11";
  }
}

class AB extends A {
  AB();
  @override
  void test() {
    print("AB test");
  }
}

abstract class ABA {
  final a = "";
  void test();
  void test2() {
    print("object");
  }
}

abstract class ABA2 extends ABA {
  @override
  void test() {
    print("object");
  }
}

class ABA3 implements ABA {
  final String a = "";
  @override
  void test2() {
    print("object");
  }

  @override
  void test() {
    print("object");
  }
}

mixin M3 on A {
  void test3() {
    print("object");
  }
}
mixin M4 on A {
  void test4() {
    print("object");
  }
}
