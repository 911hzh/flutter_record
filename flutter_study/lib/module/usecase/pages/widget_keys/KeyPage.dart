import 'package:flutter/material.dart';
import 'package:flutter_study/module/usecase/pages/widget_keys/ColorView.dart';

class KeyPage extends StatefulWidget {
  const KeyPage({super.key});

  @override
  State<KeyPage> createState() => _KeyPageState();
}

class _KeyPageState extends State<KeyPage> {
  List<Widget> _unkeyedItems = [
    ColorStateFullView(id: 0),
    ColorStateFullView(id: 1),
  ];
  List<Widget> _keyedItems = [
    ColorStateFullView(key: ValueKey(0), id: 0),
    ColorStateFullView(key: ValueKey(1), id: 1),
  ];
  int _rebuilds = 0;

  void _swapItems() {
    setState(() {
      _unkeyedItems = [_unkeyedItems[1], _unkeyedItems[0]];
      _keyedItems = [_keyedItems[1], _keyedItems[0]];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Key Page')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('先分别点两组的 A，再交换顺序。对比计数和颜色跟着位置走，还是跟着项目走。'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton(onPressed: _swapItems, child: const Text('交换顺序')),
            OutlinedButton(
              onPressed: () => setState(() => _rebuilds++),
              child: Text('普通重建（${_rebuilds}）'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildCard('无 Key', _unkeyedItems),
        const SizedBox(height: 12),
        _buildCard('稳定 ValueKey', _keyedItems),
      ],
    );
  }

  Widget _buildCard(String title, List<Widget> items) {
    return Card.filled(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            Wrap(spacing: 8, runSpacing: 8, children: items),
          ],
        ),
      ),
    );
  }
}
