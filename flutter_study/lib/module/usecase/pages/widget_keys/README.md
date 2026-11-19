# Key 与 BLoC

入口：/key_page、/bloc。

观察 Key 与元素复用，操作 BLoC 示例查看状态变化。

## Key 对照实验

1. 两组初始都是红色 A 和蓝色 B。分别点击两组的 A 一次，再点「交换顺序」。
2. 无 Key 组变为红色 B（1 次）、蓝色 A（0 次）。稳定 ValueKey 组变为蓝色 B（0 次）、红色 A（1 次）。
3. 点「普通重建」观察两组的颜色和计数都保留。

`KeyPage` 预先创建两组色块。交换时直接调换每组原有的两个 Widget 实例，在页面内直接展示两组结果。

## 代码

- [BlocBuilderPage.dart](BlocBuilderPage.dart)
- [ColorView.dart](ColorView.dart)
- [GlobalKeyTestView.dart](GlobalKeyTestView.dart)
- [KeyPage.dart](KeyPage.dart)

- [CSDN 学习笔记：Flutter Key 入门](CSDN.md)
