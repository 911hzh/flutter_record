import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study/module/usecase/pages/riverprovider/RiverProviderViewModel.dart';

class RiverProviderPage extends ConsumerWidget {
  const RiverProviderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String title = ref.watch(riverProviderTitleProvider);
    final RiverProviderState state = ref.watch(riverProviderViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const Text(
            '点击加减更新共享状态，或运行异步刷新观察加载过程。',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          _CountCardWidget(count: state.count),
          const SizedBox(height: 16),
          _MessageCardWidget(
            message: state.message,
            isLoading: state.isLoading,
          ),
        ],
      ),
    );
  }
}

class _CountCardWidget extends ConsumerWidget {
  const _CountCardWidget({required this.count});

  final int count;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card.filled(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              '共享计数 · NotifierProvider',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '$count',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                FilledButton(
                  onPressed: () {
                    ref
                        .read(riverProviderViewModelProvider.notifier)
                        .increment();
                  },
                  child: const Text('count +1'),
                ),
                OutlinedButton(
                  onPressed: () {
                    ref
                        .read(riverProviderViewModelProvider.notifier)
                        .decrement();
                  },
                  child: const Text('count -1'),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(riverProviderViewModelProvider.notifier).reset();
                  },
                  child: const Text('重置'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageCardWidget extends ConsumerWidget {
  const _MessageCardWidget({required this.message, required this.isLoading});

  final String message;
  final bool isLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card.filled(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              '异步刷新 · Notifier',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (isLoading) const LinearProgressIndicator(),
            const SizedBox(height: 8),
            Text(
              isLoading ? '加载中...' : message,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      ref
                          .read(riverProviderViewModelProvider.notifier)
                          .reloadMessage();
                    },
              child: const Text('重新加载异步数据'),
            ),
          ],
        ),
      ),
    );
  }
}

class TextWidget extends ConsumerWidget {
  const TextWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(
      riverProviderViewModelProvider.select((state) => state.count),
    );
    return Text("88888 $count");
  }
}

@Preview(name: 'TextWidget')
Widget preview() => const TextWidget();
