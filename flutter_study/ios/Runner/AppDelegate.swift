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
            PigeonRegister.register(binaryMessenger: flutterViewController.binaryMessenger)
            GeneratedChannelRegistrations.registerAll()
            MethodChannelMsgManager.shared.configureBinaryMessenger(
                flutterViewController.binaryMessenger
            )
        }
        
        // // ============================================
        // // 测试按钮：演示在原生中嵌入 Flutter
        // // ============================================
        // // 延迟 3 秒后添加一个测试按钮
        // // 点击按钮可以打开 Flutter 页面
        // let button = UIButton()
        // button.setTitle("打开 Flutter 页面", for: .normal)
        // button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        // button.frame = CGRect(x: 20, y: 80, width: 120, height: 44)
        // button.backgroundColor = UIColor.systemBlue
        // button.layer.cornerRadius = 8
        // button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        
        // DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        //     self.window?.addSubview(button)
        // }

        // ============================================
        // 测试按钮：演示在原生中嵌入 Flutter
        // ============================================
        // 延迟 3 秒后添加一个测试按钮
        // 点击按钮可以打开 Flutter 页面
        let button = UIButton()
        button.setTitle("打开 Flutter 页面", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.frame = CGRect(x: 20, y: 80, width: 120, height: 44)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(getFlutterMsg), for: .touchUpInside)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.window?.addSubview(button)
        }
        
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    /// 按钮点击事件：打开 Flutter Widget 页面
    @objc func tapButton() {
        // 使用 FlutterWidgetVC 打开 Flutter 页面
        let flutterVC = FlutterWidgetVC(route: "/native_use_flutter_page")
        
        window?.rootViewController?.present(flutterVC, animated: true)
    }
    @objc func getFlutterMsg() {
        MethodChannelMsgManager.shared.invoke(GETFlutterDataMsg(data: ""), completion: { result in
            switch result {
            case .success(let value):
                if let value = value as? GETFlutterDataMsg {
                    print("------ ios getData: \(value)")
                }
            case .failure(let error):
                print("error: \(error.localizedDescription)")
                
            }
        
        })
    }
                                              
}
