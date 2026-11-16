import 'dart:ui' show Locale;

abstract interface class LocalizationProtocol {
  String translate(String key, Locale locale);
}
