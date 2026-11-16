import 'package:flutter/material.dart';
import 'package:flutter_study/module/usecase/pages/canvas/PracticalExamplesPage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('visits all practical Canvas examples and clears a stroke', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1100, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(MaterialApp(home: PracticalExamplesPage()));
    for (final label in [
      '进度圆环',
      '折线图',
      '仪表盘',
      '水波纹',
      '签名板',
      '雷达图',
      '渐变文字',
      '动画渐变',
    ]) {
      final tab = find.text(label, skipOffstage: false).first;
      await tester.ensureVisible(tab);
      await tester.tap(tab);
      await tester.pump();
      expect(tester.widget<Text>(tab).style?.fontWeight, FontWeight.bold);
      if (label == '签名板') {
        final board = find.byWidgetPredicate(
          (widget) =>
              widget is CustomPaint &&
              widget.painter?.runtimeType.toString() == 'SignaturePainter',
        );
        final undo = find.widgetWithText(ElevatedButton, '撤销');
        expect(tester.widget<ElevatedButton>(undo).onPressed, isNull);
        await tester.drag(board, const Offset(40, 30));
        await tester.pump();
        expect(tester.widget<ElevatedButton>(undo).onPressed, isNotNull);
        await tester.tap(find.widgetWithText(ElevatedButton, '清除'));
        await tester.pump();
        expect(tester.widget<ElevatedButton>(undo).onPressed, isNull);
      }
    }
  });
}
