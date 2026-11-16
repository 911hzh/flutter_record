import 'package:flutter/material.dart';
import 'package:flutter_study/testPage/navigatorPage/InfoCard.dart';
import 'package:flutter_study/testPage/navigatorPage/NavigatorDemoRouteInformationParser.dart';
import 'package:flutter_study/testPage/navigatorPage/NavigatorDemoRouterDelegate.dart';

class NavigatorDemoPage extends StatefulWidget {
  const NavigatorDemoPage({super.key});

  @override
  State<NavigatorDemoPage> createState() => _NavigatorDemoPageState();
}

class _NavigatorDemoPageState extends State<NavigatorDemoPage> {
  late final NavigatorDemoRouterDelegate _routerDelegate;
  late final NavigatorDemoRouteInformationParser _routeInformationParser;

  @override
  void initState() {
    super.initState();
    _routerDelegate = NavigatorDemoRouterDelegate();
    _routeInformationParser = NavigatorDemoRouteInformationParser();
  }

  @override
  void dispose() {
    _routerDelegate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigator 2.0 示例')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const InfoCard(
            title: '这个示例演示什么？',
            content:
                'Navigator 2.0 使用 RouterDelegate 通过状态生成 pages 列表。'
                '点击商品时不会直接 push，而是修改 selectedProductId，'
                '然后由 Navigator 根据新的 pages 声明式地展示详情页。',
          ),
          const SizedBox(height: 12),
          const InfoCard(
            title: '核心对象',
            content:
                'RouteInformationParser 负责把路径解析成配置；'
                'RouterDelegate 保存当前导航状态，并把状态还原成 Navigator.pages；'
                '系统返回和手势返回会通过 Navigator 移除页面，再同步回业务状态。',
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 520,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepPurple.withValues(alpha: 0.2)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Router<NavigatorDemoRoutePath>(
                  routerDelegate: _routerDelegate,
                  routeInformationParser: _routeInformationParser,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NavigatorDemoRoutePath {
  final String? productId;

  const NavigatorDemoRoutePath.home() : productId = null;

  const NavigatorDemoRoutePath.detail(this.productId);

  bool get isDetail => productId != null;
}
