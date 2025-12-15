"""
第二回合数据提取和分析
根据Excel数据结构说明提取数据并计算关键指标
"""

import pandas as pd
import numpy as np
import json
from pathlib import Path

# 公司名称和列索引
TEAM_NAMES = [
    '万物生长ING',      # 列索引 1 (pandas索引0: 列1)
    '津门创赋奇谭',     # 列索引 2 (pandas索引1: 列2)
    '虚怀若谷',         # 列索引 3 (pandas索引2: 列3)
    'Hades',           # 列索引 4 (pandas索引3: 列4) ⭐
    '从容应队',         # 列索引 5 (pandas索引4: 列5)
    '高雅人士队',       # 列索引 6 (pandas索引5: 列6)
    'PHY柿柿如意',      # 列索引 7 (pandas索引6: 列7)
    '"烽"狂输出队',     # 列索引 8 (pandas索引7: 列8)
    '决策全都队',       # 列索引 9 (pandas索引8: 列9)
    '星河万里'          # 列索引 10 (pandas索引9: 列10)
]

HADES_COL = 3  # Hades在pandas中的列索引（第4列，索引从0开始）
MARKETS = ['美国', '亚洲', '欧洲']
TECHS = ['技术1', '技术2', '技术3', '技术4']
CURRENCIES = {'美国': 'USD', '亚洲': 'RMB', '欧洲': 'EUR'}

def read_excel_data(filename='results-r02.xls'):
    """读取Excel文件"""
    print(f"正在读取Excel文件: {filename}")
    df = pd.read_excel(filename, sheet_name='Results', header=None)
    print(f"Excel文件读取成功，形状: {df.shape}")
    return df

def find_row_by_keyword(df, keyword, start_row=0, end_row=None):
    """在第一列中查找包含关键词的行"""
    if end_row is None:
        end_row = len(df)
    
    for i in range(start_row, min(end_row, len(df))):
        cell_value = str(df.iloc[i, 0]) if pd.notna(df.iloc[i, 0]) else ''
        if keyword in cell_value:
            return i
    return None

def extract_value(df, row_idx, col_idx, default=0):
    """提取单元格值，转换为浮点数"""
    try:
        value = df.iloc[row_idx, col_idx]
        if pd.isna(value):
            return default
        return float(value)
    except:
        return default

def extract_global_financial(df):
    """提取全局财务数据"""
    print("\n" + "="*80)
    print("1. 提取全局财务数据")
    print("="*80)
    
    financial = {}
    
    # 损益表（5-28行，实际索引4-27）
    income_row_start = 4
    income_row_end = 27
    
    # 提取关键指标
    keywords_map = {
        '销售额合计': '销售额',
        '成本和费用合计': '总成本',
        '本回合净利润': '净利润',
        '广告': '广告投入',
        '研发': '研发投入',
    }
    
    for keyword, key in keywords_map.items():
        row_idx = find_row_by_keyword(df, keyword, income_row_start, income_row_end)
        if row_idx is not None:
            for i, team in enumerate(TEAM_NAMES):
                if team not in financial:
                    financial[team] = {}
                value = extract_value(df, row_idx, i+1)  # i+1因为列从索引1开始（第一列是指标名）
                financial[team][key] = value
    
    # 资产负债表（32-52行，实际索引31-51）
    balance_row_start = 31
    balance_row_end = 51
    
    # 提取现金和贷款
    cash_keywords = ['现金及等价物', '现金']
    for keyword in cash_keywords:
        row_idx = find_row_by_keyword(df, keyword, balance_row_start, balance_row_end)
        if row_idx is not None:
            for i, team in enumerate(TEAM_NAMES):
                if team not in financial:
                    financial[team] = {}
                value = extract_value(df, row_idx, i+1)
                if '现金' not in financial[team] or financial[team]['现金'] == 0:
                    financial[team]['现金'] = value
    
    loan_keywords = ['短期贷款', '长期贷款']
    for keyword in loan_keywords:
        row_idx = find_row_by_keyword(df, keyword, balance_row_start, balance_row_end)
        if row_idx is not None:
            for i, team in enumerate(TEAM_NAMES):
                if team not in financial:
                    financial[team] = {}
                key = '短期贷款' if '短期' in keyword else '长期贷款'
                value = extract_value(df, row_idx, i+1)
                financial[team][key] = value
    
    # 关键财务指标（267-289行，实际索引266-288）
    ratio_row_start = 266
    ratio_row_end = 288
    
    # 提取累计股东回报率
    roe_keywords = ['累计股东回报率', '股东回报率']
    for keyword in roe_keywords:
        row_idx = find_row_by_keyword(df, keyword, ratio_row_start, ratio_row_end)
        if row_idx is not None:
            for i, team in enumerate(TEAM_NAMES):
                if team not in financial:
                    financial[team] = {}
                value = extract_value(df, row_idx, i+1)
                financial[team]['累计股东回报率'] = value
    
    # 打印结果
    print("\n全局财务数据:")
    print(f"{'队伍':<15} {'销售额':<15} {'净利润':<15} {'现金':<15} {'短期贷款':<15} {'累计股东回报率':<15}")
    print("-" * 90)
    
    for team in TEAM_NAMES:
        if team in financial:
            f = financial[team]
            print(f"{team:<15} "
                  f"{f.get('销售额', 0):>15,.0f} "
                  f"{f.get('净利润', 0):>15,.0f} "
                  f"{f.get('现金', 0):>15,.0f} "
                  f"{f.get('短期贷款', 0):>15,.0f} "
                  f"{f.get('累计股东回报率', 0):>15.2f}%")
    
    return financial

def extract_market_data(df):
    """提取各市场各技术数据"""
    print("\n" + "="*80)
    print("2. 提取各市场各技术数据")
    print("="*80)
    
    market_data = {}
    
    # 市场报告行数范围
    market_ranges = {
        '美国': {'start': 300, 'end': 333, 'price_row_offset': 4, 'func_row_offset': 5, 
                'sales_row_offset': 6, 'demand_row_offset': 7, 'share_row_offset': 27},
        '亚洲': {'start': 334, 'end': 367, 'price_row_offset': 3, 'func_row_offset': 4,
                'sales_row_offset': 6, 'demand_row_offset': 7, 'share_row_offset': 26},
        '欧洲': {'start': 368, 'end': 401, 'price_row_offset': 3, 'func_row_offset': 4,
                'sales_row_offset': 6, 'demand_row_offset': 7, 'share_row_offset': 26}
    }
    
    tech_offsets = {
        '技术1': 0,
        '技术2': 6,   # 每个技术间隔6行
        '技术3': 12,
        '技术4': 18
    }
    
    for market in MARKETS:
        market_data[market] = {}
        
        if market not in market_ranges:
            continue
        
        range_info = market_ranges[market]
        start_row = range_info['start'] - 1  # 转换为0索引
        
        for tech in TECHS[:2]:  # 只提取技术1和技术2
            tech_key = tech
            market_data[market][tech_key] = {}
            
            offset = tech_offsets[tech]
            
            # 提取价格
            price_row = start_row + range_info['price_row_offset'] + offset
            # 提取功能数
            func_row = start_row + range_info['func_row_offset'] + offset
            # 提取销量
            sales_row = start_row + range_info['sales_row_offset'] + offset
            # 提取需求
            demand_row = start_row + range_info['demand_row_offset'] + offset
            # 提取市场份额
            share_row = start_row + range_info['share_row_offset'] + offset
            
            for i, team in enumerate(TEAM_NAMES):
                team_data = {
                    '价格': extract_value(df, price_row, i+1, 0),
                    '功能': extract_value(df, func_row, i+1, 0),
                    '销量': extract_value(df, sales_row, i+1, 0),
                    '需求': extract_value(df, demand_row, i+1, 0),
                    '市场份额': extract_value(df, share_row, i+1, 0),
                }
                
                # 计算销售额 = 价格 * 销量
                if team_data['价格'] > 0 and team_data['销量'] > 0:
                    team_data['销售额'] = team_data['价格'] * team_data['销量']
                else:
                    team_data['销售额'] = 0
                
                market_data[market][tech_key][team] = team_data
    
    # 打印Hades的数据
    print("\nHades各市场各技术数据:")
    for market in MARKETS:
        print(f"\n{market}:")
        for tech in ['技术1', '技术2']:
            if tech in market_data[market]:
                data = market_data[market][tech].get('Hades', {})
                print(f"  {tech}:")
                print(f"    价格: {data.get('价格', 0):,.0f} {CURRENCIES[market]}")
                print(f"    功能: {data.get('功能', 0):.0f}")
                print(f"    销量: {data.get('销量', 0):,.0f} 千件")
                print(f"    需求: {data.get('需求', 0):,.0f} 千件")
                print(f"    市场份额: {data.get('市场份额', 0):.2f}%")
                print(f"    销售额: {data.get('销售额', 0):,.0f}")
    
    return market_data

def extract_market_financial(df):
    """提取各市场财务数据"""
    print("\n" + "="*80)
    print("3. 提取各市场财务数据")
    print("="*80)
    
    market_financial = {}
    
    # 各市场损益表行数范围
    income_statement_ranges = {
        '美国': {'start': 53, 'end': 82},
        '亚洲': {'start': 138, 'end': 167},
        '欧洲': {'start': 218, 'end': 242}
    }
    
    for market in MARKETS:
        market_financial[market] = {}
        
        if market not in income_statement_ranges:
            continue
        
        range_info = income_statement_ranges[market]
        start_row = range_info['start'] - 1  # 转换为0索引
        end_row = range_info['end']
        
        # 查找关键指标
        keywords_map = {
            '销售额合计': '销售额',
            '成本和费用合计': '总成本',
            '本回合利润': '利润',
            '广告': '广告',
        }
        
        for keyword, key in keywords_map.items():
            row_idx = find_row_by_keyword(df, keyword, start_row, end_row)
            if row_idx is not None:
                for i, team in enumerate(TEAM_NAMES):
                    if team not in market_financial[market]:
                        market_financial[market][team] = {}
                    value = extract_value(df, row_idx, i+1)
                    market_financial[market][team][key] = value
    
    # 打印Hades的数据
    print("\nHades各市场财务数据:")
    for market in MARKETS:
        if market in market_financial and 'Hades' in market_financial[market]:
            data = market_financial[market]['Hades']
            print(f"{market}: 销售额={data.get('销售额', 0):,.0f}, "
                  f"总成本={data.get('总成本', 0):,.0f}, "
                  f"利润={data.get('利润', 0):,.0f}, "
                  f"广告={data.get('广告', 0):,.0f}")
    
    return market_financial

def calculate_indicators(global_financial, market_data, market_financial):
    """计算关键指标"""
    print("\n" + "="*80)
    print("4. 计算关键指标")
    print("="*80)
    
    indicators = {
        'global': {},
        'market': {}
    }
    
    # 计算全局指标
    hades_global = global_financial.get('Hades', {})
    
    cash = hades_global.get('现金', 0)
    short_loan = hades_global.get('短期贷款', 0)
    min_cash = 6000  # 最低现金要求
    
    indicators['global'] = {
        '可用资金': cash - min_cash - short_loan,
        '现金流健康度': '健康' if (cash - min_cash - short_loan) > 200000 else 
                      '谨慎' if (cash - min_cash - short_loan) > 100000 else '紧张',
        '累计股东回报率': hades_global.get('累计股东回报率', 0),
        '净利润': hades_global.get('净利润', 0),
    }
    
    # 计算各市场各技术指标
    indicators['market'] = {}
    
    for market in MARKETS:
        indicators['market'][market] = {}
        
        for tech in ['技术1', '技术2']:
            if tech not in market_data[market]:
                continue
            
            tech_data = market_data[market][tech].get('Hades', {})
            
            price = tech_data.get('价格', 0)
            func = tech_data.get('功能', 0)
            sales_volume = tech_data.get('销量', 0)
            demand = tech_data.get('需求', 0)
            market_share = tech_data.get('市场份额', 0)
            revenue = tech_data.get('销售额', 0)
            
            # 从市场财务数据获取成本和广告
            market_cost = market_financial.get(market, {}).get('Hades', {}).get('总成本', 0)
            market_ad = market_financial.get(market, {}).get('Hades', {}).get('广告', 0)
            
            # 计算指标
            indicators['market'][market][tech] = {
                '价格竞争力': 0,  # 需要市场平均价格计算
                '功能竞争力': 0,  # 需要市场平均功能计算
                '市场份额变化': 0,  # 需要第一回合数据对比
                '需求满足率': (sales_volume / demand * 100) if demand > 0 else 0,
            }
    
    print("\nHades关键指标:")
    print(f"可用资金: {indicators['global']['可用资金']:,.0f} 千USD")
    print(f"现金流健康度: {indicators['global']['现金流健康度']}")
    print(f"累计股东回报率: {indicators['global']['累计股东回报率']:.2f}%")
    print(f"净利润: {indicators['global']['净利润']:,.0f} 千USD")
    
    return indicators

def generate_report(global_financial, market_data, market_financial, indicators):
    """生成分析报告"""
    print("\n" + "="*80)
    print("5. 生成分析报告")
    print("="*80)
    
    report = []
    report.append("# 第二回合数据分析报告 - Hades\n")
    report.append("## 一、快速诊断\n\n")
    
    # 现金流检查
    available_cash = indicators['global']['可用资金']
    cash_health = indicators['global']['现金流健康度']
    
    report.append("### 1.1 现金流检查\n\n")
    report.append(f"- **可用资金**: {available_cash:,.0f} 千USD\n")
    report.append(f"- **现金流健康度**: {cash_health}\n\n")
    
    if available_cash > 200000:
        report.append("✅ **判断**: 可以激进投入\n\n")
    elif available_cash > 100000:
        report.append("⚠️ **判断**: 谨慎投入\n\n")
    else:
        report.append("❌ **判断**: 防守为主\n\n")
    
    # 盈利能力检查
    net_profit = indicators['global']['净利润']
    roe = indicators['global']['累计股东回报率']
    
    report.append("### 1.2 盈利能力检查\n\n")
    report.append(f"- **净利润**: {net_profit:,.0f} 千USD\n")
    report.append(f"- **累计股东回报率**: {roe:.2f}%\n\n")
    
    # 市场份额检查
    report.append("### 1.3 市场份额检查\n\n")
    report.append("| 市场 | 技术 | 市场份额 | 销量 | 需求 | 需求满足率 |\n")
    report.append("|------|------|----------|------|------|-----------|\n")
    
    for market in MARKETS:
        for tech in ['技术1', '技术2']:
            if tech in market_data[market]:
                data = market_data[market][tech].get('Hades', {})
                market_share = data.get('市场份额', 0)
                sales = data.get('销量', 0)
                demand = data.get('需求', 0)
                satisfy_rate = (sales / demand * 100) if demand > 0 else 0
                
                report.append(f"| {market} | {tech} | {market_share:.2f}% | "
                            f"{sales:,.0f} | {demand:,.0f} | {satisfy_rate:.1f}% |\n")
    
    report.append("\n")
    
    # 保存报告
    report_file = '第二回合数据分析报告.md'
    with open(report_file, 'w', encoding='utf-8') as f:
        f.writelines(report)
    
    print(f"\n✅ 分析报告已生成: {report_file}")
    
    # 保存数据为JSON
    data_file = '第二回合数据.json'
    output_data = {
        'global_financial': global_financial,
        'market_data': market_data,
        'market_financial': market_financial,
        'indicators': indicators
    }
    
    with open(data_file, 'w', encoding='utf-8') as f:
        json.dump(output_data, f, ensure_ascii=False, indent=2, default=str)
    
    print(f"✅ 数据已保存为JSON: {data_file}")

def main():
    """主函数"""
    filename = 'results-r02.xls'
    
    # 读取Excel
    df = read_excel_data(filename)
    
    # 提取数据
    global_financial = extract_global_financial(df)
    market_data = extract_market_data(df)
    market_financial = extract_market_financial(df)
    
    # 计算指标
    indicators = calculate_indicators(global_financial, market_data, market_financial)
    
    # 生成报告
    generate_report(global_financial, market_data, market_financial, indicators)
    
    print("\n" + "="*80)
    print("✅ 数据分析完成！")
    print("="*80)

if __name__ == "__main__":
    main()

