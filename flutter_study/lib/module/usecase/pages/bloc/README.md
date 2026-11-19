# Cubit 与 Bloc

从首页「Bloc Demo」进入，路由为 `/bloc`。分别点击两张卡片的加减按钮，观察两个独立计数。

| 模块 | UI 如何表达加减意图 | 状态如何变化 |
| --- | --- | --- |
| Cubit | 调用 `increment()` 或 `decrement()` | 方法中调用 emit 发布加减后的计数 |
| Bloc | 调用 `add(CounterEvent.increment)` 或 `add(CounterEvent.decrement)` | `on<CounterEvent>` 处理事件，再 emit |

两者都用 BlocBuilder 订阅状态，由页面内的 BlocProvider 创建并自动关闭实例。示例是页面局部状态，无需全局注册。

Cubit 适合直接的方法调用，代码量少。Bloc 用显式事件表达意图，便于记录事件、追踪 Transition，以及按需求配置事件处理策略。复杂度取决于业务流程。Bloc 使用 `CounterEvent.increment` 和 `CounterEvent.decrement` 两个枚举值，在 `on<CounterEvent>` 中通过 switch 分别处理，计数允许降到负数。

- [Cubit 卡片](CubitExampleWidget.dart) · [CounterCubit](CounterCubit.dart)
- [Bloc 卡片](BlocExampleWidget.dart) · [CounterBloc 与事件](CounterBloc.dart)

验证时分别增加两组计数，退出重新进入后计数从 0 开始。原来的异步计算演示已移到 [Isolate 实验](../isolate/README.md)。

[CSDN 学习笔记：Cubit 与 Bloc 的区别及选型](CSDN.md)

## 事件追踪与异步策略

Bloc 卡片显示最近的 Transition，包含事件和前后状态。下方四个独立模块展示 concurrent、sequential、droppable、restartable。点击「上传三张照片」比较日志顺序。

新增依赖为官方 bloc_concurrency。异步任务用 Future.delayed 模拟，退出页面时关闭局部 Bloc。[操作及预期结果](CSDN.md)


照片上传示例使用延迟模拟，每张照片分别记录开始与完成。concurrent 同时上传全部照片，sequential 按顺序逐张上传。droppable 会忽略忙碌时提交的照片，restartable 只让最后一个处理器发布完成结果。后两者用于对照策略差异，实际要求全部上传时应采用前两种策略。示例的「已开始」表示观察到开始记录，需结合完成记录判断最终结果。退出页面重新进入可再次运行。
