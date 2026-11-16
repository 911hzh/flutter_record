import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/flex.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AnimateScalePage extends HookWidget {
  AnimateScalePage();

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );
    final animation = Tween<double>(begin: 1, end: 0.2).animate(controller);
    final data = useState(0);
    return Scaffold(
      appBar: AppBar(title: Text("AnimateScalePage")),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            GestureDetector(
              onTap: () {
                if (controller.isCompleted) {
                  controller.reverse();
                } else {
                  controller.forward();
                }
                // data.value += 1;
              },
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  color: Colors.blue,
                  child: Text("AnimateScalePage"),
                ),
              ),
            ),
            RepaintBoundary(
              child: ColumnT(children: [Text("AnimateScalePage")]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      return Container(
                        width: 200 * animation.value,
                        height: 200 * animation.value,
                        color: Colors.red,
                        child: Center(child: Text("AnimateScalePage")),
                      );
                    },
                    child: FadeTransition(
                      opacity: animation,
                      child: Container(
                        width: 200,
                        height: 200,
                        color: Colors.red,
                        child: Center(child: Text("AnimateScalePage")),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ColumnT extends Column {
  ColumnT({
    super.key,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.textBaseline,
    super.spacing,
    super.children,
  });
  @override
  RenderFlex createRenderObject(BuildContext context) {
    // TODO: implement createRenderObject
    return RenderFlexT(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: getEffectiveTextDirection(context),
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      clipBehavior: clipBehavior,
      spacing: spacing,
    );
  }
}

class RenderFlexT extends RenderFlex {
  RenderFlexT({
    super.direction,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.textBaseline,
    super.clipBehavior,
    super.spacing,
  });

  @override
  void paint(PaintingContext context, Offset offset) {
    // TODO: implement paint
    super.paint(context, offset);
    print("RenderFlexT RenderFlexT paint");
  }
}
