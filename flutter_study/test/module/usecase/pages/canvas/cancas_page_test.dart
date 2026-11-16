import 'package:flutter/material.dart';
import 'package:flutter_study/module/usecase/pages/canvas/CancasPage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('visits all basic Canvas examples', (tester) async {
    await tester.pumpWidget(MaterialApp(home: CanvasPage()));
    for (final label in ['基础图形', '路径绘制', '文字&渐变', '动画绘制', 'CheckSize']) {
      final tab = find.text(label);
      await tester.ensureVisible(tab);
      await tester.tap(tab);
      await tester.pump();
      expect(tester.widget<Text>(tab).style?.fontWeight, FontWeight.bold);
    }
  });
}
