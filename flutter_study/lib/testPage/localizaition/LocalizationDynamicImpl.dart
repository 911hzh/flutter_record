import 'package:flutter/widgets.dart';

import 'LocalizationInstance.dart';
import 'LocalizationProtocol.dart';

/// Adapts the JSON catalog to the app's localization port.
class LocalizationDynamicImpl implements LocalizationProtocol, Listenable {
  const LocalizationDynamicImpl(this.localizationInstance);

  final LocalizationInstance localizationInstance;

  List<Locale> get supportedLocales => localizationInstance.supportedLocales;

  @override
  String translate(String key, Locale locale) {
    final resolved = basicLocaleListResolution([locale], supportedLocales);
    return localizationInstance.lookup(key, resolved) ?? key;
  }

  @override
  void addListener(VoidCallback listener) =>
      localizationInstance.addListener(listener);

  @override
  void removeListener(VoidCallback listener) =>
      localizationInstance.removeListener(listener);
}
