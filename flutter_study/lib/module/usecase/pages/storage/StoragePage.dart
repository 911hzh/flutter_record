// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_study/module/usecase/pages/storage/HiveDirectObjectStore.dart';
import 'package:flutter_study/module/usecase/pages/storage/HiveTokenStore.dart';
import 'package:flutter_study/module/usecase/pages/storage/SecureTokenStore.dart';
import 'package:flutter_study/module/usecase/pages/storage/SharedPreferencesTokenStore.dart';
import 'package:flutter_study/module/usecase/pages/storage/SqliteTokenStore.dart';
import 'package:flutter_study/module/usecase/pages/storage/StorageObjectStore.dart';
import 'package:flutter_study/module/usecase/pages/storage/model/StorageRecord.dart';
import 'package:flutter_study/module/usecase/pages/storage/model/StorageRecordCodec.dart';

class StoragePage extends StatefulWidget {
  const StoragePage({super.key});

  @override
  State<StoragePage> createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  static const StorageRecordCodec _codec = StorageRecordCodec();

  late final List<_StoreCardState> _storeCards = <_StoreCardState>[
    _StoreCardState(
      store: SecureTokenStore<StorageRecord>(
        codec: _codec,
        storageKey: 'secure_storage_record',
      ),
      controller: TextEditingController(text: 'secure-token-demo'),
    ),
    _StoreCardState(
      store: HiveTokenStore<StorageRecord>(
        codec: _codec,
        boxName: 'StorageCodecBox',
        storageKey: 'hive_storage_record',
      ),
      controller: TextEditingController(text: 'hive-token-demo'),
    ),
    _StoreCardState(
      store: HiveDirectObjectStore<StorageRecord>(
        boxName: 'StorageDirectObjectBox',
        storageKey: 'hive_storage_direct_record',
      ),
      controller: TextEditingController(text: 'hive-direct-token-demo'),
    ),
    _StoreCardState(
      store: SharedPreferencesTokenStore<StorageRecord>(
        codec: _codec,
        storageKey: 'shared_preferences_storage_record',
      ),
      controller: TextEditingController(text: 'shared-token-demo'),
    ),
    _StoreCardState(
      store: SqliteTokenStore<StorageRecord>(
        codec: _codec,
        storageKey: 'sqlite_storage_record',
      ),
      controller: TextEditingController(text: 'sqlite-token-demo'),
    ),
  ];

  final List<String> _logs = <String>[];

  @override
  void dispose() {
    for (final _StoreCardState storeCard in _storeCards) {
      storeCard.controller.dispose();
    }
    super.dispose();
  }

  StorageRecord _buildRecord(_StoreCardState storeCard) {
    final String token = storeCard.controller.text.trim();
    return StorageRecord(
      id: '${storeCard.store.name}-${DateTime.now().millisecondsSinceEpoch}',
      token: token,
      updatedAt: DateTime.now(),
      extra: <String, String>{
        'store': storeCard.store.name,
        'storageDescription': storeCard.store.storageDescription,
      },
    );
  }

  Future<void> _saveRecord(_StoreCardState storeCard) async {
    final String token = storeCard.controller.text.trim();
    if (token.isEmpty) {
      _appendLog(storeCard.store.name, '写入失败，token 不能为空');
      return;
    }

    final StorageRecord record = _buildRecord(storeCard);
    await storeCard.store.save(record);
    if (!mounted) {
      return;
    }
    setState(() {
      storeCard.lastReadValue = record;
    });
    _appendLog(
      storeCard.store.name,
      '写入对象: ${record.toLogString()} | 持久化方式: ${storeCard.store.storageDescription}',
    );
  }

  Future<void> _readRecord(_StoreCardState storeCard) async {
    final StorageRecord? record = await storeCard.store.read();
    if (!mounted) {
      return;
    }
    setState(() {
      storeCard.lastReadValue = record;
    });
    _appendLog(
      storeCard.store.name,
      '读取对象: ${record?.toLogString() ?? 'null'} | 持久化方式: ${storeCard.store.storageDescription}',
    );
  }

  Future<void> _deleteRecord(_StoreCardState storeCard) async {
    await storeCard.store.delete();
    if (!mounted) {
      return;
    }
    setState(() {
      storeCard.lastReadValue = null;
    });
    _appendLog(storeCard.store.name, '删除对象完成');
  }

  void _appendLog(String storeName, String message) {
    final String timestamp = DateTime.now().toIso8601String();
    setState(() {
      _logs.insert(0, '[$timestamp] [$storeName] $message');
    });
  }

  void _clearLogs() {
    setState(() {
      _logs.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('本地存储对比')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const Text(
            '输入 Token，分别尝试写入、读取与删除，对比五种对象持久化方式。',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ..._storeCards.map(_buildStoreCard),
          const SizedBox(height: 16),
          _buildLogCard(),
        ],
      ),
    );
  }

  Widget _buildStoreCard(_StoreCardState storeCard) {
    final StorageRecord previewRecord = _buildRecord(storeCard);
    return Card.filled(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              storeCard.store.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              storeCard.store.storageDescription,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: storeCard.controller,
              onChanged: (_) {
                setState(() {});
              },
              decoration: const InputDecoration(
                filled: true,
                prefixIcon: Icon(Icons.vpn_key_outlined),
                border: OutlineInputBorder(),
                labelText: 'Token',
                hintText: '请输入要写入对象中的 token 字段',
              ),
            ),
            const SizedBox(height: 12),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: const Text('待写入对象'),
              children: [SelectableText(previewRecord.toLogString())],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                FilledButton(
                  onPressed: () => _saveRecord(storeCard),
                  child: const Text('写入对象'),
                ),
                OutlinedButton(
                  onPressed: () => _readRecord(storeCard),
                  child: const Text('读取对象'),
                ),
                TextButton(
                  onPressed: () => _deleteRecord(storeCard),
                  child: const Text('删除对象'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('最近读取', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 4),
                  SelectableText(
                    storeCard.lastReadValue?.toLogString() ?? '暂未读取数据',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogCard() {
    return Card.filled(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  '操作日志',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(onPressed: _clearLogs, child: const Text('清空日志')),
              ],
            ),
            const SizedBox(height: 8),
            if (_logs.isEmpty)
              const Text('暂无日志')
            else
              ..._logs.map(
                (String log) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(log),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StoreCardState {
  _StoreCardState({required this.store, required this.controller});

  final StorageObjectStore<StorageRecord> store;
  final TextEditingController controller;
  StorageRecord? lastReadValue;
}
