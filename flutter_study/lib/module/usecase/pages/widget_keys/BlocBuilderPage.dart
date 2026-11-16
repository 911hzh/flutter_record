import "dart:isolate";

import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/src/widgets/framework.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_hooks/flutter_hooks.dart";

class BlocBuilderPage extends HookWidget {
  BlocBuilderPage();

  @override
  Widget build(BuildContext context) {
    final count = useState(0);
    const textStyle = TextStyle(decoration: TextDecoration.none);

    useEffect(() {
      final countT = count.value;
      Future(() async {
        // var countNum = 10000;
        // while (countNum > 0) {
        //   print("1 count: ${countNum}");
        //   countNum = countNum - 1;
        // }
        // print('completed: $countT');
        // return Future(() => count);

        int count = await Isolate.run(() {
          return countWhile();
        });
        return Future(() => count);
        print('展示文件内容: $count');
      }).then((value) {
        print("completed: ${count}");
      });
    }, [count.value]);
    useEffect(() {
      final countT = count.value;
      Future(() async {
        // var countNum = 10000;
        // while (countNum > 0) {
        //   // print("2 count: ${countNum}");
        //   countNum = countNum - 1;
        // }
        // print("completed: ${countT}");
        // return Future(() => count)   ;
        int count = await Isolate.run(() {
          return countWhile();
        });
        return Future(() => count);
      }).then((value) {
        print("completed: ${countT}");
      });
    }, [count.value]);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      color: Colors.grey,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              "BlocBuilderPage firstChild count ${count.value}",
              style: textStyle,
            ),
            color: Colors.white,
          ),
          Container(
            child: Card(),
            color: Colors.white,
            margin: EdgeInsets.only(top: 20),
          ),
          GestureDetector(
            onTap: () {
              count.value = count.value + 1;
            },
            child: Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Text(
                    "count add",
                    style: textStyle,
                  )
                ],
              ),
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            ),
          )
        ],
      ),
    );
  }
}

// class CardParent extends HookWidget {
//   CardParent();
//
//   final textStyle = TextStyle(decoration: TextDecoration.none);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           child: Text(
//             "count: ",
//             style: textStyle,
//           ),
//         ),
//       ],
//     );
//   }
// }

class Card extends HookWidget {
  Card();

  @override
  Widget build(BuildContext context) {
    final detailPageEntry = Object();
    print("detailPageEntry build change ${detailPageEntry.hashCode}");
    useEffect(() {
      print("detailPageEntry mounted ${detailPageEntry.hashCode}");
      return () {
        print("-- repeat dispose ${this.runtimeType}");
      };
    }, []);
    return Container(
      child: Text("Card count "),
    );
  }
}

class CardState {}

class CardBloc extends BlocBase<CardState> {
  CardBloc() : super(CardState());

  create() {}
}

// 处理耗时任务
Future<int> countWhile() async {
  var count = 10000;
  while (count > 0) {
    print("count: ${count}");
    count = count - 1;
  }
  return Future(() => count);
}
// useEffect(() {
//   Future(() async {
//     var count = 10000;
//     while (count > 0) {
//       print("count: ${count}");
//       count = count - 1;
//     }
//     return Future(() => count);
//
//     // int count = await Isolate.run(() {
//     //   return countWhile();
//     // });
//     print('展示文件内容: $count');
//   }).then((value) {
//     print("completed: ${value}");
//   });
// }, [count.value]);
