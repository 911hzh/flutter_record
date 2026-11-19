import "dart:ui";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";

class FocusItemView extends HookWidget {
  // final MindSpaceFocus focus;
  final bool showDefaultIcon;
  final bool showBoarderAnimation;

  const FocusItemView({
    // required this.focus,
    this.showDefaultIcon = true,
    this.showBoarderAnimation = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final defaultIcon = const Icon(Icons.spa_outlined);

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0x4DFFFFFF),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0x26FFFFFF), width: 1),
            boxShadow: [const BoxShadow(offset: Offset(0, 8), blurRadius: 24, color: Color(0x0D000000))],
          ),
          child: Stack(
            children: [
              // 左上角标题
              Positioned(
                left: 16,
                top: 16,
                right: 60,
                child: Text(
                  "test 111 who are you ",
                  style: TextStyle(color: Colors.black),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // 右上角图标
              Positioned(
                right: 13,
                top: 11,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(color: const Color(0x0D12192B), borderRadius: BorderRadius.circular(17)),
                  child: Container(
                    alignment: Alignment.center,
                    width: 25,
                    height: 25,
                    child: showDefaultIcon ? defaultIcon : Text("test 222"),
                  ), //SingleImageElementViewV2(imageUrl: focus.icon, width: 25, height: 25, borderRadius: 12.5),
                ),
              ),
              // 底部装饰
              Positioned(
                left: 7,
                right: 7,
                bottom: -13,
                child: Container(
                  height: 26,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFD9D9D9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),

              // 以下是 hasChildren 为 true 时的代码，暂时注释
              // if (hasChildren) ...[
              //   Positioned(
              //     left: 40,
              //     right: 40,
              //     top: 92,
              //     child: Text(
              //       "test 333",
              //       maxLines: 1,
              //       overflow: TextOverflow.ellipsis,
              //       style: const TextStyle(
              //         color: const Color(0xFF1F1F20),
              //         fontSize: 8,
              //         fontWeight: FontWeight.w500,
              //         height: 1.50,
              //       ),
              //     ),
              //   ),
              //   Positioned(
              //     left: 40,
              //     right: 40,
              //     top: 104,
              //     child: Text(
              //       "test 444",
              //       maxLines: 1,
              //       overflow: TextOverflow.ellipsis,
              //       style: const TextStyle(
              //         color: const Color(0xFF757781),
              //         fontSize: 8,
              //         fontWeight: FontWeight.w400,
              //         height: 1,
              //         letterSpacing: 0.08,
              //       ),
              //     ),
              //   ),
              // ],
            ],
          ),
        ),
      ),
    );
  }
}
