import "package:flutter/material.dart";
import "package:flutter_study/module/usecase/pages/animation/AnimateSeconedPage.dart";

class AnimatePage extends StatelessWidget {
  const AnimatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('动画与页面转场')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card.filled(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: theme.colorScheme.primaryContainer,
                      foregroundColor: theme.colorScheme.onPrimaryContainer,
                      child: const Icon(Icons.vertical_align_top, size: 28),
                    ),
                    Text('从底部进入', style: theme.textTheme.headlineSmall),
                    const Text('点击按钮，观察下一页从屏幕底部滑入。返回时沿原路退出。'),
                    FilledButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          SlideUpPageRoute(
                            builder: (_) => AnimateSeconedPage(),
                            settings: const RouteSettings(name: 'SlideUp'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_upward),
                      label: const Text('体验向上转场'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
