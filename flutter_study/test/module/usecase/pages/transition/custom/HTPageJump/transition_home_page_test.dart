import 'package:flutter/material.dart';
import 'package:flutter_study/module/usecase/pages/transition/custom/HTPageJump/PageA.dart';
import 'package:flutter_study/module/usecase/pages/transition/custom/HTPageJump/PageD.dart';
import 'package:flutter_study/module/usecase/pages/transition/custom/HTPageJump/TransitionHomePage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
}
