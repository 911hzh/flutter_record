// 自动生成代码，请勿手动修改

// ************************************************************************
// ChannelRegisterBuilder
// ************************************************************************

import 'package:flutter_study/base/zHNativeChannel/handlers/GetFlutterDataMsgHandler.dart';
import 'package:flutter_study/base/zHNativeChannel/handlers/LocationMsgHandlers.dart';
import 'package:flutter_study/base/zHNativeChannel/msgs/GETFlutterDataMsg.dart';
import 'package:flutter_study/base/zHNativeChannel/msgs/LocationMsg.dart';
import 'package:zh_native_channel/zh_native_channel.dart';

void initializeGeneratedChannels() {
  final channel = ZHNativeChannel.instance;
  channel.initializeRegisters((msgRegister, handlerRegister) {
    registerGeneratedChannels(
      msgRegister: msgRegister,
      handlerRegister: handlerRegister,
    );
  });
}

void registerGeneratedChannels({
  required ChannelBaseMsgRegister msgRegister,
  required ChannelHandlerRegister handlerRegister,
}) {
  registerGeneratedChannelMessages(msgRegister);
  registerGeneratedChannelHandlers(handlerRegister);
}

void registerGeneratedChannelMessages(ChannelBaseMsgRegister register) {
  register.registerChannel('GETFlutterDataMsg', GETFlutterDataMsg.fromMap);
  register.registerChannel('LocationMsg', LocationMsg.fromMap);
}

void registerGeneratedChannelHandlers(ChannelHandlerRegister register) {
  register.registerChannel('GETFlutterDataMsg', GetFlutterDataMsgHandler());
  register.registerChannel('LocationMsg', LocationMsgHandlers());
}
