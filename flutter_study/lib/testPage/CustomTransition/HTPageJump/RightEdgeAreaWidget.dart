import 'package:flutter_study/testPage/CustomTransition/CustomPageRoute/CustomFadeRouteWithGesture.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RightEdgeAreaWidget extends StatefulWidget {
  final ModalRoute Function(BuildContext context) createPage;
  const RightEdgeAreaWidget({super.key, required this.createPage});
  @override
  State<StatefulWidget> createState() {
    return _RightEdgeAreaWidgetState();
  }
}

class _RightEdgeAreaWidgetState extends State<RightEdgeAreaWidget> {
  AnimationController? pushPageController;
  bool isDragging = false;
  final width = 30.0;
  // double _startDragX = 0.0;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (details) {
        isDragging = true;
        final page = widget.createPage(context);
        Navigator.of(context).push(page);
        pushPageController = page.controller;
        pushPageController?.value = 0.001;
      },
      onPointerMove: (details) {
        if (isDragging) {
          final screenWidth = MediaQuery.of(context).size.width;
          final dragDistance = screenWidth - details.position.dx;
          // print('--- isDragging: $isDragging, value: ${details.position.dx}');
          final progress = dragDistance / (screenWidth - 100);
          // pushPageController?.value = progress.clamp(0.0, 1.0);
          // pushPage?.setProgress(progress);
          pushPageController?.value = progress;
        }
      },
      onPointerUp: (details) {
        // print('--- dragend: ${details.position.dx}}');
        if (isDragging) {
          isDragging = false;
          final screenWidth = MediaQuery.of(context).size.width;
          final dragDistance = screenWidth - details.position.dx;
          final progress = dragDistance / (screenWidth - 100);

          if (progress > 0.5) {
            // pushPage?.setProgress(1.0);
            pushPageController?.value = progress;
            pushPageController?.animateTo(
              1.0,
              duration:
                  const Duration(milliseconds: CustomFadeRouteWithGesture.defaultTransactionAnimationDuration) *
                  (1 - progress),
              curve: Curves.easeInOut,
            );
          } else {
            Navigator.of(context).pop();
          }
        }
      },
      behavior: HitTestBehavior.translucent,
      child: Container(width: width, height: double.infinity, color: Colors.blue.withOpacity(0.5)),
    );
  }
}
