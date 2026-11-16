//
//  FlutterRegister.swift
//  Runner
//
//  Created by huang on 2025/11/11.
//

import Foundation
import Flutter
// MARK: - 注册辅助类

/// Platform View 注册管理类
/// 统一管理所有 Platform View 的注册
class PlatformViewRegister {
    
    /// 注册 iOS 原生视图（在 Flutter 中嵌入原生组件）
    /// - Parameter appDelegate: AppDelegate 实例
    static func registerIOSNativeView(appDelegate: FlutterAppDelegate) {
        guard let registrar = appDelegate.registrar(forPlugin: "IOSNativeView") else {
            print("❌ 无法获取 registrar")
            return
        }
        
        let factory = IOSNativeViewFactory(messenger: registrar.messenger())
        
        // 注册工厂，viewType 必须与 Flutter 端使用的标识符一致
        registrar.register(factory, withId: "native_test_view")
        
        print("✅ IOSNativeView 注册成功 (在 Flutter 中嵌入原生组件)")
    }
    
    // 可以继续添加其他 Platform View 的注册方法
    // static func registerOtherView(appDelegate: FlutterAppDelegate) { ... }
}
