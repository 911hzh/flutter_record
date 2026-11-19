// ignore_for_file: file_names

import 'package:flutter_study/module/usecase/pages/storage/StorageObjectStore.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDirectObjectStore<T> implements StorageObjectStore<T> {
  HiveDirectObjectStore({
    required this.boxName,
    required this.storageKey,
    this.displayName = 'Hive Adapter 对象存储',
  });

  final String boxName;
  final String storageKey;
  final String displayName;

  @override
  String get name => displayName;

  @override
  String get storageDescription => 'Hive 通过 TypeAdapter 直接存储对象';

  Future<Box<T>> _openBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<T>(boxName);
    }
    return Hive.openBox<T>(boxName);
  }

  @override
  Future<void> save(T value) async {
    final Box<T> box = await _openBox();
    await box.put(storageKey, value);
  }

  @override
  Future<T?> read() async {
    final Box<T> box = await _openBox();
    return box.get(storageKey);
  }

  @override
  Future<void> delete() async {
    final Box<T> box = await _openBox();
    await box.delete(storageKey);
  }
}
