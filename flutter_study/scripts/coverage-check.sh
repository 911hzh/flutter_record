#!/bin/bash

# Flutter 测试覆盖率检查脚本（CI 专用）
# 使用方法: ./scripts/coverage-check.sh [最低覆盖率阈值]
# 示例: ./scripts/coverage-check.sh 80  (要求至少 80% 覆盖率)

set -e

# 默认阈值为 0（不检查）
THRESHOLD=${1:-0}

echo "🧪 运行测试并生成覆盖率数据..."
flutter test --coverage

# 检查 lcov.info 是否存在
if [ ! -f "coverage/lcov.info" ]; then
    echo "❌ 错误: coverage/lcov.info 文件不存在"
    exit 1
fi

# 检查 lcov 是否安装
if ! command -v lcov &> /dev/null; then
    echo "⚠️  lcov 未安装，使用简单方式计算覆盖率..."
    # 简单方式：直接从 lcov.info 计算
    TOTAL_LINES=$(grep -c "^DA:" coverage/lcov.info 2>/dev/null || echo "0")
    HIT_LINES=$(grep "^DA:" coverage/lcov.info | grep -v ",0$" | wc -l | tr -d ' ')
    
    if [ "$TOTAL_LINES" -eq 0 ]; then
        COVERAGE=0
    else
        COVERAGE=$(echo "scale=1; $HIT_LINES * 100 / $TOTAL_LINES" | bc)
    fi
else
    # 过滤生成的代码文件
    lcov --remove coverage/lcov.info \
        '**/*.g.dart' \
        '**/*.freezed.dart' \
        '**/*.gen.dart' \
        '**/gen/**' \
        '**/generated/**' \
        -o coverage/lcov_filtered.info \
        --ignore-errors unused 2>/dev/null
    
    # 使用 lcov 获取覆盖率
    SUMMARY=$(lcov --summary coverage/lcov_filtered.info 2>&1)
    COVERAGE=$(echo "$SUMMARY" | grep "lines" | grep -oE '[0-9]+\.[0-9]+%' | head -1 | tr -d '%')
    
    # 如果没有获取到，尝试从原始文件获取
    if [ -z "$COVERAGE" ]; then
        SUMMARY=$(lcov --summary coverage/lcov.info 2>&1)
        COVERAGE=$(echo "$SUMMARY" | grep "lines" | grep -oE '[0-9]+\.[0-9]+%' | head -1 | tr -d '%')
    fi
fi

# 默认值
if [ -z "$COVERAGE" ]; then
    COVERAGE=0
fi

echo ""
echo "========================================"
echo "📊 代码覆盖率: ${COVERAGE}%"
echo "📏 最低阈值:   ${THRESHOLD}%"
echo "========================================"

# 比较覆盖率与阈值
if [ "$THRESHOLD" -gt 0 ]; then
    # 使用 bc 进行浮点数比较
    PASS=$(echo "$COVERAGE >= $THRESHOLD" | bc -l)
    
    if [ "$PASS" -eq 1 ]; then
        echo "✅ 覆盖率检查通过!"
        exit 0
    else
        echo "❌ 覆盖率检查失败! 当前 ${COVERAGE}% < 阈值 ${THRESHOLD}%"
        exit 1
    fi
else
    echo "ℹ️  未设置阈值，仅输出覆盖率"
    exit 0
fi

