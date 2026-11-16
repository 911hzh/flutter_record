import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

class BaseComponentPage extends StatefulWidget {
  const BaseComponentPage({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BaseComponentPageState();
  }
}

class BaseComponentPageState extends State<BaseComponentPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ConstrainedBox(
      constraints: BoxConstraints.tight(Size(300, 100)),
      child: Container(
        width: 300,
        height: 100,
        child: Column(
          children: [
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.blue),
                child: Column(
                  children: [
                    Text("22222"),
                    Container(
                      width: 100,
                      height: 100,
                      color: Colors.red,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
    // TODO: implement build
    // return const DecoratedBox(
    //     decoration: BoxDecoration(color: Colors.red),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Padding(
    //           padding: EdgeInsets.symmetric(vertical: 40, horizontal: 0),
    //           child: DecoratedBox(
    //             decoration: BoxDecoration(color: Colors.yellow),
    //             child: Text(
    //               "data1111fsadkjfa;sdfjsa;ldfjas;ldjfla;sdjfla;sdjfklasd;jfasd;lfjal;sdjfas;kljf",
    //               style: TextStyle(
    //                   color: Colors.black, decoration: TextDecoration.none),
    //             ),
    //           ),
    //         ),
    //         Padding(
    //             padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
    //             child: DecoratedBox(
    //               decoration: BoxDecoration(color: Colors.yellow),
    //               child: Text(
    //                 "11d222222222222222,11d222222222222222,11d222222222222222,11d222222222222222",
    //                 style: TextStyle(
    //                     color: Colors.black, decoration: TextDecoration.none),
    //               ),
    //             )),
    //         DecoratedBox(
    //           decoration: BoxDecoration(color: Colors.yellow),
    //           child: Text(
    //             "33333333333333333333333333333333333333333333333333333333333333333333333333333",
    //             style: TextStyle(
    //                 color: Colors.black, decoration: TextDecoration.none),
    //           ),
    //         )
    //       ],
    //     ));
  }
}
