#!/bin/sh
#$ -S /bin/sh
# Version 1.1 - Optimized for robustness and usability
# Author: xiechaoyu3
# Date: 2025-06-27 (updated)

echo "Start Time:"
date

# --- 配置参数 ---
LTR_FINDER_CMD="ltr_finder"          # 建议通过 PATH 或 conda 环境调用
GENOME_FA="./genome.fa"
TRNA_FA="./tRNA.fa"
OUTPUT_PREFIX="genome"

# 推荐 LTR 最大间隔：植物常用 15–20 kb，动物 10–15 kb
# 若你确定只找短 LTR，可改回 -w 2；否则建议 -w 15
LTR_MAX_SPAN=15

# --- 检查输入文件 ---
if [ ! -f "$GENOME_FA" ]; then
    echo "ERROR: Genome file '$GENOME_FA' not found!" >&2
    exit 1
fi

if [ ! -f "$TRNA_FA" ]; then
    echo "WARNING: tRNA file '$TRNA_FA' not found. Skipping -s option." >&2
    TRNA_ARG=""
else
    TRNA_ARG="-s $TRNA_FA"
fi

# --- 构建命令 ---
CMD="$LTR_FINDER_CMD -C -w $LTR_MAX_SPAN $TRNA_ARG $GENOME_FA"

echo "Running: $CMD"
echo "Output will be saved to ${OUTPUT_PREFIX}_ltr.txt and ltr_finder.log"

# --- 执行并重定向日志 ---
$CMD 1>"${OUTPUT_PREFIX}_ltr.txt" 2>ltr_finder.log

# --- 完成提示 ---
echo "End Time:"
date
echo "Done. Results: ${OUTPUT_PREFIX}_ltr.txt"
echo "Log (errors/warnings): ltr_finder.log"