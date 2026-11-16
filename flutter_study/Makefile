# Flutter 项目常用命令脚本
# 使用方法: make <command>

.PHONY: gen-l10n
.PHONY: help gen clean build ios android web build-ios build-android build-web app-build app-build-ios app-build-web run test get upgrade coverage coverage-open coverage-check build-runner-sync-config build-runner-build create-platformcode-all create-platformcode-ios create-platformcode-android create-platformcode-web

# 默认显示帮助信息
help:
	@echo "可用的命令:"
	@echo "  make gen             - 运行代码生成器（build_runner）"
	@echo "  make gen-l10n        - 从 ARB 生成 Dart 本地化代码"
	@echo "  make clean           - 清理项目缓存和构建文件"
	@echo "  make build           - 生成全部 Native Channel 平台代码"
	@echo "  make build-ios       - 只生成 iOS Native Channel 代码"
	@echo "  make build-android   - 只生成 Android Native Channel 代码"
	@echo "  make build-web       - 只生成 Web Native Channel 代码"
	@echo "  make ios/android/web - 只生成对应平台 Native Channel 代码"
	@echo "  make app-build       - 构建 Android APK"
	@echo "  make app-build-ios   - 构建 iOS"
	@echo "  make app-build-web   - 构建 Web"
	@echo "  make run             - 运行项目"
	@echo "  make test            - 运行测试"
	@echo "  make get             - 获取依赖包"
	@echo "  make upgrade         - 升级依赖包"
	@echo "  make watch           - 监听文件变化并自动生成代码"
	@echo "  make coverage        - 生成测试覆盖率报告"
	@echo "  make coverage-open   - 生成覆盖率报告并在浏览器打开"
	@echo "  make coverage-check  - CI 覆盖率检查 (可设置 THRESHOLD=80)"

# 运行代码生成器
gen:
	@echo "🚀 运行代码生成器..."
	$(MAKE) build-runner-build
	$(MAKE) create-platformcode-all

# 从 ARB 生成 Dart 本地化代码
gen-l10n:
	flutter gen-l10n

# 监听文件变化并自动生成代码
watch:
	@echo "👀 监听文件变化中..."
	flutter pub run build_runner watch --delete-conflicting-outputs

# 清理项目
clean:
	@echo "🧹 清理项目..."
	flutter clean
	flutter pub get

# 深度清理（包括 build_runner 缓存）
deep-clean:
	@echo "🧹 深度清理项目..."
	flutter clean
	rm -rf .dart_tool/
	rm -rf build/
	flutter pub get

# 获取依赖包
get:
	@echo "📦 获取依赖包..."
	flutter pub get

# 升级依赖包
upgrade:
	@echo "⬆️  升级依赖包..."
	flutter pub upgrade

# 运行项目
run:
	@echo "▶️  运行项目..."
	flutter run

# 运行测试
test:
	@echo "🧪 运行测试..."
	flutter test

# 生成 Native Channel 代码
build: gen

build-ios:
	$(MAKE) build-runner-build
	$(MAKE) create-platformcode-ios

build-android:
	$(MAKE) build-runner-build
	$(MAKE) create-platformcode-android

build-web:
	$(MAKE) build-runner-build
	$(MAKE) create-platformcode-web

ios: build-ios

android: build-android

web: build-web

# 构建应用
app-build:
	@echo "🔨 构建 Android APK..."
	flutter build apk

app-build-ios:
	@echo "🔨 构建 iOS..."
	flutter build ios

app-build-web:
	@echo "🔨 构建 Web..."
	flutter build web

# 分析代码
analyze:
	@echo "🔍 分析代码..."
	flutter analyze

# 格式化代码
format:
	@echo "✨ 格式化代码..."
	dart format lib/ test/

# 生成测试覆盖率报告
coverage:
	@echo "📊 生成测试覆盖率报告..."
	@chmod +x scripts/coverage.sh
	@./scripts/coverage.sh

# 生成覆盖率报告并打开
coverage-open:
	@echo "📊 生成测试覆盖率报告并打开..."
	@chmod +x scripts/coverage.sh
	@./scripts/coverage.sh --open

# CI 覆盖率检查（可设置阈值）
# 使用方法: make coverage-check THRESHOLD=80
THRESHOLD ?= 0
coverage-check:
	@chmod +x scripts/coverage-check.sh
	@./scripts/coverage-check.sh $(THRESHOLD)

# >>> zh_native_channel_generator
ZH_NATIVE_CHANNEL_GENERATOR ?= dart run zh_native_channel_generator:generate_native_channel
ZH_NATIVE_CHANNEL_CONFIG ?= zh_native_channel_config.json

.PHONY: clean-generated build-runner-sync-config build-runner-build create-platformcode-all create-platformcode-ios create-platformcode-android create-platformcode-web gen

clean-generated:
	$(ZH_NATIVE_CHANNEL_GENERATOR) $(ZH_NATIVE_CHANNEL_CONFIG) --clean-generated-only

build-runner-sync-config:
	$(ZH_NATIVE_CHANNEL_GENERATOR) $(ZH_NATIVE_CHANNEL_CONFIG) --sync-build-config-only

build-runner-build: build-runner-sync-config
	@if [ ! -f pubspec.yaml ]; then echo "当前目录没有 pubspec.yaml，跳过 build_runner。"; else dart run build_runner build; fi

gen:
	$(MAKE) clean-generated
	$(MAKE) build-runner-build
	$(MAKE) create-platformcode-all

create-platformcode-all:
	$(ZH_NATIVE_CHANNEL_GENERATOR) $(ZH_NATIVE_CHANNEL_CONFIG) --platform all

create-platformcode-ios:
	$(ZH_NATIVE_CHANNEL_GENERATOR) $(ZH_NATIVE_CHANNEL_CONFIG) --platform ios

create-platformcode-android:
	$(ZH_NATIVE_CHANNEL_GENERATOR) $(ZH_NATIVE_CHANNEL_CONFIG) --platform android

create-platformcode-web:
	$(ZH_NATIVE_CHANNEL_GENERATOR) $(ZH_NATIVE_CHANNEL_CONFIG) --platform web
# <<< zh_native_channel_generator





































































