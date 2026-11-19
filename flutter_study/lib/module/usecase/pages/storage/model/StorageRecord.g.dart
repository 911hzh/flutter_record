// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'StorageRecord.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StorageRecord _$StorageRecordFromJson(Map<String, dynamic> json) =>
    StorageRecord(
      id: json['id'] as String,
      token: json['token'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      extra: Map<String, String>.from(json['extra'] as Map),
    );

Map<String, dynamic> _$StorageRecordToJson(StorageRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'extra': instance.extra,
    };
