# PlatformView 参数编码器详解

## 一、creationParamsCodec 的作用

### 1.1 核心概念

`creationParamsCodec` 是用于在 **Flutter 与原生平台之间传递数据** 的编码器（序列化/反序列化工具）。

```
Flutter 端                              iOS/Android 端
  ↓                                        ↓
creationParams (Dart 对象)  →  [编码器]  →  args (原生对象)
  Map<String, dynamic>                    NSDictionary / HashMap
```

### 1.2 为什么需要编码器？

- Flutter 使用 Dart 语言，iOS 使用 Swift/Objective-C，Android 使用 Java/Kotlin
- 不同语言的数据结构不能直接传递
- 需要编码器将数据转换为字节流，再在另一端解码为原生数据结构

---

## 二、StandardMessageCodec 详解

### 2.1 支持的数据类型

`StandardMessageCodec` 是 Flutter 提供的标准编码器，支持以下数据类型：

| Dart 类型 | iOS 类型 | Android 类型 | 说明 |
|-----------|----------|--------------|------|
| `null` | `nil` | `null` | 空值 |
| `bool` | `NSNumber` | `Boolean` | 布尔值 |
| `int` | `NSNumber` | `Integer/Long` | 整数 |
| `double` | `NSNumber` | `Double` | 浮点数 |
| `String` | `NSString` | `String` | 字符串 |
| `Uint8List` | `FlutterStandardTypedData` | `byte[]` | 字节数组 |
| `Int32List` | `FlutterStandardTypedData` | `int[]` | 32位整数数组 |
| `Int64List` | `FlutterStandardTypedData` | `long[]` | 64位整数数组 |
| `Float64List` | `FlutterStandardTypedData` | `double[]` | 浮点数数组 |
| `List` | `NSArray` | `ArrayList` | 列表 |
| `Map` | `NSDictionary` | `HashMap` | 字典/映射 |

### 2.2 使用示例

#### Flutter 端代码

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativeViewExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 创建参数 - 可以传递复杂的数据结构
    final Map<String, dynamic> creationParams = {
      // 基础类型
      'title': 'Native View',           // String
      'count': 42,                       // int
      'isEnabled': true,                 // bool
      'opacity': 0.8,                    // double
      
      // 嵌套 Map
      'config': {
        'backgroundColor': '#FF0000',
        'fontSize': 16,
      },
      
      // List
      'items': ['Item 1', 'Item 2', 'Item 3'],
      
      // 混合类型的 List
      'mixedList': [1, 'text', true, 3.14],
      
      // null 值
      'optionalValue': null,
    };

    return UiKitView(
      viewType: 'my_native_view',
      creationParams: creationParams,
      
      // 使用标准编码器
      creationParamsCodec: const StandardMessageCodec(),
      
      onPlatformViewCreated: (int id) {
        print('Native view created with ID: $id');
      },
    );
  }
}
```

#### iOS 端代码（Swift）

```swift
import UIKit
import Flutter

class MyNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        
        // args 会自动解码为 NSDictionary
        if let params = args as? [String: Any] {
            
            // 读取基础类型
            let title = params["title"] as? String ?? ""
            let count = params["count"] as? Int ?? 0
            let isEnabled = params["isEnabled"] as? Bool ?? false
            let opacity = params["opacity"] as? Double ?? 1.0
            
            // 读取嵌套 Map
            if let config = params["config"] as? [String: Any] {
                let bgColor = config["backgroundColor"] as? String
                let fontSize = config["fontSize"] as? Int
                print("Config: bgColor=\(bgColor), fontSize=\(fontSize)")
            }
            
            // 读取 List
            if let items = params["items"] as? [String] {
                print("Items: \(items)")
            }
            
            // 读取混合类型 List
            if let mixedList = params["mixedList"] as? [Any] {
                print("Mixed list: \(mixedList)")
            }
            
            // 处理 null 值
            let optionalValue = params["optionalValue"]
            if optionalValue is NSNull || optionalValue == nil {
                print("Optional value is null")
            }
            
            print("📦 收到参数：title=\(title), count=\(count)")
        }
        
        return MyNativeView(frame: frame, viewId: viewId, args: args)
    }
    
    // 指定使用的编码器（必须与 Flutter 端一致）
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

class MyNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView
    
    init(frame: CGRect, viewId: Int64, args: Any?) {
        _view = UIView(frame: frame)
        super.init()
        
        // 根据参数配置视图
        if let params = args as? [String: Any] {
            if let config = params["config"] as? [String: Any],
               let bgColorHex = config["backgroundColor"] as? String {
                _view.backgroundColor = UIColor(hexString: bgColorHex)
            }
        }
    }
    
    func view() -> UIView {
        return _view
    }
}

// UIColor 扩展（用于解析十六进制颜色）
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6: // RGB
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: 1
        )
    }
}
```

---

## 三、其他可用的编码器

### 3.1 BinaryCodec

传递原始字节数据，不进行任何序列化。

```dart
UiKitView(
  viewType: 'my_view',
  creationParams: Uint8List.fromList([1, 2, 3, 4]),
  creationParamsCodec: const BinaryCodec(),
)
```

```swift
func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    return FlutterBinaryCodec.sharedInstance()
}

func create(..., arguments args: Any?) -> FlutterPlatformView {
    if let data = args as? FlutterStandardTypedData {
        let bytes = data.data
        print("收到字节数据: \(bytes)")
    }
    // ...
}
```

### 3.2 StringCodec

只传递字符串。

```dart
UiKitView(
  viewType: 'my_view',
  creationParams: "Hello Native",
  creationParamsCodec: const StringCodec(),
)
```

```swift
func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    return FlutterStringCodec.sharedInstance()
}

func create(..., arguments args: Any?) -> FlutterPlatformView {
    if let text = args as? String {
        print("收到字符串: \(text)")
    }
    // ...
}
```

### 3.3 JSONMessageCodec

使用 JSON 格式传递数据（支持的类型比 StandardMessageCodec 少）。

```dart
UiKitView(
  viewType: 'my_view',
  creationParams: {'name': 'Flutter', 'version': 3.0},
  creationParamsCodec: const JSONMessageCodec(),
)
```

```swift
func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    return FlutterJSONMessageCodec.sharedInstance()
}
```

---

## 四、自定义编码器

### 4.1 何时需要自定义编码器？

- 需要传递 StandardMessageCodec 不支持的类型
- 需要特殊的序列化逻辑
- 需要优化传输性能

### 4.2 实现自定义编码器

```dart
import 'dart:typed_data';
import 'package:flutter/services.dart';

// 自定义数据类
class User {
  final String name;
  final int age;
  final String email;
  
  User(this.name, this.age, this.email);
  
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'email': email,
    };
  }
}

// 自定义编码器
class CustomMessageCodec extends StandardMessageCodec {
  const CustomMessageCodec();
  
  @override
  void writeValue(WriteBuffer buffer, dynamic value) {
    if (value is User) {
      // 写入类型标识符（128 以上是自定义类型）
      buffer.putUint8(128);
      // 写入用户数据
      super.writeValue(buffer, value.toMap());
    } else {
      super.writeValue(buffer, value);
    }
  }
  
  @override
  dynamic readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:
        // 读取用户数据
        final map = super.readValueOfType(super.readByte(buffer), buffer) as Map;
        return User(
          map['name'] as String,
          map['age'] as int,
          map['email'] as String,
        );
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

// 使用自定义编码器
class CustomEncoderExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = User('John Doe', 30, 'john@example.com');
    
    return UiKitView(
      viewType: 'my_view',
      creationParams: user,
      creationParamsCodec: const CustomMessageCodec(),
    );
  }
}
```

---

## 五、常见问题与最佳实践

### 5.1 编码器不匹配

**问题**：Flutter 端使用 `StandardMessageCodec`，但 iOS 端使用 `JSONMessageCodec`。

**后果**：数据解析失败，导致崩溃或数据丢失。

**解决方案**：确保两端使用相同的编码器。

```dart
// Flutter 端
creationParamsCodec: const StandardMessageCodec()
```

```swift
// iOS 端
func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    return FlutterStandardMessageCodec.sharedInstance()
}
```

### 5.2 传递大量数据的性能问题

**问题**：通过 creationParams 传递大文件或大量数据。

**解决方案**：
1. 只传递必要的初始化参数
2. 大数据通过 MethodChannel 异步传递
3. 使用文件路径而不是传递文件内容

```dart
// ❌ 不推荐：传递大量数据
final params = {
  'imageData': File('large_image.png').readAsBytesSync(), // 可能几MB
};

// ✅ 推荐：传递文件路径
final params = {
  'imagePath': '/path/to/image.png',
};
```

### 5.3 类型安全

**问题**：原生端类型转换失败。

**解决方案**：使用安全的类型转换和默认值。

```swift
// ❌ 不安全：强制解包可能崩溃
let title = params["title"] as! String

// ✅ 安全：使用可选解包和默认值
let title = params["title"] as? String ?? "默认标题"
```

### 5.4 null 值处理

```dart
// Flutter 端
final params = {
  'optionalValue': null, // 显式传递 null
};
```

```swift
// iOS 端
if let value = params["optionalValue"] {
    if value is NSNull {
        print("值为 NSNull")
    } else {
        print("值为: \(value)")
    }
} else {
    print("键不存在")
}
```

### 5.5 最佳实践总结

1. **使用 StandardMessageCodec**：大多数场景下已经足够
2. **类型明确**：在 Flutter 端使用明确的类型定义
3. **安全转换**：在原生端进行安全的类型转换
4. **参数验证**：在原生端验证参数的有效性
5. **文档注释**：清楚地记录参数结构

```dart
/// 原生视图创建参数
/// 
/// 参数结构：
/// ```dart
/// {
///   'title': String,        // 必需：标题
///   'count': int,           // 必需：计数
///   'config': {             // 可选：配置
///     'color': String,      // 十六进制颜色
///     'fontSize': int,      // 字体大小
///   },
/// }
/// ```
final Map<String, dynamic> creationParams = {
  'title': 'My View',
  'count': 100,
  'config': {
    'color': '#FF0000',
    'fontSize': 16,
  },
};
```

---

## 六、完整工作流程

```
1. Flutter 端
   ↓
   创建 creationParams (Dart 对象)
   ↓
   通过 creationParamsCodec 编码为字节流
   ↓
2. Platform Channel 传输
   ↓
3. iOS 端
   ↓
   通过 createArgsCodec() 解码为原生对象
   ↓
   在 create(..., arguments args) 中接收
   ↓
   类型转换并使用数据
```

---

## 七、调试技巧

### 7.1 打印传递的参数

```dart
// Flutter 端
print('传递参数: $creationParams');
```

```swift
// iOS 端
func create(..., arguments args: Any?) -> FlutterPlatformView {
    print("📦 收到参数类型: \(type(of: args))")
    print("📦 收到参数内容: \(String(describing: args))")
    
    if let dict = args as? [String: Any] {
        for (key, value) in dict {
            print("   \(key): \(value) (类型: \(type(of: value)))")
        }
    }
    // ...
}
```

### 7.2 使用断点

在 Xcode 中设置断点，检查 `args` 参数的实际类型和值。

---

## 八、总结

| 特性 | StandardMessageCodec | JSONMessageCodec | BinaryCodec | StringCodec |
|------|---------------------|------------------|-------------|-------------|
| 支持类型 | 丰富（包括 TypedData） | 基础 JSON 类型 | 字节数组 | 字符串 |
| 性能 | 高 | 中 | 最高 | 高 |
| 使用场景 | 推荐默认使用 | 需要 JSON 互操作 | 传输二进制数据 | 简单字符串 |

**推荐**：在 99% 的场景中，使用 `StandardMessageCodec` 即可满足需求。




