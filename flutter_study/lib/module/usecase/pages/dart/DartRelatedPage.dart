import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_study/module/usecase/pages/dart/IsolateTest.dart';

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
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 12,
                children: [
                  Text(
                    '运行实验，在调试控制台查看输出。',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  _experimentCard(
                    context,
                    icon: Icons.stream,
                    title: 'Stream',
                    description: '观察广播流中的单个监听者和多个监听者。',
                    actions: [
                      FilledButton.tonal(
                        onPressed: testStream.isClosed ? null : receiveMessage,
                        child: const Text('添加监听'),
                      ),
                      FilledButton.tonal(
                        onPressed: testStream.isClosed
                            ? null
                            : receiveMultipleMessage,
                        child: const Text('添加多个监听'),
                      ),
                      OutlinedButton(
                        onPressed: testStream.isClosed ? null : sendMessage,
                        child: const Text('发送消息'),
                      ),
                      TextButton(
                        onPressed: testStream.isClosed
                            ? null
                            : () {
                                setState(() {
                                  testStream.close();
                                });
                              },
                        child: Text(
                          testStream.isClosed ? 'Stream 已关闭' : '关闭 Stream',
                        ),
                      ),
                    ],
                  ),
                  _experimentCard(
                    context,
                    icon: Icons.hourglass_bottom,
                    title: 'Future',
                    description: '观察延迟任务以及多次 await 同一个 Future 的输出。',
                    actions: [
                      FilledButton.tonal(
                        onPressed: futureMessage,
                        child: const Text('运行 Future 实验'),
                      ),
                    ],
                  ),
                  _experimentCard(
                    context,
                    icon: Icons.memory,
                    title: 'Isolate',
                    description: '启动独立 Isolate，通过消息端口接收结果。',
                    actions: [
                      FilledButton.tonal(
                        onPressed: () async {
                          final date = DateTime.now();
                          await IsolateTest().testSpawn();
                          print(
                            "time duration: ${DateTime.now().difference(date).inMilliseconds}ms",
                          );
                        },
                        child: const Text('运行 Isolate 实验'),
                      ),
                    ],
                  ),
                  _experimentCard(
                    context,
                    icon: Icons.data_object,
                    title: '运行时类型',
                    description: '查看 ABA3 实例的 runtimeType。',
                    actions: [
                      FilledButton.tonal(
                        onPressed: () {
                          print("class to string: ${ABA3().runtimeType}");
                        },
                        child: const Text('打印类型'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _experimentCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required List<Widget> actions,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card.filled(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: colors.primaryContainer,
                  foregroundColor: colors.onPrimaryContainer,
                  child: Icon(icon),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(title, style: theme.textTheme.titleLarge)),
              ],
            ),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            Wrap(spacing: 8, runSpacing: 4, children: actions),
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
