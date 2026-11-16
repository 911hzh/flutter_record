import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_study/e_uikit/localization/LocalizationNotifier.dart';
import 'package:flutter_study/l10n/generated/app_localizations.dart';

class LocalizationPage extends StatelessWidget {
  const LocalizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = context.watch<LocalizationNotifier>();

    // 让 ARB 译文和 Material 内置文案都使用页面所选语言。
    return Localizations.override(
      context: context,
      locale: scope.locale,
      delegates: AppLocalizations.localizationsDelegates,
      child: Builder(builder: (context) => _buildPage(context, scope)),
    );
  }

  Widget _buildPage(BuildContext context, LocalizationNotifier scope) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.localizationTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 两种本地化方案共用同一个语言选择。
          Text(
            AppLocalizations.of(context)!.localizationLanguage,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: SegmentedButton<Locale>(
              segments: [
                ButtonSegment(
                  value: const Locale('zh'),
                  label: Text(
                    AppLocalizations.of(context)!.localizationChinese,
                  ),
                ),
                ButtonSegment(
                  value: const Locale('en'),
                  label: Text(
                    AppLocalizations.of(context)!.localizationEnglish,
                  ),
                ),
              ],
              selected: {scope.locale},
              onSelectionChanged: (selection) =>
                  scope.setLocale(selection.single),
            ),
          ),
          const SizedBox(height: 16),
          // gen-l10n 从 ARB 生成的 Dart 属性读取译文。
          Text('gen-l10n', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: Text(AppLocalizations.of(context)!.localizationArb),
              subtitle: Text(
                AppLocalizations.of(context)!.localizationGreeting,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // JSON 加载完成后，分别演示两种取词方式。
          Text(
            AppLocalizations.of(context)!.localizationJson,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (scope.status == LocalizationStatus.loading)
            Center(
              child: CircularProgressIndicator(
                semanticsLabel: AppLocalizations.of(
                  context,
                )!.localizationLoading,
              ),
            ),
          if (scope.status == LocalizationStatus.failed)
            Text(AppLocalizations.of(context)!.localizationLoadError),
          if (scope.status == LocalizationStatus.ready) ...[
            // 通过 context.tr() 订阅语言变化并取词。
            Card(
              child: ListTile(
                title: Text(context.tr('localization.contextTr')),
                subtitle: Text(context.tr('localization.greeting')),
              ),
            ),
            const SizedBox(height: 8),
            // 通过 LocalizationBuilder 拿到翻译对象，再直接取词。
            LocalizationBuilder(
              builder: (localization) => Card(
                child: ListTile(
                  title: Text(localization.translate('localization.builder')),
                  subtitle: Text(
                    localization.translate('localization.greeting'),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
