import 'package:flutter/material.dart';
import 'package:flutter_study/module/usecase/pages/widget_keys/KeyPage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('重排时只有稳定 ValueKey 让状态跟随项目', (tester) async {
    await tester.pumpWidget(MaterialApp(home: KeyPage()));

    final comparisonCards = find.byType(Card);
    final unkeyed = comparisonCards.first;
    final keyed = comparisonCards.last;

    Finder label(Finder card, String text) =>
        find.descendant(of: card, matching: find.text(text));

    Color? indicator(Finder card, String text) {
      final button = find.ancestor(
        of: label(card, text),
        matching: find.byType(OutlinedButton),
      );
      return tester
          .widget<Icon>(
            find.descendant(of: button, matching: find.byIcon(Icons.circle)),
          )
          .color;
    }

    await tester.tap(label(unkeyed, 'A · 0 次'));
    await tester.tap(label(keyed, 'A · 0 次'));
    await tester.pump();

    await tester.tap(find.text('交换顺序'));
    await tester.pump();

    expect(indicator(unkeyed, 'B · 1 次'), Colors.red);
    expect(indicator(unkeyed, 'A · 0 次'), Colors.blue);
    expect(indicator(keyed, 'B · 0 次'), Colors.blue);
    expect(indicator(keyed, 'A · 1 次'), Colors.red);

    await tester.tap(find.text('普通重建（0）'));
    await tester.pump();

    expect(indicator(unkeyed, 'B · 1 次'), Colors.red);
    expect(indicator(keyed, 'A · 1 次'), Colors.red);
  });
}
