# Flutter Key 入门：为什么交换了 A 和 B，颜色和计数却留在原位？

打开 Flutter Study 首页的 **Key Page**（`/key_page`）。页面有两组相同的色块，初始都是红色 A、蓝色 B。分别点两组的 A 一次，再点「交换顺序」。

| 分组 | 交换前，从左到右 | 交换后，从左到右 |
| --- | --- | --- |
| 无 Key | 红色 A（1 次）、蓝色 B（0 次） | **红色 B（1 次）**、蓝色 A（0 次） |
| 稳定 `ValueKey` | 红色 A（1 次）、蓝色 B（0 次） | 蓝色 B（0 次）、**红色 A（1 次）** |

两组的字母都从 `A、B` 变成了 `B、A`，说明 **Widget 的顺序已经交换**。区别在于无 Key 组的颜色和计数留在原来的位置，带 `ValueKey` 的一组则让颜色和计数跟着 A、B 移动。 [页面源码](KeyPage.dart) · [色块源码](ColorView.dart)

## Key 是什么？

可以把这三个概念放在一起理解：

- **Widget** 是界面的配置。本例里，`ColorStateFullView(id: 0)` 就是一份配置，它的 `id` 决定显示 A。
- **Element** 是 Flutter 在树中用来管理这份配置的节点。父组件重建时，Flutter 会判断旧节点能否用新的 Widget 配置更新。
- **State** 存着组件自己的状态。本例的颜色 `_color` 和点击次数 `_taps` 都存在 State 里。复用 StatefulWidget 对应的 Element 时，原来的 State 会继续使用。

**Key 帮 Flutter 识别新配置对应旧树里的哪个节点。** 两份 Widget 配置的 `runtimeType` 和 `key` 都相等时，`Widget.canUpdate` 才允许用新配置更新旧节点。对于本例中两个同类型、没有 Key 的兄弟组件，两者的 Key 都是 `null`，Flutter 就按位置复用。 [Flutter 官方文档 · Key](https://api.flutter.dev/flutter/foundation/Key-class.html) · [Widget.canUpdate](https://api.flutter.dev/flutter/widgets/Widget/canUpdate.html)

## 常用 Key 有哪些，怎么选？

`LocalKey` 和 `GlobalKey` 是两类。常用的 `ValueKey`、`ObjectKey`、`UniqueKey` 和 `PageStorageKey` 都属于 `LocalKey`，用于区分同一父节点下的兄弟组件。 `GlobalKey` 的唯一性范围是整个应用。

| Key | 如何判断身份 | 什么时候用 |
| --- | --- | --- |
| [`ValueKey<T>`](https://api.flutter.dev/flutter/foundation/ValueKey-class.html) | 比较传入的值，例如整数或字符串 ID | 可排序或可增删的列表。商品从接口重新加载后，只要 ID 相同，仍能在匹配时识别为同一项 |
| [`ObjectKey`](https://api.flutter.dev/flutter/widgets/ObjectKey-class.html) | 比较是否为同一个对象实例（`identical`） | 列表始终复用同一批模型对象，且用对象本身作为身份。重新创建模型对象会改变匹配结果 |
| [`UniqueKey`](https://api.flutter.dev/flutter/foundation/UniqueKey-class.html) | 每次创建都得到新的身份 | 希望显式重置某个子组件的本地状态时，给它换一个新的 `UniqueKey()`。要让它跨重建保持身份，就复用同一个 Key 实例 |
| [`PageStorageKey<T>`](https://api.flutter.dev/flutter/widgets/PageStorageKey-class.html) | 用稳定的值和祖先的 `PageStorageKey` 路径定位存储位置 | 同一 `PageStorage` 下，为多个 Tab 的列表分别保存滚动位置。能恢复的是写入 `PageStorage` 的数据，例如滚动偏移 |
| [`GlobalKey<T>`](https://api.flutter.dev/flutter/widgets/GlobalKey-class.html) | 在应用内唯一标识一个节点 | 用 `GlobalKey<FormState>` 调用表单的 `validate()`，或在同一帧内把子树移到另一个父节点并保留 State。通常将 Key 保存在持有者的 State 中 |

列表重排时，常见写法是给 **实际参与排序的那一层**加 `ValueKey(item.id)`。比如 `Row.children` 里交换的是两个 `Padding`，Key 应放在这两个 `Padding` 上。如果用 `ValueKey(index)`，索引仍对应原来的位置，交换数据后就无法用它识别原来的项目。 [Flutter 官方文档 · Widget.key](https://api.flutter.dev/flutter/widgets/Widget/key.html)

## 当前 Demo 为什么交换后会串状态？

`KeyPage` 提前创建两组 `ColorStateFullView`。点击「交换顺序」后，两组都直接调换自己原有的 Widget 实例。以无 Key 组为例：

```dart
_unkeyedItems = [_unkeyedItems[1], _unkeyedItems[0]];
```

`ColorStateFullView` 的字母在 `build()` 中通过当前的 `widget.id` 计算。颜色只在 `initState()` 中初始化，之后和点击次数一起留在 State 里。

1. **无 Key 组**。第一个位置原来是 A，现在送来 B。它们都是 `ColorStateFullView`，Key 都是 `null`，所以 Flutter 用 B 的配置更新第一个位置已有的节点。这个位置的 State 还保有红色和 1 次点击，界面就显示「红色 B · 1 次」。第二个位置同理。
2. **稳定 `ValueKey` 组**。A 带 `ValueKey(0)`，B 带 `ValueKey(1)`。父节点更新子列表时，能按 Key 找到对应的旧节点并移动它。因此，A 到右边时仍使用它原来的 State，显示「红色 A · 1 次」。

即使交换的是**同一批 Widget 实例**，State 的归属依然由 Flutter 的节点匹配决定。再点「普通重建」，两组的顺序和 Key 都保持原样，颜色和计数也都保留。 [Flutter 官方实现 · Element.updateChildren](https://api.flutter.dev/flutter/widgets/Element/updateChildren.html)
