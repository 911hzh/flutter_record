import 'package:flutter_study/module/usecase/pages/bloc/ConcurrencyExampleWidget.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_study/module/usecase/pages/bloc/TaskBloc.dart';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/module/usecase/pages/bloc/BlocBuilderPage.dart';
import 'package:flutter_study/module/usecase/pages/isolate/IsolatePage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('方法调用与事件提交分别更新各自计数', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: BlocBuilderPage()));
    expect(find.text('0'), findsNWidgets(2));
    await tester.tap(find.text('increment()'));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
    await tester.ensureVisible(find.text('add(CounterEvent.increment)'));
    await tester.tap(find.text('add(CounterEvent.increment)'));
    await tester.pump();
    expect(find.text('1'), findsNWidgets(2));
    expect(find.textContaining('increment：0 → 1'), findsOneWidget);
    await tester.ensureVisible(find.text('add(CounterEvent.decrement)'));
    await tester.tap(find.text('add(CounterEvent.decrement)'));
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    await tester.ensureVisible(find.text('add(CounterEvent.decrement)'));
    await tester.tap(find.text('add(CounterEvent.decrement)'));
    await tester.pump();
    expect(find.text('-1'), findsOneWidget);
    await tester.ensureVisible(find.text('decrement()'));
    await tester.tap(find.text('decrement()'));
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
    expect(find.text('-1'), findsOneWidget);
  });

  testWidgets('并发上传时小照片先完成且三张最终全部完成', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ConcurrencyExampleWidget(
            title: '照片上传',
            description: '三张照片同时上传',
            transformer: concurrent<int>(),
          ),
        ),
      ),
    );
    await tester.tap(find.text('上传三张照片'));
    await tester.pump();
    expect(find.text('已开始'), findsNWidgets(3));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('上传完成'), findsOneWidget);
    expect(find.text('已开始'), findsNWidgets(2));
    await tester.pump(const Duration(milliseconds: 900));
    expect(find.text('上传完成'), findsNWidgets(3));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  final policies = {
    'concurrent': concurrent<int>(),
    'sequential': sequential<int>(),
    'droppable': droppable<int>(),
    'restartable': restartable<int>(),
  };
  final expected = {
    'concurrent': [
      '照片 1 开始上传',
      '照片 2 开始上传',
      '照片 3 开始上传',
      '照片 2 上传完成',
      '照片 1 上传完成',
      '照片 3 上传完成',
    ],
    'sequential': [
      '照片 1 开始上传',
      '照片 1 上传完成',
      '照片 2 开始上传',
      '照片 2 上传完成',
      '照片 3 开始上传',
      '照片 3 上传完成',
    ],
    'droppable': ['照片 1 开始上传', '照片 1 上传完成'],
    'restartable': ['照片 1 开始上传', '照片 2 开始上传', '照片 3 开始上传', '照片 3 上传完成'],
  };
  for (final policy in policies.entries) {
    test('${policy.key} 的异步任务顺序', () async {
      final bloc = TaskBloc(transformer: policy.value);
      for (var id = 1; id <= 3; id++) {
        bloc.add(id);
      }
      await Future<void>.delayed(const Duration(seconds: 3));
      expect(bloc.state, expected[policy.key]);
      await bloc.close();
    });
  }

  test('两种 Isolate 方式返回相同结果', () async {
    expect(await Isolate.run(() => sumNumbers(10000000)), 50000005000000);
    expect(await compute(sumNumbers, 10000000), 50000005000000);
  });
}
