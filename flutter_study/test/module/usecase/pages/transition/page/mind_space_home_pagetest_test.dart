import 'package:flutter/material.dart';
import 'package:flutter_study/module/usecase/pages/transition/page/MindSpaceHomePage.dart';
import 'package:flutter_study/module/usecase/pages/transition/page/MindSpaceHomePagetest.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
