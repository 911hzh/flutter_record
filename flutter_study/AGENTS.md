# Repository Guidelines

## 项目结构与模块组织
这是一个 Flutter 应用仓库，入口在 `lib/main.dart`。主要业务代码位于 `lib/`：`lib/base/` 放基础能力与依赖注入，`lib/module/` 放功能模块，`lib/testPage/` 是各类实验页与示例页面，路由配置在 `lib/config/RouterConfig.dart`。资源文件已在 `pubspec.yaml` 中声明为 `lib/assets/`。测试位于 `test/`，当前包含接口测试和基础 widget 测试。`packages/api_module/` 是本地 package 依赖，修改主工程接口封装时通常需要一起检查。

## 构建、测试与开发命令
优先使用仓库根目录 `Makefile`：

- `make get`：安装依赖。
- `make run`：本地运行应用。
- `make analyze`：执行 `flutter analyze`。
- `make test`：运行 `flutter test`。
- `make gen`：生成 `build_runner` 文件与 Native Channel 平台代码。
- `make watch`：监听并持续生成代码。
- `make app-build` / `make app-build-web`：构建 APK 或 Web。
- `make coverage`：生成覆盖率报告。

如只做一次性校验，最小命令通常是 `flutter analyze && flutter test`；如改动了注入、序列化、Pigeon 或资源索引，再补跑 `make gen`。

## 编码风格与命名约定
遵循 `analysis_options.yaml` 中的 `flutter_lints`。统一使用 2 空格缩进，并先运行 `dart format lib test`。项目现有 Dart 文件大量使用大驼峰文件名，例如 `HomePage.dart`、`LoginApi.dart`；新增文件请优先跟随所在目录的既有风格，不要混用命名方案。生成文件如 `*.g.dart`、`*.config.dart`、`lib/gen/assets.gen.dart` 不要手动编辑。

## 测试规范
测试文件放在 `test/`，命名使用 `*_test.dart`，例如 `test/base/api/login_api_test.dart`。新增逻辑优先补最小可验证测试；UI 改动至少确保现有 `widget_test.dart` 能通过。提交前至少运行与改动相关的测试，无法验证时在 PR 说明里写明原因与风险。

## 提交与 PR 规范
现有提交历史以简短中文说明为主，如 `初始化agents.md文件`、`read me 修改`，也存在少量英文初始化/合并提交。继续使用“动词 + 变更点”的短提交信息，聚焦单一主题。PR 需要写清变更目的、影响范围、验证命令；涉及 UI、路由或平台交互时，附截图或录屏，并标明是否执行过 `make gen`、`make analyze`、`make test`。

## 配置与生成代码提示
Native Channel 相关配置在 `zh_native_channel_config.json`，环境资源示例位于 `lib/assets/settings/`。改动平台通信、依赖注入或 JSON 模型后，先生成代码再提交，避免把手写代码与生成物状态留在不一致状态。
