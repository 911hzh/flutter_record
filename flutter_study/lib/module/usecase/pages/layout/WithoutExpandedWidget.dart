import 'package:flutter/material.dart';

class WithoutExpandedWidget extends StatelessWidget {
  const WithoutExpandedWidget({super.key, required this.text});

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
            Text('无 Expanded', style: Theme.of(context).textTheme.titleMedium),
            const Text('文字按一行排版，超出可用宽度时触发越界。'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.notes, size: 20),
                const SizedBox(width: 8),
                Text(text),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
