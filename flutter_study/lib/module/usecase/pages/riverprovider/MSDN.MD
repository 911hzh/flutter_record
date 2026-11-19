# Riverpod 初学者面试笔记

公开面试题库中能找到 Riverpod 与 Provider 的区别，以及状态管理选型的问题。以下根据这些题目组织学习顺序，答案结合官方文档与本项目实现整理。出处是公开题库，面试提问频率没有统计。 [公开题库](https://medium.com/@ashfaque-khokhar/200-flutter-interview-questions-all-experience-levels-77bda4cfcd20)

## Riverpod 是什么，能做什么？

Riverpod 是 Dart/Flutter 的状态管理与依赖组织工具。Provider 描述数据或依赖怎样创建，Ref 用来读取、订阅和组合它们。Flutter 中通过 ProviderScope 提供容器，实际状态由容器管理。多个组件可以订阅同一份状态，状态变化后更新相关界面。 [官方 Providers 文档](https://riverpod.dev/docs/concepts2/providers)

例如购物车数量同时出现在商品页和购物车图标上，把数量放在 provider 管理的状态里，就能让两个位置读取同一份数据。相互依赖的配置、服务与异步数据也可以通过 provider 组合。

## 它解决什么问题，原理是什么？

多层传递参数时，深层组件很难访问共享状态。Riverpod 用 Ref 读取依赖，并记录 watch 建立的订阅关系。状态变化时，依赖它的 provider 或组件会更新。

当前页面使用路由局部的 ProviderScope。页面离开后该作用域销毁，再次进入会重新开始。顶层定义的 provider 是声明，状态保存在容器里，同一个声明可以在不同容器中拥有不同状态。 [官方容器说明](https://riverpod.dev/docs/concepts2/containers)

## watch、read、select 怎么区分？

| 写法 | 含义 | 当前 Demo 的位置 |
| --- | --- | --- |
| ref.watch(provider) | 获取数据并订阅变化 | 页面读取标题与完整状态 |
| ref.read(provider.notifier) | 获取 Notifier，用于发起操作 | 按钮调用加减、重置及异步刷新 |
| ref.watch(provider.select(...)) | 只订阅选中的值 | TextWidget 只读取 count |
| ref.listen(provider, ...) | 监听变化并执行副作用 | 可用于弹提示或导航，本 Demo 尚未展示 |

watch 建立响应式依赖，read 适合事件回调中的一次读取。select 比较选出的值是否变化，因此所选数据应保持不可变，更新时产生新值。 [官方 Ref 文档](https://riverpod.dev/docs/concepts2/refs) · [官方 select 说明](https://riverpod.dev/docs/how_to/select)

## Provider、NotifierProvider、FutureProvider 怎么选？

只读的同步依赖可以用 Provider。存在加减、重置等主动操作时，可以用 NotifierProvider。只读异步数据可用 FutureProvider，UI 根据 AsyncValue 显示加载、数据或错误。异步数据还有主动修改流程时，可以考虑 AsyncNotifierProvider。 [官方 Providers 文档](https://riverpod.dev/docs/concepts2/providers)

当前 Demo 的标题用 Provider，计数用 NotifierProvider。异步刷新是 Notifier 的 async 方法，状态里用 isLoading 和 message 表示过程。异步卡片对应 Notifier 的异步方法，FutureProvider 属于可进一步学习的用法。 [ViewModel](RiverProviderViewModel.dart) · [页面](RiverProviderPage.dart)

## autoDispose 为什么有用？

离开某个功能后，不再使用的状态可以释放。当前计数 provider 使用 autoDispose，长期没有监听者时可以销毁状态。异步操作完成前，所属 provider 可能已经销毁，所以代码在 await 后检查 ref.mounted，再更新状态。 [官方自动销毁说明](https://riverpod.dev/docs/concepts2/auto_dispose)

## 与 Provider 的区别怎么回答？

两者都能共享状态和组织依赖。Provider 通常通过 BuildContext 在 Widget 树中查找对象，ChangeNotifier 调用 notifyListeners 通知订阅者。Riverpod 通过 Ref 读取声明，借助容器和依赖图管理状态，可以在纯 Dart 的 ProviderContainer 中测试，也能用 overrides 替换依赖。实际选型还要看项目已有约定与团队熟悉程度。 [Riverpod 官方入门](https://riverpod.dev/docs/introduction/getting_started)

## 用当前页面验证

分别点击 count +1、count -1 和重置，观察 count 和提示文字。点击异步刷新，观察加载状态。刷新期间返回首页，再进入，检查状态重新初始化。

进一步学习可阅读同目录的 [RiverProvider.md](RiverProvider.md)。该文档还介绍 family、overrides 等扩展内容，当前页面覆盖的操作以源码为准。
