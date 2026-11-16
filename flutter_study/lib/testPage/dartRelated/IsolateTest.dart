import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';

class IsolateTest {
  Future<String> testCompute() async {
    Future(() => "test");
    final timer = Timer(Duration(seconds: 1), () {
      print("timer");
    });
    // final isolate = compute(
    //   (message) {
    //     return message + "1";
    //   },
    //   "test",
    //   debugLabel: "test",
    // );
    // final result = await isolate;
    // print("IsolateTest test: $result");
    // return result;
    final resultFuture = compute((message) {
      return message + "1";
    }, "test");
    final result = await resultFuture;
    print("IsolateTest test: $result");
    return result;
  }

  Future<String> testSpawn() async {
    final receivePort = ReceivePort();

    var result = "";

    Isolate.spawn(callback, receivePort.sendPort);
    await for (final message in receivePort) {
      print("IsolateTest test: $message");
      result = message;
    }
    return result;
  }

  void callback(SendPort sendPort) {
    // print("IsolateTest test: $message");
    // receivePort.send(message);
    sendPort.send("test" + "2222");
  }
}
