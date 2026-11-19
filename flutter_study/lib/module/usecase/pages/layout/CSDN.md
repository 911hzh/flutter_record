# Flutter 入门：Row 里的长文字为什么不换行？用 Expanded 解决布局溢出

从项目首页打开 **Expanded View**（`/expanded`）。上下两张卡片用了同一段长文字、同一个图标和同样的间距。屏幕较窄时，上面的「无 Expanded」会在右侧出现黄黑条纹，下面的「有 Expanded」会正常换行。黄黑条纹是调试模式下的溢出提示，控制台通常会显示类似 `A RenderFlex overflowed by ... pixels on the right` 的信息。 [页面源码](ExpandedPage.dart) · [Flutter 官方文档 · Row](https://api.flutter.dev/flutter/widgets/Row-class.html)

## 直接把 Text 放在 Row 里会发生什么？

取出上方卡片的核心代码：

```dart
Row(
  children: [
    const Icon(Icons.notes, size: 20),
    const SizedBox(width: 8),
    Text(text),
  ],
)
```

Flutter 布局时，父组件把尺寸约束传给子组件，子组件在约束内决定自己的尺寸。这里要看两份约束：**卡片给 Row 的宽度约束**，以及 **Row 给 Text 的宽度约束**。

假设卡片留给这行的宽度是 **200 个逻辑像素**。`Row` 测量普通子组件时，给每个子组件的横向最大宽度都是无穷。图标用了 20，间距用了 8，但普通 `Text` 测量时依然没有宽度上限。假设整段文字单行需要 300，它就可以把文字排成一行。

最后 `Row` 发现子组件合计需要 `20 + 8 + 300 = 328`，自己只有 200，于是溢出 128。它不会回头按 172 的宽度重新测量文字。 [无 Expanded 示例](WithoutExpandedWidget.dart) · [Flutter 官方文档 · Row 布局算法](https://api.flutter.dev/flutter/widgets/Row-class.html#layout-algorithm)

## 加上 Expanded，文字为什么会换行？

下方卡片只需要把文字包进 `Expanded`：

```dart
Row(
  children: [
    const Icon(Icons.notes, size: 20),
    const SizedBox(width: 8),
    Expanded(child: Text(text)),
  ],
)
```

`Row` 先测量图标和间距，再分配剩余空间。这里只有一个 `Expanded`，所以它分到 `200 - 20 - 8 = 172` 个逻辑像素。它的子组件收到的最小宽度和最大宽度都是 172。默认允许换行的 `Text` 就会按 172 的宽度排版，放不下的内容移到下一行。

| 对照 | Text 拿到的最大宽度 | 本例的表现 |
| --- | --- | --- |
| 直接写 `Text(text)` | 无上限 | 排成一行，超出 Row 时触发溢出 |
| 写 `Expanded(child: Text(text))` | 172 个逻辑像素 | 在剩余宽度内自动换行 |

这里的 200 和 172 是便于理解的示例值，实际宽度取决于设备和卡片内边距。 [有 Expanded 示例](WithExpandedWidget.dart) · [Flutter 官方文档 · Expanded](https://api.flutter.dev/flutter/widgets/Expanded-class.html)

## 如果想保留一行并显示省略号

先给文字有限的宽度，再指定显示一行：

```dart
Expanded(
  child: Text(
    text,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  ),
)
```

`Expanded` 给文字分配宽度，`maxLines` 限制行数，`TextOverflow.ellipsis` 决定放不下的文字如何显示。当前 Demo 的普通 `Text` 收到的横向约束没有上限。只加 `ellipsis` 时，整段文字仍能在布局时排成一行，`Row` 依然可能溢出。 [Flutter 官方文档 · Text.overflow](https://api.flutter.dev/flutter/widgets/Text/overflow.html)

## 把 Row 放进 Overlay 能解决吗？

`Overlay` 用来叠放界面内容，例如浮层菜单。把这张卡片放进 `Overlay` 后，若卡片仍给 `Row` 同样的有限宽度，长文字仍然会溢出。判断时看实际传到 `Row` 和 `Text` 的宽度约束。 [Flutter 官方文档 · Overlay](https://api.flutter.dev/flutter/widgets/Overlay-class.html)
