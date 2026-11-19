# Flutter 本地存储初学者面试笔记

公开面试题库中有“SharedPreferences、Hive、SQLite、flutter_secure_storage 如何选型”这道题。下面围绕每种方案是什么、能做什么、解决什么问题和实现原理展开，并结合当前存储 Demo 说明。场景选择是基于能力整理的建议。 [公开题库 Q60](https://github.com/imtiazaminsajid/Flutter-Developer-Interview-Questions-Answers-Real-Scenario-Based-Questions/blob/main/README.md)

## 本地存储是什么，解决什么问题？

页面中的变量可以保存一次运行里的状态。本地存储把数据写入设备持久化介质，便于下次进入或重新启动后读取。常见数据包括主题设置、登录凭证、离线内容和业务记录。保存时间、查询方式、数据大小、敏感程度和平台支持都会影响选型。

## 四种方案怎么选？

| 方案 | 是什么、能做什么 | 解决的典型问题 |
| --- | --- | --- |
| SharedPreferences | 简单类型的键值存储 | 保存主题、语言、引导页完成标记 |
| flutter_secure_storage | 使用平台安全能力保存键值数据 | 保存令牌等少量敏感信息 |
| Hive | 以 Box 组织的键值数据库，支持对象适配器 | 根据键缓存对象和离线数据 |
| SQLite / sqflite | 嵌入式关系数据库及 Flutter 插件 | 多条业务记录的筛选、排序、关联和事务 |

SharedPreferences 插件支持字符串、数字、布尔值及字符串列表等类型。写入可能异步落盘，关键数据需要更明确的持久化保证。 [插件官方说明](https://pub.dev/packages/shared_preferences)

Secure Storage 根据平台使用安全存储机制。Apple 平台使用 Keychain，Android 的具体加密与密钥管理方案取决于插件版本和配置。项目安装的版本可在 pubspec.lock 核对，迁移时也要查看对应版本说明。 [插件官方说明](https://pub.dev/packages/flutter_secure_storage)

Hive 的 Box 提供按键读写，自定义对象可通过 TypeAdapter 转换成二进制并还原。需要加密时还要配置加密与管理密钥。 [Hive 官方说明](https://pub.dev/packages/hive)

sqflite 把 SQL 操作交给平台数据库执行，支持事务、批量操作和版本升级回调。 [sqflite 官方说明](https://pub.dev/packages/sqflite)

## 当前 Demo 为什么有五张卡片？

Hive 分成“Codec 编码”和“Adapter 对象”两种形式，所以有五个实现。它们都实现 StorageObjectStore，提供 save、read 和 delete，便于用同一个 StorageRecord 对照读写过程。

| 当前实现 | 写入到存储之前 |
| --- | --- |
| SecureTokenStore | 对象通过 Codec 转为 JSON 字符串 |
| SharedPreferencesTokenStore | 对象通过 Codec 转为 JSON 字符串 |
| HiveTokenStore | 对象通过 Codec 转为 Map，再由 Hive 存储 |
| HiveDirectObjectStore | 把对象交给已注册的 TypeAdapter |
| SqliteTokenStore | 对象转 JSON，再经 UTF-8 编码成字节，以 BLOB 存储 |

页面中的 token 字段用于学习统一对象的编解码流程。真实令牌应根据敏感性选择存储方案。 [存储入口](StoragePage.dart) · [Codec](StorageCodec.dart)

## JSON、二进制和加密有什么区别？

JSON 是表示结构化数据的文本格式。UTF-8 编码把文本转换为字节。Hive TypeAdapter 规定字段如何写成二进制及如何读取。加密则使用密钥保护内容，安全性取决于算法、密钥管理和平台能力。

当前 SQLite 的 BLOB 是 JSON 的 UTF-8 字节，拿到字节就能按相同规则还原对象。Adapter 的二进制编码也需要额外配置才有加密保护。理解这一区别，才能解释“存成二进制是否安全”的追问。

## 为什么 SQLite 的优势在这里看不出来？

本 Demo 只有 store_key 和 value 两列，业务对象整体存进 BLOB，按键读取后由 Dart 解码。若要按 token 的业务字段筛选，通常需要把需要查询的字段设计成列，再建立必要索引。当前实现主要展示 SQLite 也能完成对象持久化。 [SqliteTokenStore](SqliteTokenStore.dart)

## 数据结构升级怎么办？

JSON 增加字段时，要考虑旧记录没有字段的默认值。Hive Adapter 的读写顺序和 typeId 要稳定，变更格式需要兼容方案。SQLite 可通过数据库版本和 onUpgrade 迁移表结构，更新版本号时需要同时考虑旧版本的数据。当前 Demo 主要展示基础读写，完整历史迁移需要进一步设计。

## 怎样验证“真的保存了”？

在每张卡片输入不同内容，执行写入、读取。退出再进入或重启应用后重新读取，检查字段是否一致。删除后再次读取，检查空值结果。Hive 初始化与 StorageRecordAdapter 注册放在 main，平台插件需要在支持的设备上验证。 [操作说明](README.md)

选型时可以回答“设置用 SharedPreferences，少量敏感凭证用 Secure Storage，按键对象缓存考虑 Hive，需要字段查询和事务的业务数据考虑 SQLite”，再解释自己的数据规模、查询需求和兼容方案。
