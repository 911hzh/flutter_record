import 'package:json_annotation/json_annotation.dart';
import 'package:zh_native_channel/zh_native_channel.dart';

part 'LocationMsg.g.dart';

@ChannelMsg()
@JsonSerializable()
class LocationMsg extends ChannelBaseMsg {
  final String lat;
  final String lng;

  LocationMsg({required this.lat, required this.lng});

  factory LocationMsg.fromMap(Map<String, dynamic> map) =>
      _$LocationMsgFromJson(map);

  @override
  Map<String, dynamic> toMap() => _$LocationMsgToJson(this);
}
