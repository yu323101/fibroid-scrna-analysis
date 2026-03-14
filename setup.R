#!/usr/bin/env Rscript

# 环境设置和检查脚本
# 在运行 Quarto 文档之前执行

cat("=== 单细胞分析环境检查 ===\n\n")

# 检查 R 版本
cat("R 版本:", R.version.string, "\n")
if (as.numeric(R.version$major) < 4 || 
    (as.numeric(R.version$major) == 4 && as.numeric(R.version$minor) < 3)) {
  warning("建议 R 版本 >= 4.3.1")
}

# 创建必要的目录
dirs <- c("data", "results", "figures", "cache")
for (dir in dirs) {
  if (!dir.exists(dir)) {
    dir.create(dir, showWarnings = FALSE, recursive = TRUE)
    cat("创建目录:", dir, "\n")
  } else {
    cat("目录已存在:", dir, "\n")
  }
}

# 检查并安装缺失的包
cat("\n=== 检查 R 包 ===\n")

required_packages <- c(
  "GEOquery", "DESeq2", "Seurat", "ggplot2", "pheatmap",
  "dplyr", "biomaRt", "ComplexHeatmap", "patchwork",
  "ggVennDiagram", "tidyr", "readr", "stringr"
)

missing_packages <- c()
for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    missing_packages <- c(missing_packages, pkg)
    cat("缺失包:", pkg, "\n")
  } else {
    cat("✓", pkg, "\n")
  }
}

if (length(missing_packages) > 0) {
  cat("\n=== 安装缺失的包 ===\n")
  if (!require("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager")
  }
  BiocManager::install(missing_packages, update = FALSE)
}

# 检查 Quarto
cat("\n=== 检查 Quarto ===\n")
quarto_check <- system("quarto --version", intern = TRUE, ignore.stderr = TRUE)
if (length(quarto_check) > 0) {
  cat("Quarto 版本:", quarto_check[1], "\n")
} else {
  cat("警告: Quarto 未安装或不在 PATH 中\n")
}

# 检查数据目录
cat("\n=== 检查数据 ===\n")
if (!dir.exists("data/GSE162122_RAW")) {
  cat("⚠ 警告: GSE162122_RAW 目录不存在\n")
  cat("  请从 https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE162122 下载数据\n")
  cat("  并解压到 data/GSE162122_RAW/ 目录\n")
} else {
  cat("✓ GSE162122_RAW 目录存在\n")
}

if (!file.exists("data/GSE169255_sample_id_ReadsperGene.txt")) {
  cat("⚠ 警告: GSE169255 数据文件不存在\n")
  cat("  将自动下载或请手动下载\n")
} else {
  cat("✓ GSE169255 数据文件存在\n")
}

cat("\n=== 环境检查完成 ===\n")
cat("可以运行: quarto render analysis_VMP1_MICU1.qmd\n")
