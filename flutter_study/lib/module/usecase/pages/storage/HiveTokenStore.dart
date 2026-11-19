// ignore_for_file: file_names

import 'package:flutter_study/module/usecase/pages/storage/StorageCodec.dart';
import 'package:flutter_study/module/usecase/pages/storage/StorageObjectStore.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveTokenStore<T> implements StorageObjectStore<T> {
  HiveTokenStore({
    required this.codec,
    required this.boxName,
    required this.storageKey,
  });

  final StorageCodec<T> codec;
  final String boxName;
  final String storageKey;

  @override
  String get name => 'Hive Codec 存储';

  @override
  String get storageDescription => 'Hive 直接存储 Map 对象';

  Future<Box<dynamic>> _openBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<dynamic>(boxName);
    }
    return Hive.openBox<dynamic>(boxName);
  }

  @override
  Future<void> save(T value) async {
    final Box<dynamic> box = await _openBox();
    await box.put(storageKey, codec.toMap(value));
  }

  @override
  Future<T?> read() async {
    final Box<dynamic> box = await _openBox();
    final dynamic raw = box.get(storageKey);
    if (raw == null) {
      return null;
    }
    if (raw is! Map) {
      throw const FormatException('Hive storage payload is not a map.');
    }
    return codec.fromMap(Map<String, dynamic>.from(raw));
  }

  @override
  Future<void> delete() async {
    final Box<dynamic> box = await _openBox();
    await box.delete(storageKey);
  }
}
