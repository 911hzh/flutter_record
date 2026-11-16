import 'package:flutter/material.dart';
import 'package:flutter_study/infra/platform/zHNativeChannel/msgs/LocationMsg.dart';
import 'package:zh_native_channel/zh_native_channel.dart';

class ZHNativeChannelDemoPage extends StatefulWidget {
  const ZHNativeChannelDemoPage({super.key});

  @override
  State<ZHNativeChannelDemoPage> createState() => _ZHNativeChannelDemoPageState();
}

class _ZHNativeChannelDemoPageState extends State<ZHNativeChannelDemoPage> {
  String _result = '尚未调用';
  bool _loading = false;

  Future<void> _invokeLocationMsg() async {
    setState(() {
      _loading = true;
      _result = '调用中...';
    });

    try {
      final response = await ZHNativeChannel.instance.invoke(LocationMsg(lat: '31.2304', lng: '121.4737'));
      if (!mounted) {
        return;
      }
      setState(() {
        _result = '返回类型: ${response.runtimeType}\n返回内容: ${response.toMap()}';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _result = '调用失败: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ZHNativeChannel Demo')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('通过 ZHNativeChannel 发送 LocationMsg，并展示 Native 返回结果。', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _loading ? null : _invokeLocationMsg,
              child: Text(_loading ? '调用中...' : '发送 LocationMsg'),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(padding: const EdgeInsets.all(16), child: Text(_result)),
            ),
          ],
        ),
      ),
    );
  }
}
