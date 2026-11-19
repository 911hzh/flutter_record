# Flutter Riverpod 入门：从页面状态到业务逻辑拆分

> 本文面向刚接触 Flutter 状态管理的同学。示例基于 `flutter_riverpod 3.x`，并结合官方文档中对 Provider、Ref、ProviderScope、autoDispose、overrides 的说明整理。

## Riverpod 是什么

Riverpod 是 Flutter/Dart 生态里的响应式状态管理和依赖注入框架。官方对它的定位是：一个 reactive caching and data-binding framework，也就是响应式缓存与数据绑定框架。

它可以做几件事：

- 管理页面状态，比如计数器、表单输入、加载状态、错误状态。
- 管理业务逻辑，把 UI 和业务状态拆开。
- 处理异步数据，比如接口请求、缓存、加载中、失败、成功状态。
- 做依赖注入，比如注入 Repository、ApiClient、Storage、配置对象。
- 让多个状态之间建立依赖关系，一个 provider 可以监听另一个 provider。
- 控制 UI 刷新范围，配合 `ref.watch`、`select` 减少不必要 rebuild。

简单理解：Riverpod 可以替代一部分 `setState`、`Provider`、`Bloc/Cubit` 的职责，但它不是只做状态管理，也承担了依赖注入和异步缓存的能力。

## 最小使用步骤

第一步，在 `main.dart` 根部包一层 `ProviderScope`。

```dart
void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
```

官方文档说明，`ProviderScope` 会创建并暴露 `ProviderContainer`，Riverpod 的 provider 状态就存储在这个容器中。没有 `ProviderScope`，Flutter Widget 树里无法使用 Riverpod。

第二步，定义一个 provider。

```dart
final titleProvider = Provider<String>((Ref ref) {
  return 'Riverpod Demo';
});
```

第三步，在 UI 里使用 `ConsumerWidget` 读取 provider。

```dart
class DemoPage extends ConsumerWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.watch(titleProvider);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Text('Hello Riverpod'),
    );
  }
}
```

`ConsumerWidget` 和 `StatelessWidget` 很像，区别是 `build` 方法多了一个 `WidgetRef ref`。通过这个 `ref`，UI 可以读取、监听、刷新 provider。

## 用 State + ViewModel 管理页面状态

如果状态只是一个 `int`，可以直接用 `Notifier<int>`。但真实项目里更常见的是一个页面状态对象，比如同时包含 `count`、`message`、`isLoading`。

建议拆成：

- `State`：只描述页面状态。
- `ViewModel`：处理业务逻辑，修改 state。
- `Page`：只负责 UI 展示和事件触发。

示例：

```dart
final riverProviderViewModelProvider =
    NotifierProvider.autoDispose<RiverProviderViewModel, RiverProviderState>(
  RiverProviderViewModel.new,
);

class RiverProviderState {
  const RiverProviderState({
    required this.count,
    required this.message,
    required this.isLoading,
  });

  const RiverProviderState.initial()
      : count = 0,
        message = '初始化完成',
        isLoading = false;

  final int count;
  final String message;
  final bool isLoading;

  RiverProviderState copyWith({
    int? count,
    String? message,
    bool? isLoading,
  }) {
    return RiverProviderState(
      count: count ?? this.count,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class RiverProviderViewModel extends Notifier<RiverProviderState> {
  @override
  RiverProviderState build() {
    return const RiverProviderState.initial();
  }

  void increment() {
    state = state.copyWith(
      count: state.count + 1,
      message: 'count +1',
    );
  }

  void reset() {
    state = const RiverProviderState.initial();
  }
}
```

页面中使用：

```dart
class RiverProviderPage extends ConsumerWidget {
  const RiverProviderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(riverProviderViewModelProvider);

    return Column(
      children: [
        Text('count: ${state.count}'),
        Text(state.message),
        ElevatedButton(
          onPressed: () {
            ref.read(riverProviderViewModelProvider.notifier).increment();
          },
          child: const Text('count +1'),
        ),
      ],
    );
  }
}
```

这里的重点是：UI 用 `ref.watch` 监听状态变化，按钮点击时用 `ref.read(...notifier)` 调用业务方法。

## ref 常用方法

### ref.watch

`ref.watch` 用来监听 provider。被监听的 provider 状态变化时，当前 Widget 或 provider 会重新计算。

```dart
final state = ref.watch(riverProviderViewModelProvider);
```

适合用在 `build` 方法里展示 UI。

### ref.read

`ref.read` 只读取一次，不监听变化。

```dart
ref.read(riverProviderViewModelProvider.notifier).increment();
```

适合按钮点击、回调事件、一次性调用业务方法。

### ref.listen

`ref.listen` 用来监听状态变化并执行副作用，比如弹 Toast、显示 Dialog、跳转页面。

```dart
ref.listen(riverProviderViewModelProvider, (previous, next) {
  if (next.message == '保存成功') {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('保存成功')),
    );
  }
});
```

它和 `watch` 的区别是：`watch` 用于刷新 UI，`listen` 用于做副作用。

### ref.invalidate

`ref.invalidate` 会让某个 provider 失效，下次读取时重新创建或重新计算。

```dart
ref.invalidate(riverProviderViewModelProvider);
```

适合手动刷新、重置缓存。

### ref.onDispose

`ref.onDispose` 可以在 provider 被销毁时释放资源。

```dart
class SearchViewModel extends Notifier<SearchState> {
  @override
  SearchState build() {
    final controller = TextEditingController();

    ref.onDispose(() {
      controller.dispose();
    });

    return const SearchState.initial();
  }
}
```

官方文档也提到，`onDispose` 可用于取消请求、释放对象等。

### ref.keepAlive

`autoDispose` provider 默认没人监听时会销毁。如果某些结果希望保留，可以使用 `ref.keepAlive()`。

```dart
final userProvider = FutureProvider.autoDispose<User>((ref) async {
  final user = await repository.fetchUser();
  ref.keepAlive();
  return user;
});
```

官方文档给的典型场景是：请求成功后保留结果，请求失败时离开页面再回来可以重新请求。

## 常用 Provider 类型

### Provider

用于只读、同步、不会自己变化的数据。

```dart
final apiClientProvider = Provider<ApiClient>((Ref ref) {
  return ApiClient();
});
```

适合注入 Repository、ApiClient、配置对象。

### FutureProvider

用于一次性的异步读取。

```dart
final userProvider = FutureProvider<User>((Ref ref) async {
  final api = ref.watch(apiClientProvider);
  return api.fetchUser();
});
```

UI 中会拿到 `AsyncValue<User>`，可以处理 loading、error、data。

```dart
final user = ref.watch(userProvider);

return switch (user) {
  AsyncData(:final value) => Text(value.name),
  AsyncError(:final error) => Text('error: $error'),
  _ => const CircularProgressIndicator(),
};
```

### StreamProvider

用于持续变化的数据流，比如 WebSocket、数据库监听、Firebase 实时数据。

```dart
final messageStreamProvider = StreamProvider<List<Message>>((Ref ref) {
  return repository.watchMessages();
});
```

### NotifierProvider

用于同步可变状态，适合页面 ViewModel。

```dart
final counterProvider = NotifierProvider<CounterViewModel, int>(
  CounterViewModel.new,
);

class CounterViewModel extends Notifier<int> {
  @override
  int build() => 0;

  void increment() {
    state++;
  }
}
```

### AsyncNotifierProvider

用于“状态本身需要异步初始化，同时后续还需要被业务方法修改”的场景。

比如：进入页面先加载用户信息，然后页面上还能刷新、保存、提交。

```dart
final profileProvider =
    AsyncNotifierProvider<ProfileViewModel, User>(ProfileViewModel.new);

class ProfileViewModel extends AsyncNotifier<User> {
  @override
  Future<User> build() async {
    return ref.watch(apiClientProvider).fetchUser();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return ref.read(apiClientProvider).fetchUser();
    });
  }
}
```

## 什么场景适合用 Riverpod

适合：

- 页面状态较多，想把 UI 和业务逻辑拆开。
- 有接口请求，需要统一处理 loading/error/data。
- 多个页面共享 Repository、Service、Storage。
- 一个状态依赖另一个状态，比如筛选条件变化后列表自动刷新。
- 想减少 `BlocProvider`、`BlocBuilder`、`MultiProvider` 的层层嵌套。
- 希望测试时可以替换依赖，比如把真实接口替换成 FakeRepository。

不太适合只为了一个非常简单的局部动画或临时 UI 状态而引入。比如一个按钮的展开/收起，只在当前 Widget 内部使用，用 `StatefulWidget` 或 `ValueNotifier` 也可以。

## Riverpod 的原理简单理解

Riverpod 不是把状态挂在 Flutter Widget 树的 `BuildContext` 上，而是把 provider 状态放在 `ProviderContainer` 里。Flutter 项目通常通过 `ProviderScope` 创建这个容器。

可以简单理解为：

```text
ProviderScope
  -> ProviderContainer
      -> 保存 provider 的状态和依赖关系
```

当 UI 调用：

```dart
ref.watch(riverProviderViewModelProvider);
```

Riverpod 会做几件事：

1. 找到当前 Widget 所在的 `ProviderScope`。
2. 在对应的 `ProviderContainer` 中查找这个 provider。
3. 如果 provider 还没有创建，就调用它的创建函数，比如 `RiverProviderViewModel.new`。
4. 执行 `build()` 得到初始 state。
5. 记录当前 Widget 对这个 provider 的依赖。
6. 当 state 改变时，通知依赖它的 UI 重新 build。

如果 provider A 里 `ref.watch(providerB)`，Riverpod 会记录 provider A 依赖 provider B。当 B 改变时，A 会重新计算。这就是官方文档提到的 provider 可以组合、缓存可以自动失效的基础。

## autoDispose 和页面生命周期

普通 provider 默认会跟着 `ProviderScope` 存活。根部 `ProviderScope` 如果在整个 App 生命周期内不销毁，那么普通 provider 的状态也可能一直保留。

页面级状态一般建议使用 `autoDispose`：

```dart
final pageProvider =
    NotifierProvider.autoDispose<PageViewModel, PageState>(
  PageViewModel.new,
);
```

官方文档说明，`autoDispose` 会在 provider 不再被监听时自动释放，典型用途包括：

- 离开页面时重置表单状态。
- 用户离开页面时取消未完成的 HTTP 请求。
- 用户离开再回来时重新请求失败的数据。

注意：如果一个全局 provider 依赖了页面级 provider，它可能会让页面级 provider 继续被监听，从而不释放。因此建议依赖方向保持清晰：

```text
页面级 provider 可以依赖全局 provider
全局 provider 不应该依赖页面级 provider
```

## select：只刷新关心的字段

当 state 是对象时，直接 watch 整个对象：

```dart
final state = ref.watch(pageProvider);
```

只要 state 任何字段变化，当前 Widget 都会 rebuild。

如果只关心 `count`，可以用 `select`：

```dart
final count = ref.watch(
  pageProvider.select((state) => state.count),
);
```

这样只有 `count` 变化时，这块 UI 才会刷新。官方 refs 文档也建议：如果只想监听状态的一部分，可以使用 `select`。

## Riverpod 和 Provider 的比较

### Provider 的特点

`provider` 包官方说明中，它是对 `InheritedWidget` 的封装，让对象暴露、读取、释放更简单。它常见写法是：

```dart
ChangeNotifierProvider(
  create: (_) => CounterModel(),
  child: const CounterPage(),
);
```

UI 中通过：

```dart
final counter = context.watch<CounterModel>();
```

Provider 优点：

- 学习成本低。
- 和 Flutter Widget 树结合直观。
- `ChangeNotifierProvider`、`Consumer`、`Selector` 很容易理解。
- 页面级生命周期比较明显，provider 放在哪个 Widget 子树下，就影响哪个范围。

Provider 不足：

- 依赖 `BuildContext`，有些场景读取不方便。
- 多个依赖容易出现 `MultiProvider`、`ProxyProvider` 配置较多的问题。
- 异步 loading/error/data 需要自己设计状态结构。
- 复杂业务中 `ChangeNotifier` 容易变成一个很大的类。

### Riverpod 的特点

Riverpod 优点：

- 不依赖 `BuildContext` 查找 provider，使用 `Ref` 连接 provider。
- provider 可以放在任何文件中，不强制嵌套在 UI 树里。
- 异步状态有 `AsyncValue`，天然表达 loading/error/data。
- provider 可以相互依赖，依赖变化后自动重新计算。
- 支持 `autoDispose`、`family`、`override`，测试和多环境注入更方便。
- 可以用 `select` 精细控制刷新字段。

Riverpod 需要注意的地方：

- 生命周期不一定天然等于页面生命周期，要正确使用 `autoDispose`。
- provider 全局声明容易让初学者误以为状态也是全局单例，其实状态存在 `ProviderScope` 的容器里。
- 如果依赖方向设计混乱，比如全局 provider 依赖页面 provider，会导致页面状态不按预期释放。
- 对初学者来说，`ProviderScope`、`Ref`、`ProviderContainer`、`override` 这些概念需要时间理解。

一句话总结：

Provider 更像“Widget 树上的依赖暴露工具”；Riverpod 更像“独立于 Widget 树的状态容器 + 依赖注入 + 异步缓存系统”。

## Riverpod、provider、get_it 表格对比

| 对比维度 | Riverpod | provider | get_it |
| --- | --- | --- | --- |
| 核心定位 | 状态管理 + 依赖注入 + 异步缓存 + provider 组合 | 基于 `InheritedWidget` 的依赖暴露工具 | Service Locator / 依赖注入容器 |
| 是否依赖 `BuildContext` | 不依赖，通过 `Ref` / `WidgetRef` 访问 | 依赖，通过 `context.watch/read/select` 访问 | 不依赖，可以在任意 Dart 代码中访问 |
| 状态管理能力 | 强，支持 `NotifierProvider`、`AsyncNotifierProvider`、`FutureProvider`、`StreamProvider` | 中等，常配合 `ChangeNotifier` 管理状态 | 弱，本身不负责 UI 响应式刷新 |
| 依赖注入能力 | 强，通过 `Provider`、`ProviderScope overrides`、`family` 注入和替换依赖 | 中等，通过 Widget 树向下暴露对象 | 强，通过 `registerSingleton`、`registerLazySingleton`、`registerFactory` 注册对象 |
| 异步处理 | 强，`AsyncValue` 天然表达 loading/error/data | 需要自己设计状态，或使用 `FutureProvider` / `StreamProvider` | 本身不处理 UI 异步状态，只负责提供对象 |
| 生命周期 | 由 `ProviderScope`、`autoDispose`、`keepAlive` 控制，灵活但需要理解规则 | 跟 Widget 树关系明显，Provider 在哪个子树就影响哪个范围 | 由注册方式和手动 reset/dispose 控制，偏全局容器思路 |
| UI 刷新控制 | `ref.watch` 监听 provider，`select` 监听局部字段 | `context.watch`、`Consumer`、`Selector` | 不负责刷新 UI，需要搭配 `ValueNotifier`、Bloc、Provider、Riverpod、watch_it 等 |
| 测试替换 | 通过 `ProviderScope(overrides: [...])` 替换依赖 | 可以在测试 Widget 树中换 Provider | 可以 `reset` 后重新注册 mock/fake |
| 优点 | 能力完整；异步友好；依赖可组合；可测试性好；减少 Widget 树嵌套 | 简单直观；学习成本低；和 Flutter Widget 树模型一致 | 简单快速；不依赖 Flutter；任意位置可取对象；适合全局服务注入 |
| 缺点 | 概念多；职责范围宽；生命周期不天然等于页面生命周期；需要团队规范 | 复杂依赖容易嵌套；异步状态要自己组织；依赖 `BuildContext` | 容易被滥用成全局变量中心；依赖关系不够显式；不会自动刷新 UI |
| 适合场景 | 中大型项目、页面状态、异步请求、Repository 注入、需要 provider 组合和缓存的场景 | 中小项目、简单状态、Widget 子树内共享对象、`ChangeNotifier` 模式 | 纯依赖注入、全局服务、Repository、ApiClient、Storage、和 Bloc/Cubit 搭配 |
| 不适合场景 | 只是一点局部 UI 状态时可能显得重；团队没有分层约定时容易混乱 | 复杂异步流、复杂依赖图、大量跨层依赖时维护成本上升 | 单独拿来做响应式状态管理不合适 |
| 推荐理解 | 一个完整的状态和依赖系统 | Widget 树上的对象共享工具 | 全局服务查找器 / DI 容器 |

简单选择可以看这张表：

| 你的需求 | 更推荐 |
| --- | --- |
| 只想在 Widget 子树里共享一个 `ChangeNotifier` | `provider` |
| 只想注册 `ApiClient`、`Repository`、`Storage` 等服务对象 | `get_it` 或 Riverpod 的 `Provider` |
| 页面状态需要 loading/error/data，并且有异步请求 | Riverpod |
| 页面 ViewModel 需要管理状态和业务方法 | Riverpod 的 `NotifierProvider` / `AsyncNotifierProvider` |
| 已经使用 Bloc/Cubit，只缺少依赖注入容器 | `get_it` |
| 希望依赖注入、状态管理、异步缓存都用一套体系 | Riverpod |
| 项目很小，只是几个简单状态 | `setState`、`ValueNotifier` 或 `provider` 就够了 |

## Riverpod 里有哪些注入方式

### 1. 普通 Provider 注入全局服务

```dart
final apiClientProvider = Provider<ApiClient>((Ref ref) {
  return ApiClient(baseUrl: 'https://example.com');
});

final userRepositoryProvider = Provider<UserRepository>((Ref ref) {
  final api = ref.watch(apiClientProvider);
  return UserRepository(api);
});
```

这是最常见的 Repository、Service 注入方式。

### 2. ProviderScope overrides 替换实现

官方文档说明，所有 provider 都可以通过 `ProviderScope` 或 `ProviderContainer` 的 `overrides` 改变行为。常用于测试、调试、多环境配置。

```dart
ProviderScope(
  overrides: [
    apiClientProvider.overrideWithValue(
      ApiClient(baseUrl: 'https://test.example.com'),
    ),
  ],
  child: const App(),
);
```

测试时可以注入 fake：

```dart
ProviderScope(
  overrides: [
    userRepositoryProvider.overrideWithValue(FakeUserRepository()),
  ],
  child: const App(),
);
```

### 3. family 注入参数

页面详情常常需要传 id。可以用 `family`：

```dart
final userDetailProvider =
    FutureProvider.autoDispose.family<User, String>((Ref ref, String userId) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.fetchUser(userId);
});
```

页面使用：

```dart
final user = ref.watch(userDetailProvider(userId));
```

这相当于给 provider 传入一个参数，并且不同参数会有不同缓存。

### 4. 局部 ProviderScope 做局部覆盖

可以在某个页面或某条路由下再包一层 `ProviderScope`，只覆盖当前子树。

```dart
ProviderScope(
  overrides: [
    currentUserIdProvider.overrideWithValue('1001'),
  ],
  child: const UserDetailPage(),
);
```

这种方式适合局部注入页面上下文，但不要滥用。官方文档也说明，scoping 是较高级能力，一般需要谨慎使用。

### 5. Notifier/AsyncNotifier 内部组合依赖

ViewModel 可以通过 `ref.watch` 或 `ref.read` 注入 Repository：

```dart
class ProfileViewModel extends AsyncNotifier<User> {
  @override
  Future<User> build() {
    final repository = ref.watch(userRepositoryProvider);
    return repository.fetchCurrentUser();
  }
}
```

这就是业务逻辑层常用的依赖注入方式。

### 6. Flutter 原生构造函数传参

不是所有东西都必须放进 Riverpod。如果只是一个页面参数，也可以继续用构造函数：

```dart
class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.id});

  final String id;
}
```

简单参数用构造函数更直观；需要缓存、复用、依赖其他服务、异步请求时，再考虑 `family` provider。

## 初学者建议

刚开始使用 Riverpod，可以按这个顺序学：

1. 先会 `ProviderScope`、`ConsumerWidget`、`ref.watch`、`ref.read`。
2. 简单只读对象用 `Provider`。
3. 一次性接口请求用 `FutureProvider`。
4. 页面状态用 `NotifierProvider.autoDispose + State + ViewModel`。
5. 页面参数用 `family`。
6. 只刷新某个字段时用 `select`。
7. 测试或多环境替换依赖时用 `overrides`。

不要一开始就把所有状态都放进 Riverpod。Widget 内部临时状态，仍然可以用 `StatefulWidget`；页面业务状态和跨页面共享状态，再交给 Riverpod。

## 参考资料

- Riverpod 官方首页：https://riverpod.dev/
- Riverpod Providers 文档：https://riverpod.dev/docs/concepts2/providers
- Riverpod Refs 文档：https://riverpod.dev/docs/concepts2/refs
- Riverpod ProviderScope/ProviderContainer 文档：https://riverpod.dev/docs/concepts2/containers
- Riverpod Provider overrides 文档：https://riverpod.dev/docs/concepts2/overrides
- Riverpod Scoping providers 文档：https://riverpod.dev/docs/concepts2/scoping
- flutter_riverpod 3.3.1 README：https://pub.dev/packages/flutter_riverpod
- provider 官方包说明：https://pub.dev/packages/provider
- get_it 官方包说明：https://pub.dev/packages/get_it
