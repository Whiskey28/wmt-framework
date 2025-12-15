"""
调试Excel数据结构，找到正确的行数
"""

import pandas as pd
import sys

# 设置输出编码
if sys.platform == 'win32':
    import io
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def debug_excel(filename='results-r02.xls'):
    """调试Excel文件，找到关键数据的位置"""
    
    print("="*80)
    print("调试Excel数据结构")
    print("="*80)
    
    df = pd.read_excel(filename, sheet_name='Results', header=None, engine='xlrd')
    
    print(f"\nExcel形状: {df.shape}")
    print(f"列数: {df.shape[1]}")
    
    # 查找Hades列（应该是第4列，索引3）
    print("\n查找Hades列（第4列，索引3）:")
    print("前10行Hades列的数据:")
    for i in range(min(10, len(df))):
        val = df.iloc[i, 3]
        col0 = str(df.iloc[i, 0]) if pd.notna(df.iloc[i, 0]) else ''
        print(f"行{i+1} (索引{i}): 列0='{col0[:30]}', Hades列={val}")
    
    # 查找"销售额合计"
    print("\n查找'销售额合计'行:")
    for i in range(len(df)):
        cell = str(df.iloc[i, 0]) if pd.notna(df.iloc[i, 0]) else ''
        if '销售额合计' in cell or '销售额' in cell:
            print(f"行{i+1} (索引{i}): {cell}")
            print(f"  Hades列值: {df.iloc[i, 3]}")
    
    # 查找"本回合净利润"
    print("\n查找'本回合净利润'行:")
    for i in range(len(df)):
        cell = str(df.iloc[i, 0]) if pd.notna(df.iloc[i, 0]) else ''
        if '本回合净利润' in cell or '净利润' in cell:
            print(f"行{i+1} (索引{i}): {cell}")
            print(f"  Hades列值: {df.iloc[i, 3]}")
    
    # 查找"累计股东回报率"
    print("\n查找'累计股东回报率'行:")
    for i in range(260, 290):
        cell = str(df.iloc[i, 0]) if pd.notna(df.iloc[i, 0]) else ''
        if '累计股东回报率' in cell or '股东回报率' in cell:
            print(f"行{i+1} (索引{i}): {cell}")
            print(f"  Hades列值: {df.iloc[i, 3]}")
    
    # 查找市场报告
    print("\n查找'市场报告,美国'行:")
    for i in range(295, 310):
        cell = str(df.iloc[i, 0]) if pd.notna(df.iloc[i, 0]) else ''
        if '市场报告' in cell and '美国' in cell:
            print(f"行{i+1} (索引{i}): {cell}")
            # 查看接下来几行
            for j in range(i, min(i+10, len(df))):
                cell2 = str(df.iloc[j, 0]) if pd.notna(df.iloc[j, 0]) else ''
                print(f"  行{j+1}: {cell2[:50]}")
            break
    
    # 查找技术1和技术2的价格、功能、销量
    print("\n查找美国市场技术1和技术2的数据:")
    # 美国市场报告应该在301行左右
    for i in range(300, 335):
        cell = str(df.iloc[i, 0]) if pd.notna(df.iloc[i, 0]) else ''
        if '技术1' in cell or '技术2' in cell or '售价' in cell or '功能' in cell or '销售' in cell:
            print(f"行{i+1} (索引{i}): {cell[:50]}")
            if '售价' in cell or '功能' in cell or '销售' in cell:
                print(f"  Hades列值: {df.iloc[i, 3]}")

if __name__ == "__main__":
    debug_excel('results-r02.xls')

