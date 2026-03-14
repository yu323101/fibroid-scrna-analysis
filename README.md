# 单细胞分析项目 - VMP1 和 MICU1

本项目分析 VMP1 和 MICU1 基因在子宫肌瘤中的表达模式。

## 项目结构

```
singlecell_analysis/
├── analysis_VMP1_MICU1.qmd    # 主分析文件（Quarto）
├── environment.yml             # Conda 环境配置
├── _quarto.yml                 # Quarto 项目配置
├── setup.R                     # 环境检查脚本
├── data/                       # 数据目录（需下载）
│   ├── GSE169255/             # RNA-seq 数据
│   └── GSE162122_RAW/         # scRNA-seq 数据
├── results/                    # 分析结果
├── figures/                    # 生成的图片
└── cache/                      # Quarto 缓存
```

## 快速开始

### 1. 创建 Conda 环境

```bash
# 创建环境
conda env create -f environment.yml

# 激活环境
conda activate singlecell

# 验证安装
Rscript setup.R
```

### 2. 下载数据

#### GSE169255 (RNA-seq)
自动下载，无需手动操作。

#### GSE162122 (scRNA-seq)
需要手动下载：

1. 访问 https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE162122
2. 下载所有 10X Genomics 数据文件
3. 解压到 `data/GSE162122_RAW/` 目录

每个样本应包含：
- `barcodes.tsv.gz`
- `features.tsv.gz`
- `matrix.mtx.gz`

### 3. 运行分析

```bash
# 渲染完整报告
quarto render analysis_VMP1_MICU1.qmd

# 或预览模式（开发时）
quarto preview analysis_VMP1_MICU1.qmd

# 指定输出格式
quarto render analysis_VMP1_MICU1.qmd --to html
```

### 4. 查看结果

- 报告：`docs/analysis_VMP1_MICU1.html`
- 图片：`figures/`
- 数据：`results/`

## 分析流程

1. **环境设置** - 加载包、创建目录
2. **数据下载** - GSE169255 和 GSE162122
3. **RNA-seq 分析** - DESeq2 差异表达分析
4. **单细胞 QC** - 质控和过滤
5. **标准化** - SCTransform 和整合
6. **聚类** - UMAP 和细胞类型鉴定
7. **图3a** - UMAP 聚类图
8. **图3c** - 热图（细胞类型特异性表达）
9. **图3d** - FeaturePlot（基因表达分布）

## 输出文件

### 图片
- `Figure3a_UMAP.pdf/png` - UMAP 聚类图
- `Figure3c_Heatmap.pdf/png` - 热图
- `Figure3d_FeaturePlot.pdf/png` - 特征图

### 结果
- `GSE169255_DEG_results.csv` - RNA-seq 差异表达结果
- `VMP1_MICU1_regulation_summary.csv` - VMP1 和 MICU1 调控状态
- `GSE162122_Myometrium_Combined.RDS` - 子宫肌层 Seurat 对象
- `GSE162122_Fibroid_Combined.RDS` - 子宫肌瘤 Seurat 对象
- `pseudobulk_VMP1_MICU1.csv` - 伪批量表达数据

## 注意事项

1. **内存需求**：单细胞分析需要 >16GB 内存
2. **运行时间**：完整分析可能需要 2-4 小时
3. **缓存**：启用缓存后，重新运行会跳过已完成阶段
4. **细胞类型**：聚类编号可能需要根据实际数据调整

## 故障排除

### 包安装失败
```bash
# 手动安装缺失的包
R -e "BiocManager::install(c('GEOquery', 'DESeq2', 'Seurat'))"
```

### 内存不足
```r
# 在 setup 代码块中减少线程数
options(future.globals.maxSize = 8000 * 1024^2)  # 8GB
```

### 缓存问题
```bash
# 清除缓存重新运行
rm -rf cache/
quarto render analysis_VMP1_MICU1.qmd
```

## 参考文献

- Buyukcelebi K, et al. Integrating leiomyoma genetics, epigenomics, and single-cell transcriptomics reveals causal genetic variants, genes, and cell types. Nat Commun. 2024.
- GSE169255: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE169255
- GSE162122: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE162122

## 联系方式

如有问题，请参考原始 GitHub 仓库：
https://github.com/AdliLab/Fibroid-GWAS-Manuscript
