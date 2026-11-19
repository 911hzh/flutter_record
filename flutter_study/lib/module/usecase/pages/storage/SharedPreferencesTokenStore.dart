// ignore_for_file: file_names

import 'package:flutter_study/module/usecase/pages/storage/StorageCodec.dart';
import 'package:flutter_study/module/usecase/pages/storage/StorageObjectStore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesTokenStore<T> implements StorageObjectStore<T> {
  SharedPreferencesTokenStore({required this.codec, required this.storageKey});

  final StorageCodec<T> codec;
  final String storageKey;

  @override
  String get name => 'SharedPreferences';

  @override
  String get storageDescription => 'SharedPreferences 存储 JSON 字符串';

  @override
  Future<void> save(T value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, codec.toJson(value));
  }

  @override
  Future<T?> read() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(storageKey);
    if (raw == null) {
      return null;
    }
    return codec.fromJson(raw);
  }

  @override
  Future<void> delete() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(storageKey);
  }
}
