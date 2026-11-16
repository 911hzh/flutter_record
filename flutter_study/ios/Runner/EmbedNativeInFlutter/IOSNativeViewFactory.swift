import UIKit
import Flutter

/// Platform View 工厂类
/// 
/// 🎯 使用场景：在 Flutter 中嵌入原生 UIView
/// 
/// 职责：
/// 1. 实现 FlutterPlatformViewFactory 协议
/// 2. 负责创建 Platform View 实例
/// 3. 需要在 AppDelegate 中注册此工厂
/// 
/// 注册示例：
/// ```swift
/// PlatformViewRegister.registerIOSNativeView(appDelegate: self)
/// ```
class IOSNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private let messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    /// 创建 Platform View 实例
    /// 
    /// - Parameters:
    ///   - frame: Flutter 传递的初始尺寸
    ///   - viewId: Flutter 分配的视图 ID
    ///   - args: Flutter 传递的创建参数（经过编码器解码后的原生对象）
    /// - Returns: 返回实现了 FlutterPlatformView 协议的对象
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        print("📦 IOSNativeViewFactory - 创建视图")
        print("   frame: \(frame)")
        print("   viewId: \(viewId)")
        print("   args 类型: \(type(of: args))")
        
        // 解析 Flutter 传递的参数
        if let params = args as? [String: Any] {
            print("\n🔍 解析参数：")
            
            // ========== 读取基础类型 ==========
            let title = params["title"] as? String ?? "默认标题"
            let count = params["count"] as? Int ?? 0
            let isEnabled = params["isEnabled"] as? Bool ?? false
            let opacity = params["opacity"] as? Double ?? 1.0
            
            print("   title: \(title) (类型: String)")
            print("   count: \(count) (类型: Int)")
            print("   isEnabled: \(isEnabled) (类型: Bool)")
            print("   opacity: \(opacity) (类型: Double)")
            
            // ========== 读取嵌套 Map ==========
            if let config = params["config"] as? [String: Any] {
                print("\n   📋 config 对象:")
                let bgColor = config["backgroundColor"] as? String ?? "#FFFFFF"
                let fontSize = config["fontSize"] as? Int ?? 12
                let padding = config["padding"] as? Double ?? 0.0
                
                print("      backgroundColor: \(bgColor)")
                print("      fontSize: \(fontSize)")
                print("      padding: \(padding)")
            }
            
            // ========== 读取 List ==========
            if let items = params["items"] as? [String] {
                print("\n   📋 items 列表:")
                for (index, item) in items.enumerated() {
                    print("      [\(index)]: \(item)")
                }
            }
            
            // ========== 处理 null 值 ==========
            if let optionalValue = params["optionalValue"] {
                if optionalValue is NSNull {
                    print("\n   ⚠️ optionalValue 是 NSNull")
                } else {
                    print("\n   ✅ optionalValue: \(optionalValue)")
                }
            } else {
                print("\n   ⚠️ optionalValue 键不存在")
            }
        } else {
            print("⚠️ args 不是字典类型或为 nil")
        }
        
        return IOSNativeView(
            frame: frame,
            viewId: viewId,
            args: args,
            messenger: messenger
        )
    }
    
    /// 指定创建参数的编码格式
    /// 
    /// ⚠️ 重要：此方法返回的编码器必须与 Flutter 端的 creationParamsCodec 匹配
    /// 
    /// 可选的编码器：
    /// - FlutterStandardMessageCodec: 对应 Flutter 的 StandardMessageCodec（推荐）
    /// - FlutterJSONMessageCodec: 对应 Flutter 的 JSONMessageCodec
    /// - FlutterBinaryCodec: 对应 Flutter 的 BinaryCodec
    /// - FlutterStringCodec: 对应 Flutter 的 StringCodec
    /// 
    /// Flutter 端代码示例：
    /// ```dart
    /// UiKitView(
    ///   viewType: 'native_test_view',
    ///   creationParams: {...},
    ///   creationParamsCodec: const StandardMessageCodec(), // 对应此处
    /// )
    /// ```
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}



