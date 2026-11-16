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
    return Scaffold(
      appBar: AppBar(title: const Text('Provider 测试'), backgroundColor: Colors.deepPurple),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => testModel),
          ChangeNotifierProvider(create: (context) => studentModel),
        ],
        child: Column(
          children: [
            Text('Provider 测试'),

            // Builder(
            //   builder: (context) {
            //     // final testModel = Provider.of<TestModel>(context);
            //     return ElevatedButton(
            //       onPressed: () {
            //         testModel.increment();
            //         studentModel.setName('张三');
            //       },
            //       child: Text('增加计数 ${testModel.count}'),
            //     );
            //   },
            // ),
            ElevatedButton(
              onPressed: () async {
                testModel.increment();
                studentModel.setName('张三');
                print('准备开始'); // 假设外面还有一句同步代码

                // 你的代码在这里：
                await Future(() => print("333")).then((value) => print(44));

                print('await 终于结束了'); // 这是 await 后面的代码
              },
              child: Text('增加计数 ${testModel.count}'),
            ),
            const ConsumerTestWidget(),
            const Consumer2TestWidget(),
            const ProviderTestWidget(),
            const WatchTestWidget(),
            const ReadTestWidget(),
            const SelectTestWidget(),
            const SelectorTestWidget(),
          ],
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
        return Text('ConsumerTestWidget: ${testModel.count}');
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
        return Text('Consumer2TestWidget: ${testModel.count} ${studentModel.name}');
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
    return Text('ProviderTestWidget: ${testModel.count}');
  }
}

class WatchTestWidget extends StatelessWidget {
  const WatchTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final testModel = context.watch<TestModel>();
    return Text('WatchTestWidget: ${testModel.count}');
  }
}

class ReadTestWidget extends StatelessWidget {
  const ReadTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final testModel = context.read<TestModel>();
    return Text('ReadTestWidget: ${testModel.count}');
  }
}

class SelectTestWidget extends StatelessWidget {
  const SelectTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final count = context.select((TestModel testModel) => testModel.count);
    return Text('SelectTestWidget: ${count}');
  }
}

class SelectorTestWidget extends StatelessWidget {
  const SelectorTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<TestModel, int>(
      selector: (context, testModel) => testModel.count,
      builder: (context, count, child) {
        return Text('SelectorTestWidget: ${count}');
      },
    );
  }
}
