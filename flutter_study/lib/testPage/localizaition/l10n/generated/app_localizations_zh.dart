// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get localizationTitle => '国际化页面';

  @override
  String get localizationGreeting => '你好，欢迎使用国际化示例！';

  @override
  String get localizationLanguage => '语言';

  @override
  String get localizationChinese => '简体中文';

  @override
  String get localizationEnglish => '英语';

  @override
  String get localizationArb => 'ARB 编译方案';

  @override
  String get localizationJson => '本地 JSON 方案';

  @override
  String get localizationLoading => '正在加载本地 JSON 译文…';

  @override
  String get localizationLoadError => '无法加载本地 JSON 译文';
}
