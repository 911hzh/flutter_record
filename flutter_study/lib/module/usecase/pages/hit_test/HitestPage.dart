import 'package:flutter/material.dart';

class HitestPage extends StatefulWidget {
  const HitestPage({super.key});

  @override
  State<HitestPage> createState() => _HitestPageState();
}

class _HitestPageState extends State<HitestPage> {
  HitTestBehavior _behavior = HitTestBehavior.opaque;
  int? _lastPointer;
  final List<String> _receivers = [];
  final Map<HitTestBehavior, int> _examplePresses = {};

  void _recordPointerDown(PointerDownEvent event, String layer) {
    setState(() {
      if (_lastPointer != event.pointer) {
        _lastPointer = event.pointer;
        _receivers.clear();
      }
      _receivers.add(layer);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HitTestBehavior')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _exampleCard(
            title: 'Container：文字周围的留白',
            tint: Colors.deepOrange,
            children: [
              const Text(
                '每个边框内的整块区域都是一个 Container，包含文字和周围的 Padding。'
                '外层 Listener 与边框同宽同高。',
              ),
              const SizedBox(height: 12),
              _paddingExample(
                HitTestBehavior.deferToChild,
                explanation:
                    'Padding 扩大了布局。点文字时子组件命中，计数增加。'
                    '点留白时子组件没有命中，外层 Listener 收不到这次按下。',
              ),
              const Divider(height: 24),
              _paddingExample(
                HitTestBehavior.opaque,
                explanation:
                    '外层 Listener 会在整个布局范围内自行命中，'
                    '所以点文字和点留白都会增加计数。',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _overlapExample(),
        ],
      ),
    );
  }

  Widget _overlapExample() {
    const lowerLayerColor = Color(0xFFFFE0A3);
    const upperAreaColor = Color(0xFFDCEEFF);
    const upperChildColor = Color(0xFF1858AB);
    const areaLabelStyle = TextStyle(
      color: Color(0xFF172B45),
      fontWeight: FontWeight.w600,
    );
    return _exampleCard(
      title: 'Listener：叠层命中',
      tint: Colors.blue,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final behavior in HitTestBehavior.values)
              ChoiceChip(
                label: Text(behavior.name),
                selected: _behavior == behavior,
                onSelected: (selected) {
                  if (!selected) return;
                  setState(() {
                    _behavior = behavior;
                    _receivers.clear();
                  });
                },
              ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('蓝框内是上层 Listener 的范围。先点浅蓝留白，再切换模式点同一处。'),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: Stack(
            children: [
              Positioned.fill(
                child: Listener(
                  behavior: HitTestBehavior.opaque,
                  onPointerDown: (event) => _recordPointerDown(event, '下层'),
                  child: ColoredBox(
                    color: lowerLayerColor,
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: upperAreaColor,
                                border: Border.all(color: upperChildColor),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 12),
                                  child: Text('上层空白区', style: areaLabelStyle),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 64,
                          child: Center(
                            child: Text('下层独占区', style: areaLabelStyle),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                right: 12,
                bottom: 64,
                child: Listener(
                  behavior: _behavior,
                  onPointerDown: (event) => _recordPointerDown(event, '上层'),
                  child: Center(
                    child: ColoredBox(
                      color: upperChildColor,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Text(
                          '上层子组件',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _receivers.isEmpty
              ? '最近一次按下：等待点击'
              : '最近一次按下：${_receivers.join(' → ')}',
        ),
        const SizedBox(height: 8),
        const Text(
          '默认使用 opaque，点上层空白区时只有上层收到事件。'
          '切换到 translucent 后再点同一处，上下两层都能收到事件。',
        ),
      ],
    );
  }

  Widget _paddingExample(
    HitTestBehavior behavior, {
    required String explanation,
  }) {
    final colors = Theme.of(context).colorScheme;
    final isOpaque = behavior == HitTestBehavior.opaque;
    final borderColor = isOpaque ? colors.primary : colors.outline;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          isOpaque ? 'opaque · 整个框内可命中' : 'deferToChild · 文字范围可命中',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            color: isOpaque
                ? colors.primaryContainer
                : colors.surfaceContainerHighest,
            border: Border.all(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Listener(
            behavior: behavior,
            onPointerDown: (_) {
              setState(() {
                _examplePresses.update(
                  behavior,
                  (count) => count + 1,
                  ifAbsent: () => 1,
                );
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              child: Center(
                child: Text(
                  '示例文字',
                  style: TextStyle(
                    color: isOpaque
                        ? colors.onPrimaryContainer
                        : colors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '收到 ${_examplePresses[behavior] ?? 0} 次按下',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(explanation),
      ],
    );
  }

  Widget _exampleCard({
    required String title,
    required Color tint,
    required List<Widget> children,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      color: Color.alphaBlend(
        tint.withValues(alpha: 0.22),
        Theme.of(context).colorScheme.surface,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}
