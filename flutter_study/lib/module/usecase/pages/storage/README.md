# 本地存储对比

首页「本地存储对比」打开 `/storage`。从原 flutter_demo_study 的同名目录复制。

演示 Secure Storage、Hive 编码存储、Hive TypeAdapter 对象存储、SharedPreferences 和 SQLite 的对象写入、读取及删除。入口见 [StoragePage.dart](StoragePage.dart)。

main 初始化 Hive 并注册 StorageRecordAdapter。各实现使用独立存储键，页面点击时访问平台插件。验证时在支持各插件的设备上分别写入、读取、退出重进及删除。平台支持情况由对应插件决定。

[MSDN 面试学习笔记](MSDN.MD)
