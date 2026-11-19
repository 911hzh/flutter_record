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
    '/riverprovider',
    '/storage',
    '/navigator_demo',
    '/base_component',
    '/separator_page',
    '/homePage',
    '/key_page',
    '/bloc',
    '/isolate',
    '/animate',
    '/expanded',
    '/tab',
    '/repaintboundary',
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
    '/dart_related': 'Dart Basics',
    '/provider': 'Provider Demo',
    '/riverprovider': 'Riverpod Basics',
    '/storage': 'Local Storage',
    '/navigator_demo': 'Navigator 2.0 Demo',
    '/inherited_widget_index': 'InheritedWidget Demo',
    '/native_test_page': 'iOS Native Components',
    '/zh_native_channel_demo': 'ZHNativeChannel Demo',
    '/pigeon_demo': 'Pigeon Demo',
    '/canvas_page': 'Canvas Page',
    '/practical_examples': 'Canvas Examples',
    '/mindspace_home_page': 'Mindspace Home',
    '/transition_home_page': 'Transition Home',
    '/base_component': 'Base Component',
    '/separator_page': 'Separator Page',
    '/key_page': 'Key Page',
    '/bloc': 'Bloc Demo',
    '/isolate': 'Isolate Demo',
    '/animate': 'Animation & Transitions',
    '/expanded': 'Expanded View',
    '/tab': 'Tab Page',
    '/repaintboundary': 'RepaintBoundary Demo',
  };

  for (final path in paths) {
    testWidgets('opens $path from the study home and returns', (tester) async {
      if (path == '/expanded') {
        await tester.binding.setSurfaceSize(const Size(400, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));
      }
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
      if (path == '/expanded') {
        expect(
          tester.takeException(),
          isA<FlutterError>().having(
            (error) => error.toString(),
            'message',
            contains('A RenderFlex overflowed'),
          ),
        );
      }
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
