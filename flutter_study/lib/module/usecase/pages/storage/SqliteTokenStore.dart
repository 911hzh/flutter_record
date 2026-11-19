// ignore_for_file: file_names

import 'dart:typed_data';

import 'package:flutter_study/module/usecase/pages/storage/StorageCodec.dart';
import 'package:flutter_study/module/usecase/pages/storage/StorageObjectStore.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class SqliteTokenStore<T> implements StorageObjectStore<T> {
  SqliteTokenStore({required this.codec, required this.storageKey});

  static const String _databaseName = 'storage_demo.db';
  static const String _tableName = 'token_store';

  final StorageCodec<T> codec;
  final String storageKey;

  Future<Database>? _databaseFuture;

  @override
  String get name => 'SQLite';

  @override
  String get storageDescription => 'SQLite 以二进制 BLOB 持久化对象数据';

  Future<Database> _database() {
    return _databaseFuture ??= _openDatabase();
  }

  Future<Database> _openDatabase() async {
    final String databasesPath = await getDatabasesPath();
    final String databasePath = path.join(databasesPath, _databaseName);
    return openDatabase(
      databasePath,
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            store_key TEXT PRIMARY KEY,
            value BLOB NOT NULL
          )
        ''');
      },
    );
  }

  @override
  Future<void> save(T value) async {
    final Database db = await _database();
    await db.insert(_tableName, <String, Object>{
      'store_key': storageKey,
      'value': codec.toBytes(value),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<T?> read() async {
    final Database db = await _database();
    final List<Map<String, Object?>> result = await db.query(
      _tableName,
      columns: <String>['value'],
      where: 'store_key = ?',
      whereArgs: <Object>[storageKey],
      limit: 1,
    );
    if (result.isEmpty) {
      return null;
    }

    final Object? raw = result.first['value'];
    if (raw is Uint8List) {
      return codec.fromBytes(raw);
    }
    if (raw is List<int>) {
      return codec.fromBytes(Uint8List.fromList(raw));
    }
    if (raw is String) {
      return codec.fromJson(raw);
    }
    throw const FormatException(
      'SQLite storage payload has unsupported format.',
    );
  }

  @override
  Future<void> delete() async {
    final Database db = await _database();
    await db.delete(
      _tableName,
      where: 'store_key = ?',
      whereArgs: <Object>[storageKey],
    );
  }
}
