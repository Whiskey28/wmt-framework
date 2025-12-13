"""
调试Excel结构，找到正确的数据位置
"""

import pandas as pd
import sys

# 设置输出编码
if sys.platform == 'win32':
    import io
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def debug_excel(filename='results-r02.xls'):
    """调试Excel结构"""
    print("="*80)
    print("调试Excel结构")
    print("="*80)
    
    df = pd.read_excel(filename, sheet_name='Results', header=None)
    print(f"Excel形状: {df.shape}\n")
    
    # 检查全局损益表（5-28行）
    print("="*80)
    print("检查全局损益表（5-28行，索引4-27）")
    print("="*80)
    for i in range(4, min(28, len(df))):
        row_label = str(df.iloc[i, 0]) if pd.notna(df.iloc[i, 0]) else ''
        if '销售额' in row_label or '净利润' in row_label or '广告' in row_label or '研发' in row_label:
            print(f"\n行{i+1} (索引{i}): {row_label}")
            # 打印Hades的数据（第4列，索引3）
            hades_value = df.iloc[i, 4] if len(df.columns) > 4 else None
            print(f"  Hades (列5, 索引4): {hades_value}")
    
    # 检查全局资产负债表（32-52行）
    print("\n" + "="*80)
    print("检查全局资产负债表（32-52行，索引31-51）")
    print("="*80)
    for i in range(31, min(52, len(df))):
        row_label = str(df.iloc[i, 0]) if pd.notna(df.iloc[i, 0]) else ''
        if '现金' in row_label or '短期贷款' in row_label or '长期贷款' in row_label:
            print(f"\n行{i+1} (索引{i}): {row_label}")
            hades_value = df.iloc[i, 4] if len(df.columns) > 4 else None
            print(f"  Hades (列5, 索引4): {hades_value}")
    
    # 检查累计股东回报率（267-289行）
    print("\n" + "="*80)
    print("检查累计股东回报率（267-289行，索引266-288）")
    print("="*80)
    for i in range(266, min(289, len(df))):
        row_label = str(df.iloc[i, 0]) if pd.notna(df.iloc[i, 0]) else ''
        if '累计股东回报率' in row_label or '股东回报率' in row_label:
            print(f"\n行{i+1} (索引{i}): {row_label}")
            hades_value = df.iloc[i, 4] if len(df.columns) > 4 else None
            print(f"  Hades (列5, 索引4): {hades_value}")
    
    # 检查美国市场报告（301-334行）
    print("\n" + "="*80)
    print("检查美国市场报告（301-334行，索引300-333）")
    print("="*80)
    for i in range(300, min(334, len(df))):
        row_label = str(df.iloc[i, 0]) if pd.notna(df.iloc[i, 0]) else ''
        if '技术1' in row_label or '技术2' in row_label or '售价' in row_label or '功能' in row_label or '销售' in row_label or '需求' in row_label or '市场份额' in row_label:
            print(f"\n行{i+1} (索引{i}): {row_label}")
            hades_value = df.iloc[i, 4] if len(df.columns) > 4 else None
            print(f"  Hades (列5, 索引4): {hades_value}")

if __name__ == "__main__":
    debug_excel('results-r02.xls')

