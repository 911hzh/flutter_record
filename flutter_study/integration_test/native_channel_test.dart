import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_study/main.dart' as study;
import 'package:flutter_study/module/route/RouteConfig.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('receives a LocationMsg from the platform handler', (
    tester,
  ) async {
    await study.main();
    await tester.pumpAndSettle();
    getRouter().push<void>('/zh_native_channel_demo');
    await tester.pumpAndSettle();
    await tester.tap(find.text('发送 LocationMsg'));
    final response = find.textContaining('返回类型: LocationMsg');
    for (
      var attempt = 0;
      attempt < 50 && response.evaluate().isEmpty;
      attempt++
    ) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(response, findsOneWidget);
    expect(find.textContaining('调用失败'), findsNothing);
  });
}
