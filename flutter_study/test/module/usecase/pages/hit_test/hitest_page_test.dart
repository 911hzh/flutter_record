import 'package:flutter/material.dart';
import 'package:flutter_study/module/usecase/pages/hit_test/HitestPage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('padding example counts presses according to listener behavior', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HitestPage()));

    final exampleText = find.text('示例文字');
    for (var index = 0; index < 2; index++) {
      await tester.tap(exampleText.at(index));
    }
    await tester.pump();
    expect(find.text('收到 1 次按下'), findsNWidgets(2));

    for (var index = 0; index < 2; index++) {
      await tester.tapAt(
        tester.getTopLeft(exampleText.at(index)) + const Offset(8, -12),
      );
    }
    await tester.pump();
    expect(find.text('收到 1 次按下'), findsOneWidget);
    expect(find.text('收到 2 次按下'), findsOneWidget);
  });

  testWidgets('compares pointer delivery for all hit test behaviors', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MaterialApp(home: HitestPage()));

    expect(find.byType(Card), findsNWidgets(2));
    final blankArea = find.text('上层空白区');
    await tester.scrollUntilVisible(blankArea, 150);
    await tester.tapAt(tester.getCenter(blankArea));
    await tester.pump();
    expect(find.text('最近一次按下：上层'), findsOneWidget);

    const blankAreaReceivers = {
      HitTestBehavior.deferToChild: '下层',
      HitTestBehavior.opaque: '上层',
      HitTestBehavior.translucent: '上层 → 下层',
    };
    for (final entry in blankAreaReceivers.entries) {
      final choice = find.widgetWithText(ChoiceChip, entry.key.name);
      await tester.ensureVisible(choice);
      await tester.tap(choice);
      await tester.pumpAndSettle();

      for (final (area, expected) in [
        ('上层空白区', entry.value),
        ('上层子组件', '上层'),
        ('下层独占区', '下层'),
      ]) {
        // The blank area label is drawn by the lower layer.
        final target = find.text(area);
        await tester.ensureVisible(target);
        await tester.tapAt(tester.getCenter(target));
        await tester.pump();
        expect(find.text('最近一次按下：$expected'), findsOneWidget);
      }
    }
  });
}
