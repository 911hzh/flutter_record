import 'package:flutter/material.dart';
import 'package:flutter_study/module/usecase/pages/layout/WithExpandedWidget.dart';
import 'package:flutter_study/module/usecase/pages/layout/WithoutExpandedWidget.dart';

class ExpandedPage extends StatelessWidget {
  const ExpandedPage({super.key});

  static const _text =
      '这是一段用来比较布局的长文字。图标占 20 个逻辑像素，'
      '间距占 8 个逻辑像素。观察剩下的空间够不够放下整段文字。';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expanded View')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            WithoutExpandedWidget(text: _text),
            SizedBox(height: 12),
            WithExpandedWidget(text: _text),
          ],
        ),
      ),
    );
  }
}
