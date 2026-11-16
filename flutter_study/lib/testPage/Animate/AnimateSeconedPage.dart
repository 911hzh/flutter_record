// class AnimateSeconedPage {
//   AnimateSeconedPage();
// }f
import "package:flutter/material.dart";
import "package:flutter/src/widgets/framework.dart";
import "package:flutter_hooks/flutter_hooks.dart";

class DraggablePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final dragOffset = useState(0.0);
    final startOffset = useState(0.0);
    // Use animation controller for smooth progress
    final controller =
        useAnimationController(duration: const Duration(milliseconds: 300));

    final animation = useAnimation(AlwaysStoppedAnimation(dragOffset.value));
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, dragOffset.value),
          child: Scaffold(
            appBar: AppBar(
              title: Text('Draggable Page'),
            ),
            body: GestureDetector(
              onVerticalDragStart: (details) {
                startOffset.value = details.localPosition.dy;
                Navigator.of(context).didStartUserGesture();
              },
              onVerticalDragUpdate: (details) {
                // dragOffset.value = details.primaryDelta!;
                dragOffset.value = details.localPosition.dy - startOffset.value;
                print("-----value: ${dragOffset.value}");
                // Trigger animation to reflect drag progress
                // controller.value =
                //     dragOffset.value / MediaQuery.of(context).size.height;
              },
              onVerticalDragEnd: (details) {
                if (dragOffset.value > 100) {
                  Navigator.of(context)
                      .pop(); // Return to previous page if dragged sufficiently
                } else {
                  Navigator.of(context).didStopUserGesture();
                  // Reset offset if not dragged enough
                  dragOffset.value = 0;
                  controller.reverse();
                }
              },
              child: Center(
                child: Text('Drag down to go back'),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomPageRoute extends PageRouteBuilder {
  final Widget page;

  CustomPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Tween and Animation
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            // AnimatedBuilder(child: Container(), animation: animation);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        );
}

class AnimateSeconedPage extends HookWidget {
  AnimateSeconedPage();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("AnimateSeconedPage"),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text("back"),
        ),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, CustomPageRoute(page: DraggablePage()));
            },
            child: Text("AnimateSeconedPage"),
          ),
        ],
      ),
    );
  }
}
