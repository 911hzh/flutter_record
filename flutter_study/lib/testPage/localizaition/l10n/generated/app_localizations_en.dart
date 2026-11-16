// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get localizationTitle => 'Localization Page';

  @override
  String get localizationGreeting => 'Hello, welcome to the localization demo!';

  @override
  String get localizationLanguage => 'Language';

  @override
  String get localizationChinese => 'Simplified Chinese';

  @override
  String get localizationEnglish => 'English';

  @override
  String get localizationArb => 'Compiled ARB';

  @override
  String get localizationJson => 'Bundled JSON';

  @override
  String get localizationLoading => 'Loading local JSON translations…';

  @override
  String get localizationLoadError => 'Could not load local JSON translations.';
}
