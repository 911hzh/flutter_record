import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class HomePage extends HookWidget {
  HomePage();

  // 根据页面名称返回相应的图标
  IconData _getIconForPage(String name) {
    if (name.toLowerCase().contains('list_item')) {
      return Icons.list;
    } else if (name.toLowerCase().contains('hitest')) {
      return Icons.touch_app;
    }
    if (name.toLowerCase().contains('provider')) {
      return Icons.share;
    } else if (name.toLowerCase().contains('inherited')) {
      return Icons.widgets_outlined;
    } else if (name.toLowerCase().contains('navigator')) {
      return Icons.route_outlined;
    } else if (name.toLowerCase().contains('mindspace')) {
      return Icons.spa_outlined;
    } else if (name.toLowerCase().contains('canvas') &&
        name.toLowerCase().contains('实用')) {
      return Icons.pie_chart_outline;
    } else if (name.toLowerCase().contains('canvas')) {
      return Icons.brush_outlined;
    } else if (name.toLowerCase().contains('transition')) {
      return Icons.animation;
    } else if (name.toLowerCase().contains('component')) {
      return Icons.widgets_outlined;
    } else if (name.toLowerCase().contains('separator')) {
      return Icons.horizontal_split;
    } else if (name.toLowerCase().contains('key')) {
      return Icons.key;
    } else if (name.toLowerCase().contains('bloc')) {
      return Icons.account_tree_outlined;
    } else if (name.toLowerCase().contains('svg')) {
      return Icons.image_outlined;
    } else if (name.toLowerCase().contains('animate')) {
      return Icons.motion_photos_on_outlined;
    } else if (name.toLowerCase().contains('expanded')) {
      return Icons.open_in_full;
    } else if (name.toLowerCase().contains('tab')) {
      return Icons.tab;
    } else if (name.toLowerCase().contains('dart')) {
      return Icons.code;
    } else if (name.toLowerCase().contains('pigeon')) {
      return Icons.hub_outlined;
    } else if (name.toLowerCase().contains('localization')) {
      return Icons.language_outlined;
    } else {
      return Icons.apps;
    }
  }

  // 根据索引返回渐变色
  List<Color> _getGradientColors(int index) {
    final gradients = [
      [const Color(0xFF667eea), const Color(0xFF764ba2)],
      [const Color(0xFFf093fb), const Color(0xFFf5576c)],
      [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
      [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
      [const Color(0xFFfa709a), const Color(0xFFfee140)],
      [const Color(0xFF30cfd0), const Color(0xFF330867)],
      [const Color(0xFFa8edea), const Color(0xFFfed6e3)],
      [const Color(0xFFff9a9e), const Color(0xFFfecfef)],
    ];
    return gradients[index % gradients.length];
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<List<Map<String, String>>> datas = useState([
      {"name": "Flutter Localization", "path": "/localization"},
      {"name": "List Item Page", "path": "/list_item_page"},
      {"name": "Hitest Page", "path": "/hitest_page"},
      {"name": "Dart 相关", "path": "/dart_related"},
      {"name": "Provider 测试", "path": "/provider"},
      {"name": "Navigator 2.0 示例", "path": "/navigator_demo"},
      {"name": "InheritedWidget 数据共享", "path": "/inherited_widget_index"},
      {"name": "主题共享示例", "path": "/theme_share_example"},
      {"name": "iOS 原生组件", "path": "/native_test_page"},
      {"name": "ZHNativeChannel Demo", "path": "/zh_native_channel_demo"},
      {"name": "Pigeon Demo", "path": "/pigeon_demo"},
      {"name": "Canvas Page", "path": "/canvas_page"},
      {"name": "Canvas 实用案例", "path": "/practical_examples"},
      {"name": "Mindspace Home", "path": "/mindspace_home_page"},
      {"name": "Transition Home", "path": "/transition_home_page"},
      {"name": "Base Component", "path": "/base_component"},
      {"name": "Separator Page", "path": "/separator_page"},
      {"name": "Key Page", "path": "/key_page"},
      {"name": "Bloc Demo", "path": "/bloc"},
      {"name": "SVG Page", "path": "/svg_page"},
      {"name": "Animate Page", "path": "/animate"},
      {"name": "Expanded View", "path": "/expanded"},
      {"name": "Tab Page", "path": "/tab"},
      {"name": "Animate Scale", "path": "/animate_scale"},
    ]);

    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFFf5f7fa), const Color(0xFFc3cfe2)],
          ),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          shrinkWrap: false,
          separatorBuilder: (_, index) {
            return const SizedBox(height: 12);
          },
          itemCount: datas.value.length,
          itemBuilder: (_, index) {
            final item = datas.value[index];
            final gradientColors = _getGradientColors(index);

            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 300 + (index * 50)),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    print("item: ${item["path"]}");
                    context.push(item["path"]!);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradientColors,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: gradientColors[0].withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getIconForPage(item["name"]!),
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              item["name"]!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.none,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
