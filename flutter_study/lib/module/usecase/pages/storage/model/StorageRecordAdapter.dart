// ignore_for_file: file_names

import 'package:flutter_study/module/usecase/pages/storage/model/StorageRecord.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StorageRecordAdapter extends TypeAdapter<StorageRecord> {
  @override
  final int typeId = 1;

  @override
  StorageRecord read(BinaryReader reader) {
    return StorageRecord(
      id: reader.readString(),
      token: reader.readString(),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      extra: Map<String, String>.from(reader.readMap()),
    );
  }

  @override
  void write(BinaryWriter writer, StorageRecord obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.token)
      ..writeInt(obj.updatedAt.millisecondsSinceEpoch)
      ..writeMap(obj.extra);
  }
}
