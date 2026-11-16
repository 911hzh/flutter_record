#!/bin/bash

# Flutter 测试覆盖率报告生成脚本
# 使用方法: ./scripts/coverage.sh

set -e

echo "🧪 运行测试并生成覆盖率数据..."
flutter test --coverage

# 检查 lcov 是否安装
if ! command -v lcov &> /dev/null; then
    echo "⚠️  lcov 未安装，请先运行: brew install lcov"
    echo "📄 原始覆盖率数据已生成: coverage/lcov.info"
    exit 1
fi

echo "🔧 过滤生成的代码文件..."
lcov --remove coverage/lcov.info \
    '**/*.g.dart' \
    '**/*.freezed.dart' \
    '**/*.gen.dart' \
    '**/gen/**' \
    '**/generated/**' \
    -o coverage/lcov_filtered.info \
    --ignore-errors unused

echo "📊 生成 HTML 报告..."
genhtml coverage/lcov_filtered.info -o coverage/html --ignore-errors unmapped

echo ""
echo "📈 覆盖率汇总:"
echo "----------------------------------------"
lcov --summary coverage/lcov_filtered.info 2>/dev/null || lcov --summary coverage/lcov.info
echo "----------------------------------------"

echo ""
echo "✅ 报告生成完成!"
echo "📂 HTML 报告位置: coverage/html/index.html"

# 询问是否打开报告
if [[ "$1" == "--open" ]] || [[ "$1" == "-o" ]]; then
    echo "🌐 正在打开报告..."
    open coverage/html/index.html
fi

