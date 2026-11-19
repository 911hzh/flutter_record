// ignore_for_file: file_names

import 'package:flutter_study/module/usecase/pages/storage/StorageCodec.dart';
import 'package:flutter_study/module/usecase/pages/storage/StorageObjectStore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureTokenStore<T> implements StorageObjectStore<T> {
  SecureTokenStore({
    required this.codec,
    required this.storageKey,
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage();

  final StorageCodec<T> codec;
  final String storageKey;
  final FlutterSecureStorage _storage;

  @override
  String get name => 'Flutter Secure Storage';

  @override
  String get storageDescription => '使用安全存储写入 JSON 字符串';

  @override
  Future<void> save(T value) {
    return _storage.write(key: storageKey, value: codec.toJson(value));
  }

  @override
  Future<T?> read() async {
    final String? raw = await _storage.read(key: storageKey);
    if (raw == null) {
      return null;
    }
    return codec.fromJson(raw);
  }

  @override
  Future<void> delete() {
    return _storage.delete(key: storageKey);
  }
}
