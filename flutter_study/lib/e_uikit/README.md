# e_uikit 目录说明

`e_uikit` 存放可复用的 UI 组件。[LocalizationNotifier.dart](localization/LocalizationNotifier.dart) 提供 JSON 本地化状态、`context.tr()` 和 `LocalizationBuilder`，供国际化页面使用。

## 适合放置的内容

- 多个模块都会使用的基础 Widget。
- 统一样式的按钮、卡片、列表项、空状态和加载状态组件。
- 与业务无关的 UI 辅助组件。

## 使用约定

`e_uikit` 中的组件应尽量保持无业务状态或弱业务语义。具体业务流程、接口调用和状态管理仍应留在 `module`、`base` 或 `infra` 对应目录中。
