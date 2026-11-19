import 'package:flutter/material.dart';
import 'package:flutter_study/module/usecase/pages/animation/AnimateSeconedPage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('下拉返回后仍能再次打开页面并点击返回', (tester) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MaterialApp(navigatorKey: navigatorKey, home: const AnimateSeconedPage()),
    );
    await tester.tap(find.text('打开下拉返回页'));
    await tester.pumpAndSettle();
    await tester.drag(find.text('向下拖动页面'), const Offset(0, 220));
    await tester.pumpAndSettle();
    expect(find.text('向下拖动页面'), findsNothing);
    expect(navigatorKey.currentState!.userGestureInProgress, isFalse);

    await tester.tap(find.text('打开下拉返回页'));
    await tester.pumpAndSettle();
    expect(find.text('向下拖动页面'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('打开下拉返回页'), findsOneWidget);
  });

  testWidgets('下拉过程中上一页继续参与绘制', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AnimateSeconedPage()));
    await tester.tap(find.text('打开下拉返回页'));
    await tester.pumpAndSettle();
    final route = ModalRoute.of(tester.element(find.text('向下拖动页面')))!;
    expect(route.opaque, isFalse);
    expect(find.text('转场已完成'), findsOneWidget);
    final gesture = await tester.startGesture(
      tester.getCenter(find.text('向下拖动页面')),
    );
    await gesture.moveBy(const Offset(0, 160));
    await tester.pump();
    expect(find.text('转场已完成'), findsOneWidget);
    await gesture.up();
    await tester.pumpAndSettle();
    expect(find.text('向下拖动页面'), findsNothing);
  });

  testWidgets('短距离下拉和取消后仍可操作', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AnimateSeconedPage()));
    await tester.tap(find.text('打开下拉返回页'));
    await tester.pumpAndSettle();
    await tester.drag(find.text('向下拖动页面'), const Offset(0, 50));
    await tester.pumpAndSettle();
    expect(find.text('向下拖动页面'), findsOneWidget);
    final gesture = await tester.startGesture(
      tester.getCenter(find.text('向下拖动页面')),
    );
    await gesture.moveBy(const Offset(0, 70));
    await tester.pump();
    await gesture.cancel();
    await tester.pumpAndSettle();
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('打开下拉返回页'), findsOneWidget);
  });
}
