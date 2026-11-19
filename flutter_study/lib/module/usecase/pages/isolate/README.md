# Isolate 实验

首页「Isolate 实验」进入 `/isolate`，源码见 [IsolatePage.dart](IsolatePage.dart)。

原生平台上，点击 Isolate.run 或 compute，计算 1 到 1000 万的和。两种结果都是 50000005000000。运行期间可点击「测试界面响应」观察 UI 交互，实际计算较快时可能看不到明显等待。

- `Isolate.run(() => sumNumbers(limit))` 适合一次性计算，任务结束后返回结果并结束该 Isolate。
- `compute(sumNumbers, limit)` 把回调和参数显式传入，适合解析或转换数据。示例使用顶层函数，避免捕获页面对象。
- 持续双向通信可使用 `Isolate.spawn`、`ReceivePort` 和 `SendPort`。持有者需要管理消息协议、关闭端口和终止任务，此页面聚焦一次性计算。

Isolate 有独立内存，通过可传递的消息通信。UI 操作在主 Isolate 进行。await 负责等待结果，CPU 密集计算通过 Isolate 在原生平台并行执行。网络请求等异步 I/O 通常直接 await。

Web 上 compute 在当前事件循环运行，页面禁用不支持的 Isolate.run。耗时包括任务启动与结果返回，不能直接作为纯计算性能对比。

页面本地管理执行状态、异常和 mounted 检查，无需全局依赖注册。退出页面后已经启动的计算仍会完成，完成时通过 mounted 检查避免更新已销毁的页面。

验证时检查两种方式的结果及重复点击限制，并在真实设备上观察运行期间的界面响应。
