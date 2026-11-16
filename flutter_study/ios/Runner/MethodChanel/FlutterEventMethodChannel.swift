//
//  FlutterEventMethodChannel.swift
//  Runner
//
//  Created by huang on 2025/11/12.
//

import Foundation
import Flutter
//class FlutterEventMethodChannel {
//    func setup() {
//        let eventChannel = FlutterEventChannel(name: "", binaryMessenger: )
//    }
//}
class StreamHandler: NSObject, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    
    func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = eventSink
        // 开始发送事件
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {[weak self] _ in
            guard let self = self else { return }
            self.eventSink!("Event Data")
        }
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
    
    
}
func setupEventChannel(controller: FlutterViewController) {
    let eventChannel = FlutterEventChannel(
        name: "FlutterNativeEventChannelBridge",
        binaryMessenger: controller.binaryMessenger
    )
    eventChannel.setStreamHandler(StreamHandler())
    
}
