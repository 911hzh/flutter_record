import UIKit
import Flutter

/// iOS 原生 Platform View 实现
/// 
/// 🎯 使用场景：在 Flutter 中嵌入原生 UIView
/// 
/// 这是一个标准的 iOS UIView，通过 FlutterPlatformView 协议桥接到 Flutter
/// Flutter 会调用 view() 方法获取要显示的 UIView
/// 
/// 对应的 Flutter 端组件：
/// - lib/module/platform/flutter_use_native/IOSNativeUIKitView.dart
class IOSNativeView: NSObject, FlutterPlatformView {
    private var _view: CustomNativeView
    
    /// 初始化方法
    /// - Parameters:
    ///   - frame: Flutter 传递的初始尺寸（通常是 0，真实尺寸会在 layoutSubviews 中获取）
    ///   - viewId: Flutter 分配的唯一视图 ID
    ///   - args: Flutter 传递的创建参数（对应 Flutter 端的 creationParams）
    init(
        frame: CGRect,
        viewId: Int64,
        args: Any?,
        messenger: FlutterBinaryMessenger
    ) {
        print("🔵 IOSNativeView 初始化")
        print("   初始 frame: \(frame)")
        print("   viewId: \(viewId)")
        print("   参数: \(args ?? "nil")")
        
        let params = args as? [String: Any] ?? [:]
        _view = CustomNativeView(
            frame: frame,
            viewId: viewId,
            args: params,
            messenger: messenger
        )
        super.init()
    }
    
    /// Flutter 引擎调用此方法获取要显示的 UIView
    func view() -> UIView {
        return _view
    }
}

// MARK: - 自定义原生视图

/// 自定义的 UIView，用于展示原生 UI
/// 
/// 💡 这就是实际显示的 iOS 原生组件
/// 你可以在这里使用任何 UIKit 组件：UILabel、UIButton、UIImageView 等
/// 
/// 重点：
/// - layoutSubviews 方法会在布局确定后调用，这里能获取到真实的尺寸
/// - 可以在这里实现任何原生 UI 效果
class CustomNativeView: UIView {
    private var label: UILabel!
    private var debugLabel: UILabel!
    private let args: [String: Any]
    private let viewId: Int64
    private let eventChannel: FlutterMethodChannel
    private var tapCount: Int = 0
    
    init(
        frame: CGRect,
        viewId: Int64,
        args: [String: Any],
        messenger: FlutterBinaryMessenger
    ) {
        self.viewId = viewId
        self.args = args
        self.eventChannel = FlutterMethodChannel(
            name: "native_gesture_overlap_view_\(viewId)",
            binaryMessenger: messenger
        )
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBlue
        
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        addSubview(label)
        
        debugLabel = UILabel()
        debugLabel.numberOfLines = 0
        debugLabel.textAlignment = .center
        debugLabel.textColor = UIColor.white.withAlphaComponent(0.92)
        debugLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        addSubview(debugLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(panGesture)
        
        updateDebugText("等待手势")
    }
    
    /// 布局更新回调
    /// 在这里可以获取到 Flutter 传递的真实尺寸
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = bounds.size.width
        let height = bounds.size.height
        
        print("✅ layoutSubviews - 真实尺寸: \(width) x \(height)")
        
        label.frame = CGRect(x: 16, y: 16, width: width - 32, height: max(120, height * 0.55))
        debugLabel.frame = CGRect(
            x: 16,
            y: max(140, height * 0.62),
            width: width - 32,
            height: height - max(156, height * 0.62) - 12
        )
        
        let title = (args["title"] as? String) ?? "iOS 原生 UIView"
        label.text = """
        \(title)
        用 Swift/UIKit 实现
        
        宽度: \(Int(width)) pt
        高度: \(Int(height)) pt
        
        viewId: \(viewId)
        点击或拖动这里
        """
    }
    
    @objc
    private func handleTap(_ recognizer: UITapGestureRecognizer) {
        guard recognizer.state == .ended else { return }
        tapCount += 1
        let point = recognizer.location(in: self)
        let message = "tap #\(tapCount) @ (\(Int(point.x)), \(Int(point.y)))"
        updateDebugText(message)
        sendEvent(type: "tap", state: "ended", point: point)
    }
    
    @objc
    private func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let point = recognizer.location(in: self)
        let state: String
        
        switch recognizer.state {
        case .began:
            state = "began"
        case .changed:
            state = "changed"
        case .ended:
            state = "ended"
        case .cancelled:
            state = "cancelled"
        case .failed:
            state = "failed"
        default:
            return
        }
        
        updateDebugText("pan \(state) @ (\(Int(point.x)), \(Int(point.y)))")
        sendEvent(type: "pan", state: state, point: point)
    }
    
    private func updateDebugText(_ text: String) {
        debugLabel.text = "Native 手势\n\(text)"
    }
    
    private func sendEvent(type: String, state: String, point: CGPoint) {
        let event: [String: Any] = [
            "source": "native",
            "type": type,
            "state": state,
            "x": Int(point.x),
            "y": Int(point.y),
            "viewId": viewId
        ]
        
        eventChannel.invokeMethod("onNativeGesture", arguments: event)
    }
}

