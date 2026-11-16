import 'package:flutter/material.dart';
import 'package:flutter_study/module/usecase/pages/canvas/CancasPage.dart';
import 'package:flutter_study/module/usecase/pages/canvas/PracticalExamplesPage.dart';
import 'package:flutter_study/module/usecase/pages/transition/custom/HTPageJump/PageA.dart';
import 'package:flutter_study/module/usecase/pages/transition/custom/HTPageJump/PageD.dart';
import 'package:flutter_study/module/usecase/pages/transition/custom/HTPageJump/TransitionHomePage.dart';
import 'package:flutter_study/module/usecase/pages/transition/page/MindSpaceHomePage.dart';
import 'package:flutter_study/module/usecase/pages/transition/page/MindSpaceHomePagetest.dart';
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

  testWidgets('opens both custom transition entry pages and returns', (
    tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: TransitionHomePage()));
    await tester.tap(find.text('跳转到PageA'));
    await tester.pumpAndSettle();
    expect(find.byType(PageA), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('跳转到PageD'));
    await tester.pumpAndSettle();
    expect(find.byType(PageD), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(TransitionHomePage), findsOneWidget);
  });

  testWidgets('opens both MindSpace transition variants and returns', (
    tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: MindSpaceHomePagetest()));
    for (final variant in ['完整示例', '无透明背景']) {
      await tester.tap(find.textContaining('($variant)'));
      await tester.pumpAndSettle();
      final page = find.byType(MindSpaceHomePage);
      expect(page, findsWidgets);
      Navigator.of(tester.element(page.first)).pop();
      await tester.pumpAndSettle();
      expect(find.byType(MindSpaceHomePagetest), findsOneWidget);
    }
  });
}
