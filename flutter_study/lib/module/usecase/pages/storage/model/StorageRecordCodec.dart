// ignore_for_file: file_names

import 'package:flutter_study/module/usecase/pages/storage/StorageCodec.dart';
import 'package:flutter_study/module/usecase/pages/storage/model/StorageRecord.dart';

class StorageRecordCodec extends StorageCodec<StorageRecord> {
  const StorageRecordCodec();

  @override
  Map<String, dynamic> toMap(StorageRecord value) {
    return value.toJson();
  }

  @override
  StorageRecord fromMap(Map<String, dynamic> map) {
    return StorageRecord.fromJson(map);
  }
}
