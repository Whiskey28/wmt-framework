#!/usr/bin/env python
# -*- coding: utf-8 -*-
import pandas as pd
import sys

# 读取Excel文件
xls_file = 'results-r01.xls'
csv_file = 'results-r01.csv'

try:
    # 读取Excel
    df = pd.read_excel(xls_file, sheet_name='Results')
    
    # 保存为CSV
    df.to_csv(csv_file, index=False, encoding='utf-8-sig')
    
    print(f"CSV文件已创建: {csv_file}")
    print(f"数据形状: {df.shape}")
    print(f"\n列名:")
    for i, col in enumerate(df.columns):
        print(f"{i+1}. {col}")
    
    print(f"\n前10行数据预览:")
    print(df.head(10).to_string())
    
    print(f"\n数据类型:")
    print(df.dtypes)
    
except Exception as e:
    print(f"错误: {e}")
    sys.exit(1)

