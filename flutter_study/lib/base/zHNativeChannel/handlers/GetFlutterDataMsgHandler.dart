import 'package:flutter_study/base/zHNativeChannel/msgs/GETFlutterDataMsg.dart';
import 'package:zh_native_channel/zh_native_channel.dart';

@ChannelHandlerFor('GETFlutterDataMsg')
class GetFlutterDataMsgHandler extends ChannelBaseHandler {
  @override
  Future<ChannelBaseMsg> handle(ChannelBaseMsg msg) async {
    return GETFlutterDataMsg(data: 'data');
  }
}
