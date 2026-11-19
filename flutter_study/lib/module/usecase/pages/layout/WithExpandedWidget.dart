import 'package:flutter/material.dart';

class WithExpandedWidget extends StatelessWidget {
  const WithExpandedWidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Text('有 Expanded', style: Theme.of(context).textTheme.titleMedium),
            const Text('文字使用图标右侧的剩余宽度，放不下时换行。'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.notes, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(text)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
