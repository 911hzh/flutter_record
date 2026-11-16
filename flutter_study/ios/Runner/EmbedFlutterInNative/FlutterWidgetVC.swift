import Foundation
import Flutter
import UIKit

// MARK: - TimerStreamHandler for EventChannel

/// EventChannel 的定时器流处理器
class TimerStreamHandler: NSObject, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    private var timer: Timer?
    private var counter = 0
    
    func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = eventSink
        
        // 启动定时器，每秒发送一次
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.counter += 1
            // 发送数据到 Flutter
            let data: [String: Any] = [
                "count": self.counter,
                "timestamp": Date().timeIntervalSince1970,
                "message": "来自 iOS 的事件 #\(self.counter)"
            ]
            eventSink(data)
        }
        
        print("✅ EventChannel 开始监听")
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        timer?.invalidate()
        timer = nil
        eventSink = nil
        counter = 0
        print("🛑 EventChannel 停止监听")
        return nil
    }
}

// MARK: - FlutterWidgetVC

/// 在 iOS 原生中使用 Flutter Widget 的视图控制器
///
/// 🎯 使用场景：在原生 iOS 应用中嵌入 Flutter 页面
///
/// 适用情况：
/// - 在现有的 iOS 应用中集成 Flutter 页面
/// - 将 Flutter 作为功能模块嵌入到原生应用
/// - 需要在多个地方复用 Flutter UI
///
/// 实现原理：
/// 1. 使用 FlutterEngineGroup 管理多个 FlutterEngine 实例
/// 2. 每个实例可以显示不同的 Flutter 路由
/// 3. 通过共享资源降低内存占用
///
/// 为什么使用 FlutterEngineGroup？
/// - 内存优化：多个 engine 共享 Dart VM、isolate group snapshot 等资源
/// - 启动速度：后续创建的 engine 启动更快
/// - 资源隔离：每个 engine 有独立的路由栈和状态
/// - 适合场景：需要在原生应用中多次使用 Flutter 页面时
class FlutterWidgetVC: UIViewController {
    
    // MARK: - 静态属性
    
    /// FlutterEngineGroup 单例
    /// 
    /// 优点：
    /// 1. 共享 Dart VM：所有 engine 共享同一个 Dart VM，节省内存
    /// 2. 共享资源：共享代码、资源文件等，减少内存占用
    /// 3. 快速创建：第一个 engine 之后的创建速度更快
    /// 4. 隔离性好：每个 engine 有独立的路由和状态
    ///
    /// 对比单个 FlutterEngine：
    /// - 单个 engine：占用约 60-80MB 内存
    /// - 使用 group：第一个约 60MB，后续每个约 10-20MB
    static let engineGroup = FlutterEngineGroup(
        name: "FlutterWidgetVCGroup",
        project: nil
    )
    
    // MARK: - 实例属性
    
    /// 当前控制器使用的 FlutterEngine 实例
    private var engine: FlutterEngine?
    
    /// FlutterViewController 实例
    private var flutterVC: FlutterViewController?
    
    /// 要导航到的 Flutter 路由
    /// 例如："/", "/home", "/canvas_page" 等
    var targetRoute: String = "/"
    
    var channel: FlutterMethodChannel? = nil
    
    // MARK: - 初始化方法
    
    /// 便捷初始化方法
    /// - Parameter route: Flutter 路由路径
    convenience init(route: String) {
        self.init(nibName: nil, bundle: nil)
        self.targetRoute = route
        print("🚀 创建 FlutterWidgetVC (在原生中嵌入 Flutter)，路由: \(route)")
    }
    
    // MARK: - 生命周期
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loadFlutterVC()
    }
    
    // MARK: - 私有方法
    
    /// 加载 Flutter 视图控制器
    private func loadFlutterVC() {
        // 1. 配置 engine 选项
        let options = FlutterEngineGroupOptions()
        options.entrypoint = nil  // 使用默认的 main() 入口点
        options.initialRoute = targetRoute  // 设置初始路由
        
        
        print("📱 开始创建 FlutterEngine...")
        print("   入口点: main()")
        print("   初始路由: \(targetRoute)")
        
        // 2. 从 group 创建新的 engine
        // 这里会复用 group 中的共享资源
        let flutterEngine = Self.engineGroup.makeEngine(with: options)
        self.engine = flutterEngine
        
        // 3. 运行 engine
        // 如果是第一个 engine，会启动 Dart VM
        // 后续的 engine 会复用已启动的 VM
        flutterEngine.run()
        
        print("✅ FlutterEngine 创建完成")
        
        // 4. 创建 FlutterViewController
        let newVC = FlutterViewController(
            engine: flutterEngine,
            nibName: nil,
            bundle: nil
        )
        self.channel = FlutterMethodChannel.init(name: "FlutterNativeBridge", binaryMessenger: newVC.binaryMessenger)
        setupMethod()
        setupEventChannel(controller: newVC)
        // 5. 设置渲染完成回调（可选）
        newVC.setFlutterViewDidRenderCallback { [weak self] in
            print("✅ Flutter 首帧渲染完成")
            // 可以在这里隐藏加载动画等
        }
        
        self.flutterVC = newVC
        
        // 6. 将 Flutter 视图添加到当前视图层级
        addFlutterViewController(newVC)
    }
    private func setupMethod() {
        // ✅ 使用 [weak self] 避免循环引用
        channel?.setMethodCallHandler({ [weak self] call, result in
            guard self != nil else {
                result(FlutterMethodNotImplemented)
                return
            }
            
            let method = call.method
            let arguments = call.arguments
            print("setMethodCallHandler call back：\nmethod: \(method) \narguments: \(arguments)")
            
            if method == "getLocationInfomation" {
                let data: [String: String] = ["lan": "123", "lng": "000"]
                result(data)
                return  // ⚠️ 修复：避免重复调用 result
            }
            
            result("setMethodCallHandler result")
        })
    }
    
    /// 设置 EventChannel
    private func setupEventChannel(controller: FlutterViewController) {
        let eventChannel = FlutterEventChannel(
            name: "FlutterNativeEventChannelBridge",
            binaryMessenger: controller.binaryMessenger
        )
        eventChannel.setStreamHandler(TimerStreamHandler())
    }
    
    /// 添加 Flutter 视图控制器到当前视图层级
    /// - Parameter flutterVC: FlutterViewController 实例
    private func addFlutterViewController(_ flutterVC: FlutterViewController) {
        guard let flutterView = flutterVC.view else {
            print("❌ Flutter 视图为空")
            return
        }
        
        // 设置视图属性
        flutterView.frame = self.view.bounds
        flutterView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // 添加到视图层级
        self.view.addSubview(flutterView)
        
        // 添加为子控制器（重要：确保生命周期正确）
        self.addChild(flutterVC)
        flutterVC.didMove(toParent: self)
        
        print("✅ Flutter 视图已添加到视图层级")
    }
    
    // MARK: - 清理资源
    
    deinit {
        print("🗑️ FlutterWidgetVC 开始销毁，路由: \(targetRoute)")
        
        // 清理视图层级
        if let flutterVC = self.flutterVC {
            flutterVC.willMove(toParent: nil)
            flutterVC.view.removeFromSuperview()
            flutterVC.removeFromParent()
            self.flutterVC = nil
        }
        
        // 清理 channel（避免内存泄露）
        channel?.setMethodCallHandler(nil)
        channel = nil
        
        // ✅ 关键修改：不调用 destroyContext()，让 engine 自然释放
        // 这样 Flutter 的 dispose 有机会执行
        // FlutterEngineGroup 会自动管理资源回收
        self.engine = nil
        
        print("✅ FlutterWidgetVC 销毁完成（engine 将自动释放）")
    }
}

// MARK: - 使用示例

/*
 在 iOS 原生代码中使用 Flutter Widget 的示例：
 
 // 1. 基本使用 - 显示 Flutter 页面
 let flutterVC = FlutterWidgetVC(route: "/home")
 navigationController?.pushViewController(flutterVC, animated: true)
 
 // 2. Modal 展示
 let flutterVC = FlutterWidgetVC(route: "/canvas_page")
 flutterVC.modalPresentationStyle = .fullScreen
 present(flutterVC, animated: true)
 
 // 3. 嵌入到容器中
 let flutterVC = FlutterWidgetVC(route: "/settings")
 addChild(flutterVC)
 containerView.addSubview(flutterVC.view)
 flutterVC.view.frame = containerView.bounds
 flutterVC.didMove(toParent: self)
 
 注意事项：
 - 确保 Flutter 端有对应的路由配置
 - 首次创建会有启动延迟（约 100-300ms）
 - 后续创建速度更快（约 30-50ms）
 - 记得在不需要时释放视图控制器
 */

