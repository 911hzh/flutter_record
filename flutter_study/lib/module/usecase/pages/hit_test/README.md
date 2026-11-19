# HitTestBehavior 命中测试

在首页打开「Hitest Page」，对应路由 `/hitest_page`。

## Container：文字周围的留白

每个边框都标出一个 `Container` 的完整范围，包含文字和周围的 `Padding`。先点击两个示例里的文字，两边都会计数。再点击边框内的留白，只有标着 `opaque` 的示例会计数。边框和底色在 `Listener` 外部绘制。

## Listener：叠层命中

默认使用 `opaque`。先点击「上层空白区」，观察只有上层收到 `PointerDown`。再切换模式并点同一位置，对比结果。

橙色是下层独占区，浅蓝色标出上层空白区，深蓝色是上层子组件。

| 点击区域 | `deferToChild` | `opaque` | `translucent` |
| --- | --- | --- | --- |
| 上层空白区 | 下层 | 上层 | 上层 → 下层 |
| 上层子组件 | 上层 | 上层 | 上层 |
| 下层独占区 | 下层 | 下层 | 下层 |

边框和「上层空白区」标签由下层绘制，上层只有居中的有色子组件。点击上层空白时，`opaque` 让上层 `Listener` 自身命中，`Stack` 随即停止检查下层。点中上层的有色子组件时，`Stack` 找到命中目标后就会停止检查下层，所以此时 `translucent` 也只会触发上层。

## 代码

- [HitestPage.dart](HitestPage.dart)
