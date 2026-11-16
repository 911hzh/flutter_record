import 'package:flutter/services.dart';

class BasicMessageChannelManager {
  static final shared = BasicMessageChannelManager._();
  BasicMessageChannelManager._() {
    setupBasicMessageChannel();
  }
  final basicMessageChannel = BasicMessageChannel("FlutterNativeBasicMessageChannelBridge", StandardMessageCodec());
  void setupBasicMessageChannel() {
    basicMessageChannel.setMessageHandler((message) async {
      return "BasicMessageChannelManager receive message: $message";
    });
  }

  void sendMessage(String message) {
    basicMessageChannel.send(message);
  }
}
