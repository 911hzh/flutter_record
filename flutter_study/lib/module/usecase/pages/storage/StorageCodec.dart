// ignore_for_file: file_names

import 'dart:convert';
import 'dart:typed_data';

abstract class StorageCodec<T> {
  const StorageCodec();

  Map<String, dynamic> toMap(T value);

  T fromMap(Map<String, dynamic> map);

  String toJson(T value) {
    return jsonEncode(toMap(value));
  }

  T fromJson(String source) {
    final dynamic decoded = jsonDecode(source);
    if (decoded is! Map) {
      throw const FormatException('Storage json payload is not a map.');
    }
    return fromMap(Map<String, dynamic>.from(decoded));
  }

  Uint8List toBytes(T value) {
    return Uint8List.fromList(utf8.encode(toJson(value)));
  }

  T fromBytes(Uint8List bytes) {
    return fromJson(utf8.decode(bytes));
  }
}
