import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";

class DraggablePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final dragOffset = useState(0.0);
    return Transform.translate(
      offset: Offset(0, dragOffset.value),
      child: Scaffold(
        appBar: AppBar(title: const Text('下拉返回')),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onVerticalDragUpdate: (details) {
            dragOffset.value = (dragOffset.value + details.delta.dy).clamp(
              0.0,
              double.infinity,
            );
          },
          onVerticalDragEnd: (details) {
            if (dragOffset.value > 100) {
              Navigator.of(context).pop();
            } else {
              dragOffset.value = 0;
            }
          },
          onVerticalDragCancel: () => dragOffset.value = 0,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.swipe_down,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 20),
                Text(
                  '向下拖动页面',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                const Text('超过 100 个逻辑像素后松手，即可返回。'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomPageRoute extends PageRouteBuilder {
  final Widget page;

  CustomPageRoute({required this.page})
    : super(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Tween and Animation
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          // AnimatedBuilder(child: Container(), animation: animation);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      );
}

class AnimateSeconedPage extends StatelessWidget {
  const AnimateSeconedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('转场已完成')),
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
                    Icon(
                      Icons.swipe_down,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Text(
                      '试试手势返回',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const Text('打开下一页后，向下拖动内容区域，观察页面跟随手指移动。'),
                    FilledButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          CustomPageRoute(page: DraggablePage()),
                        );
                      },
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('打开下拉返回页'),
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
