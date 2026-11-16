import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/module/usecase/pages/transition/custom/AnimationPageRoute/slide_up_page_route.dart';

class TransitionPage extends StatelessWidget {
  const TransitionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("转场目标界面"), leading: null),
      backgroundColor: Colors.blue,
      body: Container(
        color: Colors.black12,
        child: ElevatedButton(
          child: Text("滑动转场"),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) {
                  return const TransitionPage();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
