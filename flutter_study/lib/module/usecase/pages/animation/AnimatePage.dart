import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/src/widgets/framework.dart";
import "package:flutter_study/module/usecase/pages/animation/AnimateSeconedPage.dart";
import "package:flutter_hooks/flutter_hooks.dart";

class AnimatePage extends HookWidget {
  AnimatePage();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("AnimatePage")),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                SlideUpPageRoute(
                  builder: (builder) {
                    return AnimateSeconedPage();
                  },
                  settings: const RouteSettings(name: "SlideUp"),
                ),
              );
            },
            child: Text("AnimatePage"),
          ),
        ],
      ),
    );
  }
}

class SlideUpPageRoute<T> extends MaterialPageRoute<T> {
  SlideUpPageRoute({required WidgetBuilder builder, RouteSettings? settings})
    : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.ease)).animate(animation),
      child: child,
    );
  }
}
