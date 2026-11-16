import 'package:flutter/services.dart';

class EventMessageChannelManager {
  EventMessageChannelManager() {}
  final eventMessageChannel = EventChannel("FlutterNativeEventChannelBridge");
  void setupEventMessageChannel() {
    eventMessageChannel.receiveBroadcastStream().listen((event) {
      print("EventMessageChannelManager receive event: $event");
    });
  }
}
