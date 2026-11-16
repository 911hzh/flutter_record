# Flutter 自定义转场动画 - CustomBackGestureTransition

这是一个完整的iOS风格手势返回+共享元素转场动画封装。

## 📁 目录结构

```
transition/
├── CustomBackGestureTransition/    # 核心封装（可直接复制到你的项目）
│   ├── CustomBackGestureController.dart      # 手势控制器
│   ├── CustomBackGesturePageRoute.dart       # 自定义路由
│   └── CustomBackWrapperView.dart            # 手势识别视图
└── page/                           # Demo示例
    ├── MindSpaceHomePage.dart               # 首页（列表）
    ├── MindSpaceFocusDetailPage.dart        # 详情页
    └── FocusItemView.dart                   # 卡片组件
```

## 🚀 快速开始

### 基础用法

```dart
import 'package:flutter_study/module/transition/CustomBackGestureTransition/CustomBackGesturePageRoute.dart';

// 最简单的使用方式
void navigateToDetail(BuildContext context) {
  final route = CustomBackGesturePageRoute(
    title: "DetailPage",
    builder: (context) => DetailPage(),
  );
  Navigator.of(context).push(route);
}
```

### 运行Demo

在项目根目录执行：

```bash
# 运行到iOS模拟器（推荐，效果最好）
flutter run -d iPhone

# 或运行到Android
flutter run
```

然后在应用中找到并打开 `MindSpaceHomePage` 即可看到完整的转场效果。

## ✨ 核心特性

- ✅ **iOS风格手势返回**: 从屏幕左侧边缘滑动返回
- ✅ **自定义转场动画**: 完全控制页面进入/退出动画
- ✅ **共享元素转场**: 元素从列表到详情的平滑过渡
- ✅ **双向动画控制**: 同时控制当前页和被覆盖页的动画
- ✅ **灵活的动画构建器**: 支持完全自定义的动画效果

## 📖 使用文档

详细的使用文档和实现原理请查看：

**[Flutter自定义转场动画-实现iOS风格手势返回与共享元素转场.md](../../Flutter自定义转场动画-实现iOS风格手势返回与共享元素转场.md)**

这篇文章包含：
- 完整的技术架构设计
- 详细的代码实现解析
- 实战案例演示
- 常见问题解决方案
- 性能优化建议

## 🎯 Demo效果说明

### MindSpaceHomePage → MindSpaceFocusDetailPage

**效果流程：**
1. 点击列表中的卡片
2. 卡片从当前位置平滑展开到全屏
3. 同时播放：位置、大小、透明度、背景等多个动画
4. 列表页缩小淡出
5. 支持手势返回，动画完美反向播放

**技术亮点：**
- 使用 `GlobalKey` 精确定位元素位置
- 组合多个 `Tween` 实现复杂动画
- 使用 `Interval` 控制动画时序
- `useMemoized` 优化性能

## 🛠️ 集成到你的项目

### 方法1: 直接复制文件

将 `CustomBackGestureTransition` 文件夹复制到你的项目中：

```
your_project/
└── lib/
    └── utils/  (或其他目录)
        └── CustomBackGestureTransition/
            ├── CustomBackGestureController.dart
            ├── CustomBackGesturePageRoute.dart
            └── CustomBackWrapperView.dart
```

同时需要复制基类：

```
your_project/
└── lib/
    └── utils/
        └── CustomTransitionPageRoute.dart
```

### 方法2: 作为子模块

如果你的项目使用git，可以将这个模块作为子模块添加：

```bash
git submodule add <repo-url> lib/modules/transition
```

## 📦 依赖项

核心代码只依赖Flutter SDK，无需额外依赖。

Demo示例使用了 `flutter_hooks`，如果你要运行Demo，请添加：

```yaml
dependencies:
  flutter_hooks: ^0.20.0
```

## 🤝 贡献

欢迎提交Issue和Pull Request！

## 📄 许可证

本代码遵循 MIT License。

