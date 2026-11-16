import 'package:flutter/services.dart';

class MethodChannelManager {
  static final shared = MethodChannelManager._();
  MethodChannelManager._() {
    setupMethodChannel();
  }
  final methodChannel = MethodChannel("FlutterNativeBridge");
  void setupMethodChannel() {
    methodChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'getData':
          return 'getData result from Flutter';
      }
    });
  }

  Future<dynamic> invokeMethod(String method, [dynamic arguments]) async {
    final result = await methodChannel.invokeMethod(method, arguments);
    return result;
  }
}
