import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderTestPage extends StatefulWidget {
  const ProviderTestPage({super.key});

  @override
  State<ProviderTestPage> createState() => _ProviderTestPageState();
}

class TestModel extends ChangeNotifier {
  int count = 0;

  void increment() {
    count++;
    notifyListeners(); // 通知所有监听者数据已更新
  }
}

class StudentModel extends ChangeNotifier {
  String name = '';

  void setName(String name) {
    this.name = name;
    notifyListeners(); // 通知所有监听者数据已更新
  }
}

class _ProviderTestPageState extends State<ProviderTestPage> {
  final testModel = TestModel();
  final studentModel = StudentModel();
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Provider 测试')),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => testModel),
          ChangeNotifierProvider(create: (context) => studentModel),
        ],
        child: SafeArea(
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
                    Card.filled(
                      margin: EdgeInsets.zero,
                      color: theme.colorScheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 12,
                          children: [
                            Text(
                              '更新共享状态',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                            Text(
                              '每次点击将计数加 1，并把姓名设为张三。观察下方各读取方式显示的值。',
                              style: TextStyle(
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                            FilledButton.icon(
                              icon: const Icon(Icons.add),
                              label: const Text('增加计数'),
                              onPressed: () async {
                                testModel.increment();
                                studentModel.setName('张三');
                                print('准备开始');
                                await Future(
                                  () => print('333'),
                                ).then((value) => print(44));
                                print('await 终于结束了');
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text('订阅结果', style: theme.textTheme.titleMedium),
                    const Card.filled(
                      margin: EdgeInsets.zero,
                      child: Column(
                        children: [
                          ConsumerTestWidget(),
                          Consumer2TestWidget(),
                          ProviderTestWidget(),
                          WatchTestWidget(),
                          SelectTestWidget(),
                          SelectorTestWidget(),
                        ],
                      ),
                    ),
                    Text('单次读取', style: theme.textTheme.titleMedium),
                    const Card.filled(
                      margin: EdgeInsets.zero,
                      child: ReadTestWidget(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ConsumerTestWidget extends StatelessWidget {
  const ConsumerTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TestModel>(
      builder: (context, testModel, child) {
        return _ProviderResult(
          method: 'Consumer',
          detail: '订阅一个模型',
          value: '${testModel.count}',
        );
      },
      child: Text('ConsumerTestWidget: ${0}'),
    );
  }
}

class Consumer2TestWidget extends StatelessWidget {
  const Consumer2TestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<TestModel, StudentModel>(
      builder: (context, testModel, studentModel, child) {
        return _ProviderResult(
          method: 'Consumer2',
          detail:
              '订阅两个模型 · ${studentModel.name.isEmpty ? '未设置姓名' : studentModel.name}',
          value: '${testModel.count}',
        );
      },
      child: Text('Consumer2TestWidget: ${0} ${0}'),
    );
  }
}

class ProviderTestWidget extends StatelessWidget {
  const ProviderTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final testModel = Provider.of<TestModel>(context);
    return _ProviderResult(
      method: 'Provider.of',
      detail: '默认订阅模型',
      value: '${testModel.count}',
    );
  }
}

class WatchTestWidget extends StatelessWidget {
  const WatchTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final testModel = context.watch<TestModel>();
    return _ProviderResult(
      method: 'context.watch',
      detail: '订阅模型',
      value: '${testModel.count}',
    );
  }
}

class ReadTestWidget extends StatelessWidget {
  const ReadTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final testModel = context.read<TestModel>();
    return _ProviderResult(
      method: 'context.read',
      detail: '读取一次，无订阅',
      value: '${testModel.count}',
    );
  }
}

class SelectTestWidget extends StatelessWidget {
  const SelectTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final count = context.select((TestModel testModel) => testModel.count);
    return _ProviderResult(
      method: 'context.select',
      detail: '订阅 count 字段',
      value: '$count',
    );
  }
}

class SelectorTestWidget extends StatelessWidget {
  const SelectorTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<TestModel, int>(
      selector: (context, testModel) => testModel.count,
      builder: (context, count, child) {
        return _ProviderResult(
          method: 'Selector',
          detail: '订阅 count 字段',
          value: '$count',
        );
      },
    );
  }
}

class _ProviderResult extends StatelessWidget {
  const _ProviderResult({
    required this.method,
    required this.detail,
    required this.value,
  });

  final String method;
  final String detail;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(method),
      subtitle: Text(detail),
      trailing: Text(
        value,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
