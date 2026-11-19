// ignore_for_file: file_names

import 'package:json_annotation/json_annotation.dart';

part 'StorageRecord.g.dart';

@JsonSerializable()
class StorageRecord {
  const StorageRecord({
    required this.id,
    required this.token,
    required this.updatedAt,
    required this.extra,
  });

  final String id;
  final String token;
  final DateTime updatedAt;
  final Map<String, String> extra;

  factory StorageRecord.fromJson(Map<String, dynamic> json) =>
      _$StorageRecordFromJson(json);

  Map<String, dynamic> toJson() => _$StorageRecordToJson(this);

  String toLogString() {
    return 'id=$id, token=$token, updatedAt=${updatedAt.toIso8601String()}, extra=$extra';
  }
}
