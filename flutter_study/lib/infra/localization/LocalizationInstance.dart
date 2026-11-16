import 'dart:convert';
import 'dart:ui' show Locale;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Maps each locale to its messages by key.
typedef LocalizedMessages = Map<Locale, Map<String, String>>;

/// Loads bundled JSON and overlays an optional remote catalog in memory.
class LocalizationInstance extends ChangeNotifier {
  LocalizationInstance._(this._local, this._loadRemote);

  static const _english = Locale('en');
  static const _locales = [_english, Locale('zh')];

  /// Loads the offline catalog before the first frame can request translations.
  static Future<LocalizationInstance> load({
    required Future<LocalizedMessages> Function() loadRemote,
    AssetBundle? bundle,
  }) async {
    final assets = bundle ?? rootBundle;
    final local = await Future.wait(
      _locales.map((locale) async {
        final json = await assets.loadString(
          'lib/assets/localization/${locale.toLanguageTag()}.json',
        );
        return MapEntry(
          locale,
          Map<String, String>.from(jsonDecode(json) as Map),
        );
      }),
    );
    return LocalizationInstance._(Map.fromEntries(local), loadRemote);
  }

  final LocalizedMessages _local;
  final Future<LocalizedMessages> Function() _loadRemote;
  LocalizedMessages _remote = const {};
  bool _refreshing = false;
  bool _disposed = false;

  List<Locale> get supportedLocales => _locales;

  String? lookup(String key, Locale locale) =>
      _remote[locale]?[key] ?? _local[locale]?[key] ?? _local[_english]?[key];

  /// Replaces the remote snapshot and refreshes dependent widgets.
  /// A failed refresh reverts to the bundled catalog.
  Future<void> refresh() async {
    if (_refreshing || _disposed) return;
    _refreshing = true;
    try {
      final remote = await _loadRemote();
      if (_disposed) return;
      _remote = remote;
      notifyListeners();
    } catch (error) {
      if (!_disposed && _remote.isNotEmpty) {
        _remote = const {};
        notifyListeners();
      }
      debugPrint('Could not load remote translations: $error');
    } finally {
      _refreshing = false;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
