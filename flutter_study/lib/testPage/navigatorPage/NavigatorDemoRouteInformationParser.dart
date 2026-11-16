import 'package:flutter/material.dart';
import 'package:flutter_study/testPage/navigatorPage/NavigatorDemoPage.dart';

class NavigatorDemoRouteInformationParser extends RouteInformationParser<NavigatorDemoRoutePath> {
  @override
  Future<NavigatorDemoRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = routeInformation.uri;
    if (uri.pathSegments.length == 2 && uri.pathSegments.first == 'product') {
      return NavigatorDemoRoutePath.detail(uri.pathSegments[1]);
    }
    return const NavigatorDemoRoutePath.home();
  }

  @override
  RouteInformation? restoreRouteInformation(NavigatorDemoRoutePath configuration) {
    if (configuration.isDetail) {
      return RouteInformation(uri: Uri(path: '/product/${configuration.productId}'));
    }
    return RouteInformation(uri: Uri(path: '/'));
  }
}
