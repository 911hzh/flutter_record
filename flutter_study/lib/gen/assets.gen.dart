// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $LibGen {
  const $LibGen();

  /// Directory path: lib/assets
  $LibAssetsGen get assets => const $LibAssetsGen();

  /// Directory path: lib/base
  $LibBaseGen get base => const $LibBaseGen();
}

class $LibAssetsGen {
  const $LibAssetsGen();

  /// File path: lib/assets/focusItem_defaultIcon.png
  AssetGenImage get focusItemDefaultIcon =>
      const AssetGenImage('lib/assets/focusItem_defaultIcon.png');

  /// File path: lib/assets/focus_item_folder.png
  AssetGenImage get focusItemFolder =>
      const AssetGenImage('lib/assets/focus_item_folder.png');

  /// File path: lib/assets/focus_item_sub_folder.png
  AssetGenImage get focusItemSubFolder =>
      const AssetGenImage('lib/assets/focus_item_sub_folder.png');

  /// Directory path: lib/assets/localization
  $LibAssetsLocalizationGen get localization =>
      const $LibAssetsLocalizationGen();

  /// File path: lib/assets/mindspace_bg.png
  AssetGenImage get mindspaceBg =>
      const AssetGenImage('lib/assets/mindspace_bg.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    focusItemDefaultIcon,
    focusItemFolder,
    focusItemSubFolder,
    mindspaceBg,
  ];
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

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
