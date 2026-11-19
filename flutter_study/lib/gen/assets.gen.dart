// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

class $LibGen {
  const $LibGen();

  /// Directory path: lib/assets
  $LibAssetsGen get assets => const $LibAssetsGen();

  /// Directory path: lib/base
  $LibBaseGen get base => const $LibBaseGen();
}

class $LibAssetsGen {
  const $LibAssetsGen();

  /// Directory path: lib/assets/localization
  $LibAssetsLocalizationGen get localization =>
      const $LibAssetsLocalizationGen();
}

class $LibBaseGen {
  const $LibBaseGen();

  /// Directory path: lib/base/store
  $LibBaseStoreGen get store => const $LibBaseStoreGen();
}

class $LibAssetsLocalizationGen {
  const $LibAssetsLocalizationGen();

  /// File path: lib/assets/localization/en.json
  String get en => 'lib/assets/localization/en.json';

  /// File path: lib/assets/localization/zh.json
  String get zh => 'lib/assets/localization/zh.json';

  /// List of all assets
  List<String> get values => [en, zh];
}

class $LibBaseStoreGen {
  const $LibBaseStoreGen();

  /// Directory path: lib/base/store/settings
  $LibBaseStoreSettingsGen get settings => const $LibBaseStoreSettingsGen();
}

class $LibBaseStoreSettingsGen {
  const $LibBaseStoreSettingsGen();

  /// File path: lib/base/store/settings/development.json
  String get development => 'lib/base/store/settings/development.json';

  /// File path: lib/base/store/settings/release.json
  String get release => 'lib/base/store/settings/release.json';

  /// List of all assets
  List<String> get values => [development, release];
}

class Assets {
  const Assets._();

  static const $LibGen lib = $LibGen();
}
