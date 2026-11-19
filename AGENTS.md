# 仓库指南

## 仓库结构

本仓库按项目组织。每个项目占用一个独立的根级目录，并在自己的目录中维护源码、依赖配置、测试和说明文档。

- [`flutter_study/`](flutter_study/README.md) 是基于 Flutter Foundation Kit 的 Flutter 学习项目，包含页面示例、原生互操作、国际化和测试。
- `.github/workflows/` 存放仓库级 GitHub Actions 工作流。

## 在项目中工作

- 修改前先确认目标项目，阅读该项目的 `README.md` 和 `AGENTS.md`。
- 在目标项目目录安装依赖、生成代码和运行测试。公共仓库设置与 CI 配置放在根目录相应位置。
- 新项目放在独立的根级目录，并在此文件中登记。项目专用约定放在该项目的 `AGENTS.md`。
- `main` 和 `develop` 通过 PR 更新。涉及 Flutter 项目的 PR 需要通过仓库的 Flutter 检查。

## 组件与页面命名

- 自定义 UI 组件的类名和文件名统一以 `Widget` 结尾，例如 `WithExpandedWidget`、`WithExpandedWidget.dart`。
- 页面组件的类名和文件名统一以 `Page` 结尾，例如 `ExpandedPage`、`ExpandedPage.dart`。

## 首页入口排序

- 新增 Demo 时，将对应入口放在首页 PageList 的最前面，方便优先查看最新示例。
- 同一次新增多个 Demo 时，按用户提供的顺序排列这些新入口。
- 用户明确指定其他顺序时，以用户要求为准。

## 首页入口语言

- 首页 PageList 的入口名称优先使用英文，保持命名风格一致。
