"""
分析第二回合Excel数据
根据完整分析框架提取所需数据并计算关键指标
"""

import pandas as pd
import numpy as np
import sys

# 设置编码
if sys.platform == 'win32':
    import locale
    try:
        locale.setlocale(locale.LC_ALL, 'zh_CN.UTF-8')
    except:
        pass

def read_excel_sheets(filename):
    """读取Excel文件，尝试识别所有sheet"""
    try:
        xls = pd.ExcelFile(filename, engine='xlrd')
        print(f"Sheet names: {xls.sheet_names}")
        return xls
    except Exception as e:
        print(f"Error reading Excel: {e}")
        return None

def analyze_r02_data(filename='results-r02.xls'):
    """分析第二回合数据"""
    
    print("=" * 60)
    print("第二回合数据分析")
    print("=" * 60)
    
    # 读取Excel
    xls = read_excel_sheets(filename)
    if not xls:
        return
    
    # 读取所有sheet
    all_data = {}
    for sheet_name in xls.sheet_names:
        print(f"\n读取Sheet: {sheet_name}")
        try:
            df = pd.read_excel(filename, sheet_name=sheet_name, header=None)
            all_data[sheet_name] = df
            print(f"  形状: {df.shape}")
            print(f"  前5行:")
            print(df.head())
            print(f"  列名: {df.columns.tolist()}")
        except Exception as e:
            print(f"  读取失败: {e}")
    
    # 尝试找到关键数据
    if 'Results' in all_data:
        df = all_data['Results']
        
        # 尝试找到表头
        print("\n" + "=" * 60)
        print("查找表头和数据")
        print("=" * 60)
        
        # 打印更多行来理解结构
        print("\n前20行数据:")
        for i in range(min(20, len(df))):
            row = df.iloc[i]
            print(f"Row {i}: {row.values}")
        
        # 尝试找到包含"销售额"、"成本"等关键词的行
        print("\n查找关键词行:")
        keywords = ['销售额', '成本', '利润', '广告', '市场份额', '价格', '功能', '销量']
        for keyword in keywords:
            for i in range(len(df)):
                row_str = ' '.join([str(x) for x in df.iloc[i].values if pd.notna(x)])
                if keyword in row_str:
                    print(f"找到'{keyword}'在行{i}: {row_str[:100]}")

if __name__ == "__main__":
    analyze_r02_data('results-r02.xls')

