# RepaintBoundary 重绘隔离

首页「RepaintBoundary 重绘隔离」进入 `/repaintboundary`。源码见 [RepaintBoundaryPage.dart](RepaintBoundaryPage.dart)。

点击蓝色区域触发缩放动画，观察控制台中 `RenderFlexT paint` 的输出。当前静态 ColumnT 包在 RepaintBoundary 内。临时去掉这一层后再运行动画，对比静态区域的 paint 日志次数。可在 Flutter Inspector 开启重绘高亮辅助观察。

RepaintBoundary 让子树拥有独立绘制边界。当其他区域重绘且此边界内容没有变脏时，Flutter 可以复用该子树的绘制层。子树自身变化时仍会重绘。它主要减少无关区域的 paint 工作，实际性能应使用 profile 模式验证。

[CSDN 学习笔记](CSDN.MD)
