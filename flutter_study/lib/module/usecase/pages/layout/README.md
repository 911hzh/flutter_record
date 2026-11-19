# Expanded 布局

从首页进入 Expanded View，路由为 `/expanded`。两张卡片使用同一段文字、同样大小的图标和相同的可视宽度。

- [无 Expanded](WithoutExpandedWidget.dart) 直接把 `Text` 放进 `Row`。文字以自然宽度排成一行，超过卡片宽度时，调试模式会显示黄黑条纹，并在控制台报告 `RenderFlex overflowed`。
- [有 Expanded](WithExpandedWidget.dart) 在 `Row` 中写 `Expanded(child: Text(text))`。`Row` 先测量 20 个逻辑像素的图标和 8 个逻辑像素的间距，再把剩余宽度分给文字。文字按这个宽度自动换行。

[页面入口](ExpandedPage.dart)

[CSDN 学习笔记](CSDN.md)
