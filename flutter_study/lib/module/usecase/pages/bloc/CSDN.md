# Flutter 面试入门：Cubit 和 Bloc 有什么区别？用加减计数器理解如何选型

公开面试文章中确实有“Bloc 和 Cubit 有什么区别”这道题。Sudish Kumar 在面试回顾中自述，近期参加约 20 场面试，多次遇到 BLoC 相关问题，并把这个区别列为第二题。这里依据原作者的自述引用题目，下面结合官方文档和本项目代码整理答案。 [面试题出处](https://sudishkumar-edugaon.medium.com/interview-question-from-flutter-bloc-for-beginners-to-experts-830fe09bacb4)

## 先用当前 Demo 看区别

从首页「Bloc Demo」进入 `/bloc`，分别操作两张卡片的加减按钮。两组计数互相独立，都从 0 开始，都能降到负数。

| 操作 | Cubit 卡片 | Bloc 卡片 |
| --- | --- | --- |
| 增加 | 调用 `increment()` | 提交 `CounterEvent.increment` |
| 减少 | 调用 `decrement()` | 提交 `CounterEvent.decrement` |
| 产生新状态 | 方法内调用 emit | 事件处理器内调用 emit |
| 更新界面 | BlocBuilder 订阅计数 | BlocBuilder 订阅计数 |

两者都把业务操作和状态放在独立的 Dart 类里。UI 的入口不同，Cubit 用方法调用表达意图，Bloc 用事件表达意图。 [页面入口](BlocBuilderPage.dart)

## Cubit：直接调用一个方法

```dart
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);

  void decrement() => emit(state - 1);
}
```

`Cubit<int>` 表示状态类型是整数，`super(0)` 设置初始状态。`state` 是当前值，`emit` 发布新值。按钮通过 `context.read<CounterCubit>().increment()` 调用方法，`BlocBuilder<CounterCubit, int>` 接收状态并重建计数文字。减少按钮直接调用 `decrement()`。 [CounterCubit](CounterCubit.dart) · [CubitExampleWidget](CubitExampleWidget.dart)

## Bloc：先提交事件，再处理事件

```dart
enum CounterEvent { increment, decrement }

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<CounterEvent>((event, emit) {
      switch (event) {
        case CounterEvent.increment:
          emit(state + 1);
        case CounterEvent.decrement:
          emit(state - 1);
      }
    });
  }
}
```

`Bloc<CounterEvent, int>` 同时声明了事件类型和状态类型。按钮执行 `context.read<CounterBloc>().add(CounterEvent.increment)`，Bloc 把事件交给注册的处理器，处理器根据事件决定如何更新状态。 [CounterBloc](CounterBloc.dart) · [BlocExampleWidget](BlocExampleWidget.dart)

当前事件只表达加一和减一，用枚举就够了。如果将来要表达“增加指定数量”，可以定义带 `amount` 字段的事件类。选择枚举还是事件类，取决于意图是否需要携带数据。 [Bloc 官方概念说明](https://bloclibrary.dev/bloc-concepts/)

## 什么情况用哪个？

下面的场景选择基于两者的能力，属于选型建议。

| 当前需求 | 可以怎么选 | 原因 |
| --- | --- | --- |
| 计数、切换筛选条件、简单的表单状态 | Cubit | 操作能用几个方法表达，代码直接 |
| 请求数据并展示加载、成功、失败 | Cubit 或 Bloc | 两者都支持异步，按是否需要显式事件和事件处理策略来选 |
| 需要记录哪个用户意图引发了状态变化 | Bloc | 能观察事件及包含事件的 Transition |
| 搜索时只处理最新输入、请求期间忽略重复提交、要求任务依次执行 | Bloc 并配置 transformer | 可以为事件处理器设置相应策略 |
| 一个大型应用中的不同功能 | 按功能分别选择 | 状态数量、文件数量和应用规模只是参考，还要看事件追踪及并发控制需求 |

Cubit 可以使用 async/await，也可以订阅外部 Stream。Bloc 的事件层提供额外的追踪和处理入口。两者都可测试，也可使用 BlocProvider、BlocBuilder 和 BlocListener。 [Bloc 官方对比](https://bloclibrary.dev/bloc-concepts/#cubit-vs-bloc)

## 连续点击时，Bloc 会自动排队吗？

默认事件处理可以并发执行。当前加减处理器都是同步代码，容易观察到连续计数。若处理器中加入网络请求或 await，就要根据业务选择并发策略。

官方的 `bloc_concurrency` 包提供以下策略，需要在事件处理器上显式配置：

| 策略 | 行为 | 场景示例 |
| --- | --- | --- |
| concurrent | 允许并发处理 | 相互独立的任务 |
| sequential | 依次处理 | 必须保持顺序的操作 |
| droppable | 正在处理时忽略新事件 | 忽略重复的加载请求 |
| restartable | 新事件到来时取消旧处理器，处理最新事件 | 搜索输入更新 |

`restartable` 对处理器的取消，底层 HTTP 请求是否停止还取决于请求实现。页面下方提供四张策略卡片，使用官方 `bloc_concurrency` 的真实 transformer。点「上传三张照片」即可对照日志。 [官方事件并发包](https://pub.dev/packages/bloc_concurrency)

## 面试时可以怎样回答？

“Cubit 和 Bloc 都通过状态驱动 UI。Cubit 的入口是方法，比如 increment 和 decrement，方法内 emit 新状态。Bloc 的入口是事件，比如提交 increment 枚举，再由事件处理器 emit。操作简单时我会先用 Cubit。需要明确记录调用意图，或者控制重复事件、任务顺序和最新请求时，我会考虑 Bloc，并按业务配置事件处理策略。两者都支持异步操作。”

上面这段是结合面试题整理的参考回答。面试时可以用本项目的两张计数卡片说明方法调用和事件提交的差别，再补充自己做过的异步场景。

## 在页面里验证事件追踪和并发策略

加减卡片下方显示最近 6 条 Transition，例如 `increment：0 → 1`，表示一次增加意图使状态从 0 变成 1。记录来自 CounterBloc.onTransition。Cubit 的 Change 只有当前和下一个状态，Bloc 的 Transition 还携带触发它的事件。

四张上传卡片各自拥有一个独立 TaskBloc。首次点击「上传三张照片」会提交照片 1、2、3，奇数编号的照片等待 1.2 秒，偶数编号的照片等待 0.3 秒。日志从上往下排列。

| 卡片 | 首次提交三个任务后观察到的结果 |
| --- | --- |
| concurrent | 1、2、3 都开始，2 通常先完成 |
| sequential | 1 完成才开始 2，2 完成才开始 3 |
| droppable | 只有 1 开始和完成，2、3 在忙碌期间被忽略 |
| restartable | 新任务取消旧处理器，只有任务 3 发布完成结果 |

这里用延迟模拟异步请求。restartable 取消后旧 Future 仍可能继续等待，处理器在等待结束时通过 emit.isDone 检查退出。真实网络任务仍需要按请求库的接口取消。

[异步卡片源码](ConcurrencyExampleWidget.dart) · [TaskBloc](TaskBloc.dart)


照片上传示例使用延迟模拟，每张照片分别记录开始与完成。concurrent 同时上传全部照片，sequential 按顺序逐张上传。droppable 会忽略忙碌时提交的照片，restartable 只让最后一个处理器发布完成结果。后两者用于对照策略差异，实际要求全部上传时应采用前两种策略。示例的「已开始」表示观察到开始记录，需结合完成记录判断最终结果。退出页面重新进入可再次运行。
