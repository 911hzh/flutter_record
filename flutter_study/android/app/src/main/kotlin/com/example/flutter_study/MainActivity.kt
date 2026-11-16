package com.example.flutter_study

import com.example.flutter_study.zHNativeChannel.GeneratedChannelRegistrations
import com.example.zh_native_channel.MethodChannelMsgManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedChannelRegistrations.registerAll()
        MethodChannelMsgManager.configureBinaryMessenger(flutterEngine.dartExecutor.binaryMessenger)
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        MethodChannelMsgManager.dispose()
        super.cleanUpFlutterEngine(flutterEngine)
    }
}
