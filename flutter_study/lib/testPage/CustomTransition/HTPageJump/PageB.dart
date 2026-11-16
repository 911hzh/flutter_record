import 'package:flutter_study/testPage/CustomTransition/CustomPageRoute/CustomFadeRouteWithGesture.dart';
import 'package:flutter_study/testPage/CustomTransition/HTPageJump/PageA.dart';
import 'package:flutter/material.dart';

class PageB extends StatefulWidget {
  final ValueNotifier<double> progressNotifier;
  final ValueNotifier<TransactionAnimation?> transactionAnimation;
  const PageB({Key? key, required this.progressNotifier, required this.transactionAnimation}) : super(key: key);

  @override
  State<PageB> createState() => _PageBState();
}

class _PageBState extends State<PageB> {
  @override
  void initState() {
    super.initState();
    widget.progressNotifier.addListener(_onProgressChanged);
  }

  @override
  void dispose() {
    widget.progressNotifier.removeListener(_onProgressChanged);
    super.dispose();
  }

  void _onProgressChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PageB')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Color.lerp(Colors.blue, Colors.red, widget.progressNotifier.value),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  '当前进度: ${(widget.progressNotifier.value * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                value: widget.progressNotifier.value,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.lerp(Colors.blue, Colors.red, widget.progressNotifier.value) ?? Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('返回首页'),
            ),
            ElevatedButton(
              onPressed: () {
                final progressNotifier = ValueNotifier(0.0);
                final transactionAnimation = ValueNotifier<TransactionAnimation?>(null);
                Navigator.of(context).push(
                  CustomFadeRouteWithGesture(
                    builder: (context) {
                      return PageA(progressNotifier: progressNotifier, transactionAnimation: transactionAnimation);
                    },
                    title: "PageA",
                    transactionAnimation: transactionAnimation,
                  ),
                );
              },
              child: const Text('to PageA'),
            ),
          ],
        ),
      ),
    );
  }
}
