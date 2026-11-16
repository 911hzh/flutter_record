import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_study/testPage/localizaition/LocalizationPage.dart';
import 'package:flutter_study/testPage/localizaition/LocalizationNotifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  const chineseAsset = 'lib/assets/localization/zh.json';
  const englishAsset = 'lib/assets/localization/en.json';

  void mockCatalogs(Future<ByteData?> Function(String path) load) {
    rootBundle.evict(chineseAsset);
    rootBundle.evict(englishAsset);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (message) async {
          final path = const StringCodec().decodeMessage(message)!;
          if (path != chineseAsset && path != englishAsset) return null;
          return load(path);
        });
  }

  Widget page() => MaterialApp(
    home: ChangeNotifierProvider(
      create: (_) => LocalizationNotifier(),
      child: const LocalizationPage(),
    ),
  );

  testWidgets('switches the whole page without reloading the JSON', (
    tester,
  ) async {
    final requests = <String>[];
    mockCatalogs((path) async {
      requests.add(path);
      final chinese = path == chineseAsset;
      return const StringCodec().encodeMessage(
        jsonEncode({
          'localization.title': chinese ? '国际化页面' : 'Localization Page',
          'localization.language': chinese ? '语言' : 'Language',
          'localization.chinese': chinese ? '简体中文' : 'Simplified Chinese',
          'localization.english': chinese ? '英语' : 'English',
          'localization.builder': chinese ? 'Builder 取词' : 'Builder lookup',
          'localization.contextTr': chinese
              ? 'context.tr() 取词'
              : 'context.tr() lookup',
          'localization.greeting': chinese ? '你好' : 'Hello',
        }),
      );
    });

    await tester.pumpWidget(page());
    await tester.pumpAndSettle();
    expect(find.text('国际化页面'), findsOneWidget);
    expect(find.text('ARB 编译方案'), findsOneWidget);
    expect(find.text('你好，欢迎使用国际化示例！'), findsOneWidget);
    expect(find.text('Builder 取词'), findsOneWidget);
    expect(find.text('context.tr() 取词'), findsOneWidget);
    expect(find.text('你好'), findsNWidgets(2));

    await tester.tap(find.text('英语'));
    await tester.pumpAndSettle();
    expect(find.text('Localization Page'), findsOneWidget);
    expect(find.text('Compiled ARB'), findsOneWidget);
    expect(
      find.text('Hello, welcome to the localization demo!'),
      findsOneWidget,
    );
    expect(find.text('Builder lookup'), findsOneWidget);
    expect(find.text('context.tr() lookup'), findsOneWidget);
    expect(find.text('Hello'), findsNWidgets(2));

    await tester.tap(find.text('Simplified Chinese'));
    await tester.pumpAndSettle();
    expect(find.text('国际化页面'), findsOneWidget);
    expect(find.text('你好'), findsNWidgets(2));
    expect(requests, unorderedEquals([chineseAsset, englishAsset]));
  });

  testWidgets('shows an error when a bundled catalog cannot load', (
    tester,
  ) async {
    mockCatalogs((_) async => null);
    await tester.pumpWidget(page());
    await tester.pumpAndSettle();
    expect(find.text('无法加载本地 JSON 译文'), findsOneWidget);
    expect(find.text('ARB 编译方案'), findsOneWidget);

    await tester.tap(find.text('英语'));
    await tester.pumpAndSettle();
    expect(find.text('Compiled ARB'), findsOneWidget);
    expect(
      find.text('Could not load local JSON translations.'),
      findsOneWidget,
    );
  });

  testWidgets('can leave the page while catalogs are loading', (tester) async {
    final response = Completer<ByteData?>();
    mockCatalogs((_) => response.future);
    await tester.pumpWidget(page());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    response.complete(const StringCodec().encodeMessage('{}'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
