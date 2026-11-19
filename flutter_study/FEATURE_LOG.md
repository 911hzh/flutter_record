# 功能记录

本文档用于记录当前项目新增或调整的功能。

## 使用规则

每次新增功能、调整功能入口、接入第三方 SDK、增加页面或新增共享能力后，都建议在本文档追加一条记录。

## 功能列表

### 下拉返回后页面响应修复

- 动画页拖动改为累计 delta，支持取消后复位，移除未闭合的 Navigator 手势通知。下拉页路由设置 opaque: false，让拖动空隙展示上一页。
- 验证下拉成功后再次打开、按钮返回、短距离拖动及取消。测试位于 animation/animate_second_page_test.dart。

### 首页入口英文命名

- 首页 PageList 的入口名称统一使用英文，同步路由测试中的菜单标签。
- 验证启动和首页路由导航。

### 动画与重绘隔离分目录

- 动画转场页面放回 animation，repaintboundary 保留重绘隔离页面及文档。
- 首页「动画与页面转场」入口置前，路由仍使用 /animate。无需新增依赖。
- 通过两个主题入口的路由测试验证导航。

### RepaintBoundary 主题目录整理

- animation 目录改为 repaintboundary，重绘隔离主页面改名 RepaintBoundaryPage。
- 同步首页名称、源码引用和文档入口，重绘隔离路由使用 `/repaintboundary`。
- 通过路由测试验证入口，实际重绘次数需运行页面观察日志。

### Riverpod 与本地存储 Demo 导入

- 从 flutter_demo_study 复制 riverprovider 和 storage 到 pages，调整包路径，添加首页及路由入口。首页前两项依次为 Riverpod 基础用法、本地存储对比，按根 AGENTS.md 的新增入口置前规则排列。
- Riverpod 使用局部 ProviderScope，Hive 在 main 初始化并注册对象适配器。两页使用主题卡片展示，计数突出显示，存储页提供可展开的对象预览与独立读取结果区域。
- 安装原示例所需依赖。验证入口和静态分析，平台存储读写需要设备验收。

### Bloc 事件追踪与并发策略

- `/bloc` 显示加减事件的 Transition，新增四种 transformer 的异步任务对照卡片。
- 使用官方 bloc_concurrency，卡片管理各自局部 Bloc，无需全局注册。
- 测试核对事件轨迹与四种执行顺序，说明见 [Bloc 学习笔记](lib/module/usecase/pages/bloc/CSDN.md)。

### Cubit、Bloc 与独立 Isolate 实验

- `/bloc` 用两个独立计数模块对比方法调用与事件提交，页面级 BlocProvider 管理生命周期。
- 新增首页入口 `/isolate`，演示 Isolate.run、compute、运行状态、结果和界面响应。
- 说明见 [Bloc](lib/module/usecase/pages/bloc/README.md) 和 [Isolate](lib/module/usecase/pages/isolate/README.md)。均使用已有依赖与页面局部状态。
- 验证覆盖计数交互、结果计算和路由。真实设备的 UI 响应需运行页面观察。

### Key 列表重排对照

- `/key_page` 同时展示无 Key 与稳定 `ValueKey` 的列表，直接交换预先创建的 Widget 实例，对比重排和普通重建时颜色及计数的归属。
- 沿用现有路由和依赖。源码与操作步骤见 [Key 与 BLoC](lib/module/usecase/pages/widget_keys/README.md)。

### iOS 原生 ViewController 演示

- Flutter 首页的「原生ViewController」入口通过现有 `FlutterNativeBridge` 直接弹出 iOS 原生页面。`ios/Runner/EmbedFlutterInNative/NativeDemoViewController.swift` 提供「打开 Flutter 页面」和「向 Flutter 获取数据」两个按钮。
- 前者用 `FlutterWidgetVC` 打开 `/native_use_flutter_page`，后者通过现有消息通道发送 `GETFlutterDataMsg` 并弹窗显示返回值。无需新增依赖。
- 在 iOS 模拟器点击首页入口，检查原生页面标题、两个按钮的行为及关闭后返回首页。

### HitTestBehavior 对照实验

- 首页「Hitest Page」通过 `/hitest_page` 打开，上层可切换三种 `HitTestBehavior`，页面显示最近一次指针按下的接收顺序。
- 沿用现有路由和 Flutter 组件，无需新增依赖。分别点击上层空白、上层子组件和下层独占区，对照 [预期结果](lib/module/usecase/pages/hit_test/README.md)。
