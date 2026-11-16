import 'package:flutter_study/infra/platform/zHNativeChannel/msgs/LocationMsg.dart';
import 'package:zh_native_channel/zh_native_channel.dart';

@ChannelHandlerFor('LocationMsg')
class LocationMsgHandlers extends ChannelBaseHandler {
  @override
  Future<ChannelBaseMsg> handle(ChannelBaseMsg msg) async {
    return LocationMsg(lat: '31.2304', lng: '121.4737');
  }
}
