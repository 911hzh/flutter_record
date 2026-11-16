import 'package:flutter/material.dart';
import 'package:flutter_study/main.dart' as study;
import 'package:flutter_study/module/route/RouteConfig.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('shows the iOS platform view and opens its gesture demo', (
    tester,
  ) async {
    await study.main();
    await tester.pumpAndSettle();
    getRouter().push<void>('/native_test_page');
    await tester.pumpAndSettle();
    expect(find.byType(UiKitView), findsOneWidget);
    final gestureDemo = find.text('打开重叠手势验证页');
    await tester.ensureVisible(gestureDemo);
    await tester.tap(gestureDemo);
    await tester.pumpAndSettle();
    expect(find.text('打开重叠手势验证页'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
