import Flutter
import UIKit
import zh_native_channel

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // 注册插件
        GeneratedPluginRegistrant.register(with: self)
        
        // ============================================
        // 注册 Platform View（在 Flutter 中嵌入原生组件）
        // ============================================
        PlatformViewRegister.registerIOSNativeView(appDelegate: self)

        if let flutterViewController = window?.rootViewController as? FlutterViewController {
            registerNativeDemoChannel(on: flutterViewController)
            PigeonRegister.register(binaryMessenger: flutterViewController.binaryMessenger)
            GeneratedChannelRegistrations.registerAll()
            MethodChannelMsgManager.shared.configureBinaryMessenger(
                flutterViewController.binaryMessenger
            )
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func registerNativeDemoChannel(on controller: FlutterViewController) {
        let channel = FlutterMethodChannel(
            name: "FlutterNativeBridge",
            binaryMessenger: controller.binaryMessenger
        )
        channel.setMethodCallHandler { [weak controller] call, result in
            guard call.method == "openNativeViewController" else {
                result(FlutterMethodNotImplemented)
                return
            }
            guard let controller, controller.presentedViewController == nil else {
                result(FlutterError(code: "presentation_unavailable", message: nil, details: nil))
                return
            }

            let navigation = UINavigationController(rootViewController: NativeDemoViewController())
            controller.present(navigation, animated: true)
            result(nil)
        }
    }
}
