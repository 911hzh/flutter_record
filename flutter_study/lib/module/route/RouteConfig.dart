import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:flutter_study/module/usecase/pages/riverprovider/RiverProviderPage.dart';
import 'package:flutter_study/module/usecase/pages/storage/StoragePage.dart';
import 'package:flutter_study/module/usecase/pages/isolate/IsolatePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_study/Properties.dart';
import 'package:flutter_study/module/usecase/pages/platform/flutter_use_native/IOSNativeComponentDemoPage.dart';
import 'package:flutter_study/module/usecase/pages/platform/native_use_flutter/NativeUseFlutterPage.dart';
import 'package:flutter_study/module/usecase/pages/animation/AnimatePage.dart';
import 'package:flutter_study/module/usecase/pages/repaintboundary/RepaintBoundaryPage.dart';
import 'package:flutter_study/module/usecase/pages/components/BaseComponentPage.dart';
import 'package:flutter_study/module/usecase/pages/transition/custom/HTPageJump/TransitionHomePage.dart';
import 'package:flutter_study/module/usecase/pages/layout/ExpandedPage.dart';
import 'package:flutter_study/module/usecase/pages/home/HomePage.dart';
import 'package:flutter_study/module/usecase/pages/bloc/BlocBuilderPage.dart';
import 'package:flutter_study/module/usecase/pages/widget_keys/KeyPage.dart';
import 'package:flutter_study/module/usecase/pages/list/ListItemPage.dart';
import 'package:flutter_study/module/usecase/pages/localization/LocalizationPage.dart';
import 'package:flutter_study/e_uikit/localization/LocalizationNotifier.dart';
import 'package:flutter_study/module/usecase/pages/platform/pigeon/PigeonDemoPage.dart';
import 'package:flutter_study/module/usecase/pages/separator/SeparatorPage.dart';
import 'package:flutter_study/module/usecase/pages/tabs/TabPage.dart';
import 'package:flutter_study/module/usecase/pages/transition/page/MindSpaceHomePagetest.dart';
import 'package:flutter_study/module/usecase/pages/canvas/CancasPage.dart';
import 'package:flutter_study/module/usecase/pages/canvas/PracticalExamplesPage.dart';
import 'package:flutter_study/module/usecase/pages/dart/DartRelatedPage.dart';
import 'package:flutter_study/module/usecase/pages/hit_test/HitestPage.dart';
import 'package:flutter_study/module/usecase/pages/inherited_widget/InheritedWidgetTestPage.dart';
import 'package:flutter_study/module/usecase/pages/navigation/NavigatorDemoPage.dart';
import 'package:flutter_study/module/usecase/pages/provider/ProviderTestPage.dart';
import 'package:flutter_study/module/usecase/pages/platform/native_channel/ZHNativeChannelDemoPage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// 使用全局变量缓存 GoRouter 实例，避免热重载时重新创建
GoRouter createRouter(String initialLocation) => GoRouter(
  // 开发时不设置 initialLocation，这样热重载会保持当前页面
  // 如果需要指定初始页面，可以取消下面的注释
  initialLocation: initialLocation,
  routes: [
    GoRoute(
      path: '/riverprovider',
      builder: (context, state) =>
          const riverpod.ProviderScope(child: RiverProviderPage()),
    ),
    GoRoute(path: '/storage', builder: (context, state) => const StoragePage()),
    GoRoute(path: '/isolate', builder: (context, state) => const IsolatePage()),
    GoRoute(
      path: "/list_item_page",
      builder: (context, state) {
        return ListItemPage();
      },
    ),
    GoRoute(
      path: "/dart_related",
      builder: (context, state) {
        return DartRelatedPage(title: 'Dart 相关');
      },
    ),
    GoRoute(
      path: "/inherited_widget_index",
      builder: (context, state) {
        return InheritedWidgetTestPage();
        // return const InheritedWidgetIndexPage();
      },
    ),
    GoRoute(
      path: "/provider",
      builder: (context, state) {
        return const ProviderTestPage();
      },
    ),
    GoRoute(
      path: "/navigator_demo",
      builder: (context, state) {
        return const NavigatorDemoPage();
      },
    ),
    GoRoute(
      path: "/base_component",
      builder: (context, state) {
        return BaseComponentPage();
      },
    ),
    GoRoute(
      path: "/separator_page",
      builder: (context, state) {
        return SeparatorPage();
      },
    ),
    GoRoute(
      path: "/homePage",
      builder: (context, state) {
        return HomePage();
      },
    ),
    GoRoute(
      path: "/key_page",
      builder: (context, state) {
        return KeyPage();
      },
    ),
    GoRoute(
      path: "/bloc",
      builder: (context, state) {
        return BlocBuilderPage();
      },
    ),
    GoRoute(
      path: "/animate",
      builder: (context, state) {
        return AnimatePage();
      },
    ),
    GoRoute(
      path: "/expanded",
      builder: (context, state) {
        return ExpandedPage();
      },
    ),
    GoRoute(
      path: "/tab",
      builder: (context, state) {
        return TabPage();
      },
    ),
    GoRoute(
      path: "/repaintboundary",
      builder: (context, state) {
        return RepaintBoundaryPage();
      },
    ),
    GoRoute(
      path: "/transition_home_page",
      builder: (context, state) {
        return TransitionHomePage();
      },
    ),
    GoRoute(
      path: "/mindspace_home_page",
      builder: (context, state) {
        // 测试入口页面，使用默认路由即可
        // 从这个页面点击按钮会使用 Navigator.push 跳转到真正的 MindSpaceHomePage
        return MindSpaceHomePagetest();
      },
    ),
    GoRoute(
      path: "/canvas_page",
      builder: (context, state) {
        return CanvasPage();
      },
    ),
    GoRoute(
      path: "/practical_examples",
      builder: (context, state) {
        return PracticalExamplesPage();
      },
    ),
    GoRoute(
      path: "/native_test_page",
      builder: (context, state) {
        return IOSNativeComponentDemoPage();
      },
    ),
    GoRoute(
      path: "/native_use_flutter_page",
      builder: (context, state) {
        return NativeUseFlutterPage();
      },
    ),
    GoRoute(
      path: "/pigeon_demo",
      builder: (context, state) {
        return const PigeonDemoPage();
      },
    ),
    GoRoute(
      path: "/hitest_page",
      builder: (context, state) {
        return HitestPage();
      },
    ),
    GoRoute(
      path: "/zh_native_channel_demo",
      builder: (context, state) {
        return const ZHNativeChannelDemoPage();
      },
    ),
    GoRoute(
      path: "/localization",
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => LocalizationNotifier(),
        child: const LocalizationPage(),
      ),
    ),
  ],
);

// 返回缓存的 router 实例，避免热重载时重新创建
final _router = createRouter(properties.initialRoute);

class RouteConfig {
  static GoRouter getRouter(String initialLocation) =>
      initialLocation == properties.initialRoute
      ? _router
      : createRouter(initialLocation);
}

GoRouter getRouter() {
  return _router;
}

class CacheExtraPage extends HookWidget {
  final Object? extraData;
  final Widget Function(BuildContext context, Object? extraData) builder;
  const CacheExtraPage({super.key, required this.builder, this.extraData});
  @override
  Widget build(BuildContext context) {
    final extraDataRef = useRef<Object?>(extraData);
    useEffect(() {
      if (extraDataRef.value == null && extraData != null) {
        extraDataRef.value = extraData;
      }
      return null;
    }, [extraData]);
    return builder.call(context, extraDataRef.value);
  }
}
