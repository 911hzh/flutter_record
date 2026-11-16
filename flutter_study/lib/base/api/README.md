# api 目录说明

`api` 用于放置学习工程的网络 API 和适配器代码，包含 `flutter_foundation_kit` 中 `RestClient`、`RestClientAdapter`、`NetworkProxy` 等接入示例。

## 当前内容

- [`Api.dart`](Api.dart)、[`LoginApi.dart`](LoginApi.dart) 使用本地 `packages/api_module` 提供旧版 API 和登录示例。
- [`AppApiClient.dart`](AppApiClient.dart) 和 [`UserApi.dart`](UserApi.dart) 提供 Foundation Kit 的 API 接入示例。
- [`AppRestClientAdapter.dart`](AppRestClientAdapter.dart) 和 [`AppNetworkProxy.dart`](AppNetworkProxy.dart) 分别提供 REST 适配和网络代理。
- `model/` 包含 [`User.dart`](model/User.dart) 和 [`LoginResponse.dart`](model/LoginResponse.dart)。


## 和 port 的区别

`api` 当前是网络 API 示例封装，不是第三方 SDK 的 Port 抽象层。第三方 SDK 接入时，应优先在 `lib/base/port` 定义接口抽象，再在 `lib/infra` 中提供具体实现。
