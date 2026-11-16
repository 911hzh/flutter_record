import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'LocalizationDynamicImpl.dart';
import 'LocalizationInstance.dart';

enum LocalizationStatus { loading, ready, failed }

class LocalizationNotifier extends ChangeNotifier {
  LocalizationNotifier() {
    _load();
  }

  Locale _locale = const Locale('zh');
  LocalizationStatus _status = LocalizationStatus.loading;
  LocalizationDynamicImpl? _translations;
  bool _disposed = false;

  Locale get locale => _locale;
  LocalizationStatus get status => _status;

  void setLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
  }

  String translate(String key) => _translations?.translate(key, _locale) ?? key;

  Future<void> _load() async {
    try {
      final catalog = await LocalizationInstance.load(
        loadRemote: () async => {},
      );
      if (_disposed) {
        catalog.dispose();
        return;
      }
      _translations = LocalizationDynamicImpl(catalog);
      _status = LocalizationStatus.ready;
    } catch (error) {
      if (_disposed) return;
      debugPrint('Could not load bundled translations: $error');
      _status = LocalizationStatus.failed;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _translations?.localizationInstance.dispose();
    super.dispose();
  }
}

extension LocalizationContext on BuildContext {
  String tr(String key) => watch<LocalizationNotifier>().translate(key);
}

class LocalizationBuilder extends StatelessWidget {
  const LocalizationBuilder({super.key, required this.builder});

  final Widget Function(LocalizationNotifier localization) builder;

  @override
  Widget build(BuildContext context) =>
      builder(context.watch<LocalizationNotifier>());
}
