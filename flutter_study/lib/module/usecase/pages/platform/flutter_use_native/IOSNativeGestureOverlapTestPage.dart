import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class IOSNativeGestureOverlapTestPage extends StatefulWidget {
  const IOSNativeGestureOverlapTestPage({super.key});

  @override
  State<IOSNativeGestureOverlapTestPage> createState() => _IOSNativeGestureOverlapTestPageState();
}

class _IOSNativeGestureOverlapTestPageState extends State<IOSNativeGestureOverlapTestPage> {
  final List<String> _logs = <String>[];
  MethodChannel? _nativeChannel;
  bool _nativeEagerGesture = false;
  PlatformViewHitTestBehavior _hitTestBehavior = PlatformViewHitTestBehavior.opaque;

  @override
  void dispose() {
    _nativeChannel?.setMethodCallHandler(null);
    super.dispose();
  }

  void _appendLog(String message) {
    setState(() {
      _logs.insert(0, "${TimeOfDay.now().format(context)}  $message");
      if (_logs.length > 30) {
        _logs.removeRange(30, _logs.length);
      }
    });
  }

  Future<void> _attachNativeChannel(int viewId) async {
    _nativeChannel?.setMethodCallHandler(null);
    final MethodChannel channel = MethodChannel("native_gesture_overlap_view_$viewId");

    channel.setMethodCallHandler((MethodCall call) async {
      if (call.method != "onNativeGesture") {
        return;
      }

      final Map<Object?, Object?> payload = (call.arguments as Map<Object?, Object?>?) ?? const <Object?, Object?>{};
      final String type = (payload["type"] ?? "unknown").toString();
      final String state = (payload["state"] ?? "unknown").toString();
      final Object? x = payload["x"];
      final Object? y = payload["y"];
      _appendLog("NativeView -> $type/$state @ ($x, $y)");
    });

    _nativeChannel = channel;
    _appendLog("NativeView created, viewId=$viewId");
  }

  Set<Factory<OneSequenceGestureRecognizer>> _nativeGestureRecognizers() {
    if (!_nativeEagerGesture) {
      return <Factory<OneSequenceGestureRecognizer>>{};
    }

    return <Factory<OneSequenceGestureRecognizer>>{
      Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
    };
  }

  Widget _buildFlutterBackgroundLayer() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _appendLog("Flutter 背景层 -> tapDown"),
      onTap: () => _appendLog("Flutter 背景层 -> tap"),
      onPanStart: (_) => _appendLog("Flutter 背景层 -> panStart"),
      onPanUpdate:
          (details) => _appendLog(
            "Flutter 背景层 -> panUpdate dx=${details.delta.dx.toStringAsFixed(1)}, "
            "dy=${details.delta.dy.toStringAsFixed(1)}",
          ),
      onPanEnd: (_) => _appendLog("Flutter 背景层 -> panEnd"),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.orange.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.orange.shade400, width: 2),
        ),
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 12),
        child: const Text(
          "Flutter 背景层\n点击空白区域或从原生块上开始拖动试试",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildNativeView() {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blue.shade900, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: UiKitView(
          viewType: "native_test_view",
          layoutDirection: TextDirection.ltr,
          hitTestBehavior: _hitTestBehavior,
          creationParams: const <String, dynamic>{"title": "NativeView", "mode": "gesture_overlap_test"},
          creationParamsCodec: const StandardMessageCodec(),
          gestureRecognizers: _nativeGestureRecognizers(),
          onPlatformViewCreated: _attachNativeChannel,
        ),
      ),
    );
  }

  Widget _buildFlutterOverlayLayer() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _appendLog("Flutter 覆盖层 -> tapDown"),
      onTap: () => _appendLog("Flutter 覆盖层 -> tap"),
      onPanStart: (_) => _appendLog("Flutter 覆盖层 -> panStart"),
      onPanUpdate:
          (details) => _appendLog(
            "Flutter 覆盖层 -> panUpdate dx=${details.delta.dx.toStringAsFixed(1)}, "
            "dy=${details.delta.dy.toStringAsFixed(1)}",
          ),
      onPanEnd: (_) => _appendLog("Flutter 覆盖层 -> panEnd"),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.purple.withValues(alpha: 0.60),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.purple.shade900, width: 2),
        ),
        padding: const EdgeInsets.all(12),
        child: const Center(
          child: Text(
            "Flutter 覆盖层\n和 NativeView\n有重叠区域",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }

  Widget _buildControlPanel() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("NativeView 使用 EagerGestureRecognizer"),
              subtitle: const Text("开启后，官方文档语义上 NativeView 会更主动地抢占手势序列"),
              value: _nativeEagerGesture,
              onChanged: (bool value) {
                setState(() {
                  _nativeEagerGesture = value;
                });
                _appendLog("切换 Native eagerGesture = ${value ? "ON" : "OFF"}");
              },
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<PlatformViewHitTestBehavior>(
              value: _hitTestBehavior,
              decoration: const InputDecoration(labelText: "UiKitView hitTestBehavior", border: OutlineInputBorder()),
              items:
                  PlatformViewHitTestBehavior.values.map((PlatformViewHitTestBehavior behavior) {
                    return DropdownMenuItem<PlatformViewHitTestBehavior>(value: behavior, child: Text(behavior.name));
                  }).toList(),
              onChanged: (PlatformViewHitTestBehavior? value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _hitTestBehavior = value;
                });
                _appendLog("切换 hitTestBehavior = ${value.name}");
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogPanel() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(child: Text("事件日志", style: TextStyle(fontWeight: FontWeight.bold))),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _logs.clear();
                    });
                  },
                  child: const Text("清空"),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 220,
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8)),
              child:
                  _logs.isEmpty
                      ? const Center(
                        child: Text(
                          "点击或拖动上面的重叠区域，这里会显示 Flutter / Native 的响应顺序",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                      : ListView.builder(
                        itemCount: _logs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              _logs[index],
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: "monospace"),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("iOS 重叠手势验证页")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Colors.blue.shade50,
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "验证目标：Flutter 背景层、Flutter 覆盖层、UiKitView(native) "
                "在 Stack 中发生重叠时，点击和拖动最终由谁响应。",
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: Colors.amber.shade50,
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "官方文档要点：UiKitView 会参与 Flutter gesture arena；"
                "gestureRecognizers 为空时，只有当其他识别器都没认领该序列，事件才会派发给原生视图。"
                "如果传入 EagerGestureRecognizer，NativeView 会积极抢手势。",
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildControlPanel(),
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              width: 340,
              height: 420,
              child: Stack(
                children: [
                  Positioned.fill(child: _buildFlutterBackgroundLayer()),
                  Positioned(left: 34, top: 80, width: 220, height: 220, child: _buildNativeView()),
                  Positioned(left: 150, top: 170, width: 150, height: 150, child: _buildFlutterOverlayLayer()),
                  Positioned(
                    left: 20,
                    bottom: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text("蓝色 = NativeView, 紫色 = Flutter 覆盖层", style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildLogPanel(),
        ],
      ),
    );
  }
}
