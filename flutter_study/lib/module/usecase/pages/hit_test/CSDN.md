# Flutter 点击文字有反应，点击 Padding 没反应？从源码看 HitTestBehavior.opaque

本文的上层和下层是同一个父组件下、在画面上重叠的两个同级组件。

- **上层**是后绘制、盖在前面的同级组件。
- **下层**是先绘制、位于后面的同级组件。

根组件是组件树的起点。本文的上下层由共同的父组件管理，命中测试先检查上层。

## 一、面试题与参考答案

### 1. 为什么点文字能响应，点 Padding 的留白却没反应？

`Padding` 扩大了布局范围。点在留白时没有命中子组件，使用 `deferToChild` 的组件也就收不到这次按下。把 `Padding` 放在负责处理事件的组件内部，再设置 `behavior: HitTestBehavior.opaque`，整个布局范围就能响应。

### 2. 两个同级组件重叠，点上层空白，谁收到事件？

假设这次按下位于上层范围内，上层子组件均未命中，且下层能命中这个位置。

`deferToChild` 只有下层收到，`opaque` 只有上层收到，`translucent` 上下两层都收到。

**追问：`translucent` 总能让下层收到事件吗？** 如果上层的子组件已经命中，上层会返回 `true`。在本文的叠层示例里，父组件因此停止检查下层。

### 3. 为什么给 Container 设置 Colors.transparent 后，留白也能响应？

`Container` 收到非空的 `color` 时，会在 `Padding` 外包一层 `ColoredBox`。它的渲染对象使用 `opaque`，所以点击留白也会命中它，使用 `deferToChild` 的父组件也能收到事件。颜色的透明度影响绘制。

### 4. 父子组件都命中时，两个 GestureDetector 的 onTap 都会触发吗？

两者都可以收到原始指针事件。如果它们的识别器竞争同一个 tap，通常只有胜出的识别器触发 `onTap`。本文的示例用 `Listener.onPointerDown` 直接观察原始指针事件。

## 二、HitTestBehavior 是什么？

`HitTestBehavior` 是 Flutter 的命中测试策略。你可以通过 `Listener.behavior` 或 `GestureDetector.behavior` 设置它。手指按下时，Flutter 先根据坐标找出会收到这次指针事件的对象，再沿命中路径派发事件。这个属性决定一个组件怎样参与这次命中测试。

### 它怎样决定谁收到事件？

源码里，`result.add(...)` 把当前组件加入命中路径，`return hitTarget` 把结果交给父组件。在本文的叠层示例中，父组件收到 `false` 就继续检查下层。

[RenderProxyBoxWithHitTestBehavior.hitTest 和 hitTestSelf](https://github.com/flutter/flutter/blob/00b0c91f06209d9e4a41f71b7a512d6eb3b9c694/packages/flutter/lib/src/rendering/proxy_box.dart#L182-L195)

```dart
@override
bool hitTest(BoxHitTestResult result, {required Offset position}) {
  var hitTarget = false;
  if (size.contains(position)) {
    hitTarget = hitTestChildren(result, position: position) || hitTestSelf(position);
    if (hitTarget || behavior == HitTestBehavior.translucent) {
      result.add(BoxHitTestEntry(this, position));
    }
  }
  return hitTarget;
}

@override
bool hitTestSelf(Offset position) => behavior == HitTestBehavior.opaque;
```

点击上层范围内时，先看子组件有没有命中：

- **点中子组件**：`hitTestChildren` 为 `true`。三种模式下，上层都加入命中路径并返回 `true`，父组件停止检查下层。
- **点在留白**：`hitTestChildren` 为 `false`。`opaque` 靠 `hitTestSelf` 自行命中并返回 `true`。`deferToChild` 返回 `false`，上层不会收到事件。`translucent` 也返回 `false`，但它会通过 `result.add(...)` 收到这次事件，父组件仍继续检查下层。

要让文字周围的 `Padding` 也响应，可以给包住整个区域的组件设置 `opaque`。

在 Flutter Record 首页打开「Hitest Page」，路由是 `/hitest_page`，页面标题是「HitTestBehavior」。下面按页面的顺序从橙色卡片走到蓝色卡片，每个案例都先看点击结果，再核对 `HitestPage.dart` 和 Flutter 3.41.9 源码。

## 三、案例一 · Container：文字周围的留白

在橙色卡片里，两个边框都标出 `Container` 的完整范围。先分别点「示例文字」，两个计数都会加 1。再点各自框内的留白，只有 `opaque` 那一组继续计数。

页面的 `_paddingExample` 用同一套布局创建两组示例。边框和底色在监听范围外侧的 `DecoratedBox` 上绘制。监听组件内部的 `Container` 只传入 `padding` 和 `child`。下面是 `Container.build` 中直接影响这两个示例的初始化分支。

[Container.build 中的 Padding 和 ColoredBox 分支](https://github.com/flutter/flutter/blob/00b0c91f06209d9e4a41f71b7a512d6eb3b9c694/packages/flutter/lib/src/widgets/container.dart#L400-L407)

```dart
final EdgeInsetsGeometry? effectivePadding = _paddingIncludingDecoration;
if (effectivePadding != null) {
  current = Padding(padding: effectivePadding, child: current);
}

if (color != null) {
  current = ColoredBox(color: color!, isAntiAlias: isAntiAlias, child: current);
}
```

- **本例只设置 `padding`**。它扩大布局范围。点击文字之外，`Padding` 交给子组件检查，结果为未命中。代入前面的 `hitTest`，`deferToChild` 返回 `false`，`opaque` 则通过 `hitTestSelf` 返回 `true`。
- **如果又设置了 `color: Colors.transparent`**，`Container` 会在 `Padding` 外再包一层 `ColoredBox`。它的渲染对象采用 `opaque`，会在留白处自行命中。此时，外层用 `deferToChild` 也能收到事件。[_RenderColoredBox 构造函数](https://github.com/flutter/flutter/blob/00b0c91f06209d9e4a41f71b7a512d6eb3b9c694/packages/flutter/lib/src/widgets/basic.dart#L8525-L8529)

要让整个框都能响应，可以把包住文字和 `Padding` 的组件设为 `opaque`。如果把 `Padding` 放到事件处理组件外面，那块留白就超出了它的命中范围。

## 四、案例二 · Listener：叠层命中

在蓝色卡片里，浅蓝留白和深蓝子组件都位于上层范围内，露出来的橙色是下层独占区。页面的 `_overlapExample` 只切换上层的 `behavior`，下层始终可以在重叠处命中。观察「最近一次按下」的结果。

1. **点浅蓝留白**。上层子组件未命中。切换 `deferToChild`、`opaque`、`translucent`，依次看到「下层」「上层」「上层 → 下层」。
2. **点深蓝子组件**。上层子组件命中，三种模式都显示「上层」。
3. **点橙色下层独占区**。点击位置在上层范围之外，三种模式都显示「下层」。

回到前面的源码，`translucent` 可以通过 `result.add(...)` 让上层收到事件，返回值仍由 `hitTarget` 决定。共同的父组件在检查到返回 `true` 的同级组件时停止遍历。点浅蓝留白时，上层返回 `false`，下层还有机会被检查。点深蓝子组件时，上层返回 `true`，所以结果里只有上层。 [同级组件的命中遍历](https://github.com/flutter/flutter/blob/00b0c91f06209d9e4a41f71b7a512d6eb3b9c694/packages/flutter/lib/src/rendering/box.dart#L3337-L3356)

## Flutter 源码版权与许可证

本文引用的 Flutter 源码来自 Flutter 3.41.9，保留原版权与许可声明。

```text
Copyright 2014 The Flutter Authors. All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials provided
      with the distribution.
    * Neither the name of Google Inc. nor the names of its
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```
