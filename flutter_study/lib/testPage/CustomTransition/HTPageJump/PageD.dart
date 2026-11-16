import 'package:flutter/material.dart';

class PageD extends StatefulWidget {
  static _PageDState? state;
  static const PageStorageKey<String> pageStorageKey = PageStorageKey<String>('pageD');

  const PageD({Key? key}) : super(key: key);

  @override
  State<PageD> createState() {
    return _PageDState();
  }
}

class _PageDState extends State<PageD> {
  int count = 0;

  @override
  void initState() {
    super.initState();
    // 从 PageStorage 恢复状态
    final bucket = PageStorage.of(context);
    if (bucket != null) {
      final savedCount = bucket.readState(context, identifier: PageD.pageStorageKey) as int?;
      if (savedCount != null) {
        count = savedCount;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PageD'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('count: $count'),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  count++;
                  // 保存状态到 PageStorage
                  final bucket = PageStorage.of(context);
                  if (bucket != null) {
                    bucket.writeState(context, count, identifier: PageD.pageStorageKey);
                  }
                });
              },
              child: const Text('count ++'),
            ),
          ],
        ),
      ),
    );
  }
}
