import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// 顶层函数只接收可传递的数据，不捕获页面和控制器。
int sumNumbers(int limit) {
  var sum = 0;
  for (var number = 1; number <= limit; number++) {
    sum += number;
  }
  return sum;
}

class IsolatePage extends StatefulWidget {
  const IsolatePage({super.key});

  @override
  State<IsolatePage> createState() => _IsolatePageState();
}

class _IsolatePageState extends State<IsolatePage> {
  bool _running = false;
  String _result = '选择一种方式计算 1 到 1000 万的和。';
  int _taps = 0;

  Future<void> _calculate({required bool useCompute}) async {
    setState(() {
      _running = true;
      _result = '计算中，可以继续点击下方按钮。';
    });
    final watch = Stopwatch()..start();
    try {
      final sum = useCompute
          ? await compute(sumNumbers, 10000000)
          : await Isolate.run(() => sumNumbers(10000000));
      if (!mounted) return;
      setState(() {
        _result = '结果 $sum\n耗时 ${watch.elapsedMilliseconds} ms';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _result = '计算失败 $error');
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Isolate 实验')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card.filled(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Text('一次性计算', style: Theme.of(context).textTheme.titleLarge),
                  const Text('原生平台上，计算在独立 Isolate 执行，结果通过 Future 返回。'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton(
                        onPressed: _running || kIsWeb
                            ? null
                            : () => _calculate(useCompute: false),
                        child: const Text('Isolate.run'),
                      ),
                      OutlinedButton(
                        onPressed: _running
                            ? null
                            : () => _calculate(useCompute: true),
                        child: const Text('compute'),
                      ),
                    ],
                  ),
                  if (kIsWeb) const Text('Web 上 compute 在当前事件循环执行，无法展示后台并行计算。'),
                  if (_running) const LinearProgressIndicator(),
                  Text(_result),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => setState(() => _taps++),
            child: Text('测试界面响应 · $_taps 次'),
          ),
        ],
      ),
    );
  }
}
