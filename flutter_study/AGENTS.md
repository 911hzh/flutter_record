# Repository Guidelines

## 项目结构与模块组织

这是一个使用 Port、Infra 和 GetIt 分层的 Flutter 学习工程，入口是 `lib/main.dart`。资源在 `pubspec.yaml` 中声明，测试位于 `test/`。`packages/api_module/` 是本地网络依赖，改动主工程接口封装时一起检查其调用关系。

## 目录放置规则

- 页面、Cubit、VM、模块内 Widget 放 `lib/module/usecase`。
- 第三方 SDK 或平台能力的接口抽象放 `lib/base/port`。
- `base/port` 中接口的具体实现放 `lib/infra`。
- 依赖注入、对象注册、命名实例放 `lib/module/getIt`。
- 路由表、页面路径、全局导航能力放 `lib/module/route`。
- 多个模块共享的 UI 组件放 `lib/e_uikit`。
- REST API、请求方法、网络返回模型放 `lib/base/api`。
- Store、本地持久化、共享状态放 `lib/base/store`。
- 尽量保持一个文件只定义一个主要 class，避免多个可注入类或模型类混在同一个文件。
- `RestClientAdapter` 的 example 实现放在 `lib/base/api/*RestClientAdapter.dart`。
- `NetworkProxy` 的 example 实现放在 `lib/base/api/*NetworkProxy.dart`。

## 禁止事项

- 不要把第三方 SDK 调用直接写进 Page、Cubit 或 VM。
- 不要把第三方 SDK 的具体实现写进 `lib/base/port`。
- 不要把业务流程、接口请求或 SDK 调用写进 `lib/e_uikit`。
- 不要新增页面后忘记在 `lib/module/route/RouteConfig.dart` 注册路由。
- 不要绕过 GetIt 到处手动创建可注入依赖。
- 不要把模块页面散落到 `lib` 根目录。
- 不要把仅服务某个页面的小 Widget 放进 `e_uikit`。
- 不要把 `RestClientAdapter`、`NetworkProxy`、API 聚合类、响应模型都堆在同一个文件。

## 常见任务

### 新增页面

1. 在 `lib/module/usecase/pages` 下按主题创建页面目录。
2. 创建 `Page`。
3. 如果有状态或交互逻辑，创建对应 `Cubit` 或 VM。
4. 在 `lib/module/route/RouteConfig.dart` 注册路由。
5. 如果首页需要入口，同步更新首页入口列表。

推荐结构：

```text
lib/module/usecase/pages/example/
  ExamplePage.dart
  ExampleCubit.dart
```

### 新增第三方 SDK 能力

1. 在 `lib/base/port` 定义业务接口。
2. 在 `lib/infra` 实现该接口。
3. 在 `lib/module/getIt` 注册接口和实现。
4. 在 `lib/module` 中通过接口使用能力。

推荐结构：

```text
lib/base/port/analytics/
  AnalyticsPort.dart

lib/infra/analytics/
  AnalyticsPortImpl.dart
```

### 新增网络 API

1. 在 `lib/base/api` 新增 API 类。
2. 网络返回模型放到 `lib/base/api/model`。
3. `RestClientAdapter` 和 `NetworkProxy` 的实现分别创建独立文件。
4. 需要注入时，在 `lib/module/getIt` 或 injectable 注解中注册。

推荐结构：

```text
lib/base/api/OrderApi.dart
lib/base/api/OrderRestClientAdapter.dart
lib/base/api/OrderNetworkProxy.dart
lib/base/api/model/Order.dart
```

### 新增 Store

1. 在 `lib/base/store` 按能力创建目录。
2. Store 内部处理状态读写和持久化细节。
3. 模块通过 Store 使用数据，不直接散落持久化逻辑。

推荐结构：

```text
lib/base/store/order/
  OrderStore.dart
  OrderStoreImpl.dart
```

### 新增公共 UI

1. 在 `lib/e_uikit` 创建组件。
2. 组件保持可复用，不绑定具体业务流程。
3. 业务数据转换和交互逻辑留在 `module`。

推荐结构：

```text
lib/e_uikit/loading/
  LoadingView.dart
```

## AI 修改前检查

开始改代码前，先阅读项目结构和功能记录，再判断本次任务属于哪一类：

1. 阅读 `README.md`，了解模板入口和核心目录。
2. 阅读 `lib/README.md`，了解 `lib` 外层目录职责。
3. 阅读 `lib/quick_use.md`，确认本次任务应该放在哪个目录。
4. 阅读 `FEATURE_LOG.md`，确认已有功能、入口和历史记录。

5. 需要了解分层取舍时，阅读 `lib/ARCHITECTURE_TRADEOFFS.md`。

## AI 修改后检查

完成修改后检查：

- 新页面是否注册路由。
- 新依赖是否完成 GetIt 或 injectable 注册。
- 模块是否只依赖 Port，而不是直接依赖 Infra 或第三方 SDK。
- 第三方 SDK 类型是否没有泄漏到 Page、Cubit、VM。
- 公共 UI 是否没有包含业务流程。
- 新增或调整功能是否已经更新 `FEATURE_LOG.md`。
- 是否运行了合适的格式化、分析或测试命令。

## 功能记录要求

每次新增功能、调整功能入口、接入第三方 SDK、增加页面或新增共享能力后，必须更新 `FEATURE_LOG.md`。

记录至少包含：

- 功能说明。
- 涉及目录。
- 页面入口或调用入口。
- 依赖注册情况。
- 验证方式。
- 备注或后续计划。

## 构建、测试与开发命令
优先使用Flutter 工程根目录的 `Makefile`：

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
Native Channel 相关配置在 `zh_native_channel_config.json`，模板的环境配置文件位于 `lib/base/store/settings/`。改动平台通信、依赖注入或 JSON 模型后，先生成代码再提交，避免把手写代码与生成物状态留在不一致状态。
