#!/bin/sh
#$ -S /bin/sh
# Version 1.1 - Optimized fastp QC script
# Author: xiechaoyu3
# Date: 2025-06-25 (updated)

echo "Start Time:"
date

# --- 配置 ---
INPUT_R1="./Mit_CMD1_1.fq.gz"
INPUT_R2="./Mit_CMD1_2.fq.gz"
OUTPUT_PREFIX="Mit_CMD1"

# 质控参数
MIN_LEN=150          # 最小 read 长度
AVG_QUAL=20          # 最小平均质量
THREADS=6

# 输出文件
CLEAN_R1="${OUTPUT_PREFIX}_clean_1.fq.gz"
CLEAN_R2="${OUTPUT_PREFIX}_clean_2.fq.gz"
HTML_REPORT="${OUTPUT_PREFIX}_fastp_report.html"
JSON_REPORT="${OUTPUT_PREFIX}_fastp_report.json"

# --- 检查输入文件 ---
if [ ! -f "$INPUT_R1" ] || [ ! -f "$INPUT_R2" ]; then
    echo "ERROR: Input FASTQ files not found!" >&2
    exit 1
fi

# --- 运行 fastp ---
echo "Running fastp for quality control..."
fastp \
  -i "$INPUT_R1" \
  -I "$INPUT_R2" \
  -o "$CLEAN_R1" \
  -O "$CLEAN_R2" \
  --length_required "$MIN_LEN" \
  --qualified_quality_phred "$AVG_QUAL" \
  --html "$HTML_REPORT" \
  --json "$JSON_REPORT" \
  --thread "$THREADS" \
  --trim_poly_g        # 自动切除 Illumina Poly-G 尾（常见于 NovaSeq）

# --- 完成提示 ---
echo "End Time:"
date
echo "Done."
echo "Clean reads: $CLEAN_R1, $CLEAN_R2"
echo "QC report: $HTML_REPORT (open in browser)"