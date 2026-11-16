import 'package:json_annotation/json_annotation.dart';
import 'package:zh_native_channel/zh_native_channel.dart';
part 'GETFlutterDataMsg.g.dart';

@ChannelMsg()
@JsonSerializable()
class GETFlutterDataMsg extends ChannelBaseMsg {
  final String data;
  GETFlutterDataMsg({required this.data});
  factory GETFlutterDataMsg.fromMap(Map<String, dynamic> map) => _$GETFlutterDataMsgFromJson(map);
  @override
  Map<String, dynamic> toMap() => _$GETFlutterDataMsgToJson(this);
}
