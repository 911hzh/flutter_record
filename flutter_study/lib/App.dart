import 'package:flutter_study/module/route/GlobalNavigatorKey.dart';
import 'package:flutter_study/module/route/RouteConfig.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  final String initialRoute;
  const App({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: RouteConfig.getRouter(initialRoute),
      key: globalNavigatorKey,
      title: 'Flutter Demo',
      checkerboardOffscreenLayers: true,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}
