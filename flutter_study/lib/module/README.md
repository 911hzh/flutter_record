# module 目录说明

`module` 用于组织业务模块、demo 页面、依赖注册和路由配置。Flutter 学习示例按主题组织，页面专用状态和 Widget 与页面放在一起。

## 当前内容

- [`usecase/pages/home`](usecase/pages/home/README.md) 是学习首页和菜单。
- `usecase/pages/` 包含布局、Canvas、状态管理、转场、国际化和平台互操作等示例。完整入口见[项目索引](../../README.md#演示与教程)。
- [`getIt`](getIt/README.md) 管理依赖注入。
- [`route`](route/README.md) 管理路由和导航。


## 使用约定

模块目录主要负责页面展示、交互入口、状态编排和模块入口组装。需要第三方 SDK 能力时，页面用例应依赖 `base/port` 中的接口，并通过 `module/getIt` 获取实现，避免直接调用 `infra` 或具体 SDK。
