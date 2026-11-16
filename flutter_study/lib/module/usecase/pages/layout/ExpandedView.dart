import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/src/widgets/framework.dart";
import "package:flutter/widgets.dart";
import "package:flutter_hooks/flutter_hooks.dart";

class ExpandedView extends HookWidget {
  ExpandedView();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: Row(children: [Container(child: Text("title"), height: 300)]),
            color: Colors.black,
          ),
          Container(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "detailfasjkfll;adsjfjdsalf;jsda;fljsdalklfjsda;lfjk;asdkjfl;asdjfl;ksdjlfkjsad;lfjasdl;fj",
                  ),
                ),
              ],
            ),
            color: Colors.blue,
          ),
          Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Text("111111" * index * 3);
                },
                itemCount: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
