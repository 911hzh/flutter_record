import 'package:flutter/material.dart';
import 'package:flutter_study/module/route/RouteConfig.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  // These are the public route paths registered by the original study app.
  const paths = [
    '/list_item_page',
    '/dart_related',
    '/inherited_widget_index',
    '/provider',
    '/navigator_demo',
    '/base_component',
    '/separator_page',
    '/homePage',
    '/key_page',
    '/bloc',
    '/animate',
    '/expanded',
    '/tab',
    '/animate_scale',
    '/transition_home_page',
    '/mindspace_home_page',
    '/canvas_page',
    '/practical_examples',
    '/native_test_page',
    '/native_use_flutter_page',
    '/pigeon_demo',
    '/hitest_page',
    '/zh_native_channel_demo',
    '/localization',
  ];

  const menuLabels = {
    '/localization': 'Flutter Localization',
    '/list_item_page': 'List Item Page',
    '/hitest_page': 'Hitest Page',
    '/dart_related': 'Dart 相关',
    '/provider': 'Provider 测试',
    '/navigator_demo': 'Navigator 2.0 示例',
    '/inherited_widget_index': 'InheritedWidget 数据共享',
    '/native_test_page': 'iOS 原生组件',
    '/zh_native_channel_demo': 'ZHNativeChannel Demo',
    '/pigeon_demo': 'Pigeon Demo',
    '/canvas_page': 'Canvas Page',
    '/practical_examples': 'Canvas 实用案例',
    '/mindspace_home_page': 'Mindspace Home',
    '/transition_home_page': 'Transition Home',
    '/base_component': 'Base Component',
    '/separator_page': 'Separator Page',
    '/key_page': 'Key Page',
    '/bloc': 'Bloc Demo',
    '/animate': 'Animate Page',
    '/expanded': 'Expanded View',
    '/tab': 'Tab Page',
    '/animate_scale': 'Animate Scale',
  };

  for (final path in paths) {
    testWidgets('opens $path from the study home and returns', (tester) async {
      final router = createRouter('/homePage');
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pump(const Duration(milliseconds: 400));

      if (path == '/homePage') {
        expect(find.text('Home'), findsOneWidget);
        await tester.pumpWidget(const SizedBox.shrink());
        router.dispose();
        return;
      }

      final menuLabel = menuLabels[path];
      if (menuLabel == null) {
        router.push<void>(path);
      } else {
        final item = find.text(menuLabel);
        await tester.scrollUntilVisible(
          item,
          400,
          scrollable: find.byType(Scrollable).first,
          continuous: true,
        );
        await tester.pumpAndSettle();
        await tester.ensureVisible(item);
        await tester.pumpAndSettle();
        await tester.tap(item);
      }
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(router.state.uri.path, path);
      expect(find.byType(ErrorWidget), findsNothing);

      router.pop();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(router.state.uri.path, '/homePage');
      expect(find.text('Home'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      router.dispose();
    });
  }
}
