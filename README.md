# personal-tools
## 包含一些在课堂上学到的、工作中用到的小脚本。主要为生信小脚本 
当前包含
-**[`run_ltr_finder.sh`](repeats/LTR_finder.sh)**  
  自动化运行 `LTR-Finder`，用于预测基因组中的 **LTR 反转录转座子**。  

-**[`Ltr2GFF.pl`](repeats/ltr2gff.pl)**  
  将 `LTR-Finder` 的原始输出（`.ltr` 文件）转换为标准 **GFF3 格式**，便于：  
  - 在 IGV、JBrowse 中可视化  
  - 输入 RepeatMasker 进行重复序列屏蔽  
  - 与其他注释整合

#### 快速使用示例
```bash
# 1. 运行 LTR-Finder（需提前准备 genome.fa 和 tRNA.fa）
./scripts/repeats/run_ltr_finder.sh

# 2. 转换结果为 GFF3
perl scripts/repeats/Ltr2GFF.pl genome_ltr.txt
# 输出: genome_ltr.txt.gff
