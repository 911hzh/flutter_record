import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_study/module/usecase/pages/bloc/ConcurrencyExampleWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/module/usecase/pages/bloc/BlocExampleWidget.dart';
import 'package:flutter_study/module/usecase/pages/bloc/CubitExampleWidget.dart';

class BlocBuilderPage extends StatelessWidget {
  const BlocBuilderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cubit 与 Bloc')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('相同的加减意图，分别通过方法调用和枚举事件表达。两个计数互相独立。'),
            const SizedBox(height: 12),
            const CubitExampleWidget(),
            const SizedBox(height: 12),
            const BlocExampleWidget(),
            const SizedBox(height: 12),
            ConcurrencyExampleWidget(
              title: 'concurrent · 照片同时上传',
              description: '三张照片互相独立，可以同时上传。照片 2 较小，会先完成。',
              transformer: concurrent<int>(),
            ),
            ConcurrencyExampleWidget(
              title: 'sequential · 照片逐张上传',
              description: '同样三张照片，前一张完成后才开始下一张。观察等待时间。',
              transformer: sequential<int>(),
            ),
            ConcurrencyExampleWidget(
              title: 'droppable · 忽略重复',
              description: '这里只上传照片 1，照片 2、3 被忽略。需要全部上传的业务应选择其他策略。',
              transformer: droppable<int>(),
            ),
            ConcurrencyExampleWidget(
              title: 'restartable · 最新优先',
              description: '只有照片 3 发布完成结果，旧处理器停止发布结果。此策略更适合只关心最新输入的搜索。',
              transformer: restartable<int>(),
            ),
          ],
        ),
      ),
    );
  }
}
