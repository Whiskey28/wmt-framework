"""
第二回合Excel数据精确解析
根据已知行号提取数据
"""

import pandas as pd
import numpy as np
import json
from pathlib import Path

# 队伍名称（从Excel第4行提取，列1-10）
TEAM_NAMES = [
    '万物生长ING', '津门创赋奇谭', '虚怀若谷', 'Hades', '从容应队',
    '高雅人士队', 'PHY柿柿如意', '"烽"狂输出队', '决策全都队', '星河万里'
]

# Excel行号映射
EXCEL_ROWS = {
    'global_income': (5, 28),  # 全局损益表
    'global_balance': (32, 52),  # 全局资产负债表
    'usa_income': (54, 83),  # 美国损益表
    'usa_balance': (84, 108),  # 美国资产负债表
    'parent_cashflow': (109, 138),  # 母公司现金流量表
    'asia_income': (139, 168),  # 亚洲损益表
    'asia_balance': (169, 191),  # 亚洲资产负债表
    'asia_cashflow': (192, 218),  # 亚洲现金流量表
    'europe_income': (219, 243),  # 欧洲损益表
    'europe_balance': (244, 266),  # 欧洲资产负债表
    'financial_ratios': (267, 289),  # 关键财务指标和比率
    'market_global': (291, 300),  # 全球市场报告
    'market_usa': (301, 334),  # 美国市场报告
    'market_asia': (335, 368),  # 亚洲市场报告
    'market_europe': (369, 402),  # 欧洲市场报告
    'production': (403, 460),  # 生产详情
}

def read_excel_section(df, start_row, end_row, team_names):
    """
    读取Excel指定行范围的数据
    
    Args:
        df: DataFrame
        start_row: 起始行（Excel行号，从1开始）
        end_row: 结束行（Excel行号，从1开始）
        team_names: 队伍名称列表
    """
    # Excel行号转pandas索引（从0开始）
    # Excel第1行对应pandas索引0，所以Excel行号-1=pandas索引
    start_idx = start_row - 1
    end_idx = end_row  # 不包含，所以直接用end_row
    
    section_df = df.iloc[start_idx:end_idx, :]
    
    # 第一列是指标名，后续列是各队伍数据
    result = {}
    
    for idx, row in section_df.iterrows():
        indicator = str(row.iloc[0]) if pd.notna(row.iloc[0]) else ''
        
        if indicator and indicator.strip() and indicator != 'nan':
            values = {}
            for i, team in enumerate(team_names):
                col_idx = i + 1  # 第1列是指标名，从第2列开始是队伍数据
                if col_idx < len(row):
                    val = row.iloc[col_idx]
                    if pd.notna(val):
                        try:
                            # 尝试转换为数字
                            if isinstance(val, (int, float)):
                                values[team] = float(val)
                            else:
                                val_str = str(val).strip()
                                if val_str and val_str != 'nan':
                                    try:
                                        values[team] = float(val_str)
                                    except:
                                        values[team] = val_str
                                else:
                                    values[team] = None
                        except:
                            values[team] = str(val) if val else None
                    else:
                        values[team] = None
                else:
                    values[team] = None
            
            result[indicator] = values
    
    return result

def extract_global_financial(df, team_names):
    """提取全局财务数据"""
    
    print("=" * 80)
    print("提取全局财务数据")
    print("=" * 80)
    
    # 全局损益表
    income_data = read_excel_section(df, 5, 28, team_names)
    
    # 全局资产负债表
    balance_data = read_excel_section(df, 32, 52, team_names)
    
    # 提取关键指标
    global_financial = {}
    
    for team in team_names:
        global_financial[team] = {
            '销售额': income_data.get('销售额', {}).get(team, 0),
            '净利润': income_data.get('本回合净利润', {}).get(team, 0),
            '广告投入': income_data.get('广告', {}).get(team, 0),
            '研发投入': income_data.get('研发', {}).get(team, 0),
            '现金': balance_data.get('现金及等价物', {}).get(team, 0),
            '短期贷款': balance_data.get('短期贷款 (无计划)', {}).get(team, 0),
            '长期贷款': balance_data.get('长期贷款', {}).get(team, 0),
        }
    
    # 打印结果
    print("\n全局财务数据:")
    print(f"{'队伍':<15} {'销售额':<15} {'净利润':<15} {'现金':<15} {'广告':<15} {'研发':<15}")
    print("-" * 90)
    for team in team_names:
        f = global_financial[team]
        print(f"{team:<15} {f.get('销售额', 0):>15,.0f} {f.get('净利润', 0):>15,.0f} "
              f"{f.get('现金', 0):>15,.0f} {f.get('广告投入', 0):>15,.0f} {f.get('研发投入', 0):>15,.0f}")
    
    return global_financial

def extract_market_data(df, team_names):
    """提取各市场各技术数据"""
    
    print("\n" + "=" * 80)
    print("提取各市场各技术数据")
    print("=" * 80)
    
    market_data = {
        '美国': {'技术1': {}, '技术2': {}, '技术3': {}, '技术4': {}},
        '亚洲': {'技术1': {}, '技术2': {}, '技术3': {}, '技术4': {}},
        '欧洲': {'技术1': {}, '技术2': {}, '技术3': {}, '技术4': {}}
    }
    
    # 市场报告行号映射
    market_rows = {
        '美国': (301, 334),
        '亚洲': (335, 368),
        '欧洲': (369, 402)
    }
    
    # 货币映射
    currency_map = {
        '美国': 'USD',
        '亚洲': 'RMB',
        '欧洲': 'EUR'
    }
    
    for market_name, (start_row, end_row) in market_rows.items():
        print(f"\n{market_name}市场 (行{start_row}-{end_row}):")
        
        # 读取该市场的数据
        market_section = df.iloc[start_row-1:end_row, :]
        
        current_tech = None
        currency = currency_map[market_name]
        
        for idx, row in market_section.iterrows():
            row_label = str(row.iloc[0]) if pd.notna(row.iloc[0]) else ''
            
            # 识别技术
            if '技术1' in row_label:
                current_tech = '技术1'
            elif '技术2' in row_label:
                current_tech = '技术2'
            elif '技术3' in row_label:
                current_tech = '技术3'
            elif '技术4' in row_label:
                current_tech = '技术4'
            
            # 提取数据
            if current_tech:
                if f'售价, {currency}' in row_label or '售价' in row_label:
                    # 价格数据
                    for i, team in enumerate(team_names):
                        col_idx = i + 1
                        if col_idx < len(row):
                            val = row.iloc[col_idx]
                            if pd.notna(val):
                                try:
                                    if team not in market_data[market_name][current_tech]:
                                        market_data[market_name][current_tech][team] = {}
                                    market_data[market_name][current_tech][team]['价格'] = float(val)
                                except:
                                    pass
                
                elif '所提供的功能数量' in row_label or '功能' in row_label:
                    # 功能数据
                    for i, team in enumerate(team_names):
                        col_idx = i + 1
                        if col_idx < len(row):
                            val = row.iloc[col_idx]
                            if pd.notna(val):
                                try:
                                    if team not in market_data[market_name][current_tech]:
                                        market_data[market_name][current_tech][team] = {}
                                    market_data[market_name][current_tech][team]['功能'] = int(float(val))
                                except:
                                    pass
                
                elif '销售,千件' in row_label or '销售' in row_label:
                    # 销量数据
                    for i, team in enumerate(team_names):
                        col_idx = i + 1
                        if col_idx < len(row):
                            val = row.iloc[col_idx]
                            if pd.notna(val):
                                try:
                                    if team not in market_data[market_name][current_tech]:
                                        market_data[market_name][current_tech][team] = {}
                                    market_data[market_name][current_tech][team]['销量'] = float(val)
                                except:
                                    pass
                
                elif '需求,千件' in row_label or '需求' in row_label:
                    # 需求数据
                    for i, team in enumerate(team_names):
                        col_idx = i + 1
                        if col_idx < len(row):
                            val = row.iloc[col_idx]
                            if pd.notna(val):
                                try:
                                    if team not in market_data[market_name][current_tech]:
                                        market_data[market_name][current_tech][team] = {}
                                    market_data[market_name][current_tech][team]['需求'] = float(val)
                                except:
                                    pass
        
        # 提取市场份额
        share_section = df.iloc[start_row-1:end_row, :]
        for idx, row in share_section.iterrows():
            row_label = str(row.iloc[0]) if pd.notna(row.iloc[0]) else ''
            
            if f'{market_name}市场份额' in row_label or '市场份额' in row_label:
                # 查找技术1/2/3/4的市场份额
                for tech_num in [1, 2, 3, 4]:
                    tech_name = f'技术{tech_num}'
                    # 市场份额通常在技术标题后的行
                    # 这里需要更精确的定位
                    pass
    
    # 打印提取的数据
    for market_name in market_data:
        print(f"\n{market_name}市场数据:")
        for tech_name in market_data[market_name]:
            print(f"  {tech_name}:")
            for team in team_names:
                if team in market_data[market_name][tech_name]:
                    data = market_data[market_name][tech_name][team]
                    print(f"    {team}: 价格={data.get('价格', 'N/A')}, "
                          f"功能={data.get('功能', 'N/A')}, 销量={data.get('销量', 'N/A')}, "
                          f"需求={data.get('需求', 'N/A')}")
    
    return market_data

def extract_financial_ratios(df, team_names):
    """提取关键财务指标和比率"""
    
    print("\n" + "=" * 80)
    print("提取关键财务指标和比率")
    print("=" * 80)
    
    ratios_data = read_excel_section(df, 267, 289, team_names)
    
    financial_ratios = {}
    
    for team in team_names:
        financial_ratios[team] = {
            '累计股东回报率': ratios_data.get('累计股东回报率(p.a.),%', {}).get(team, 0),
            '销售利润率(ROS)': ratios_data.get('销售利润率(ROS)', {}).get(team, 0),
            '股东权益回报率(ROE)': ratios_data.get('股东权益回报率(ROE)', {}).get(team, 0),
            '已动用资本回报率(ROCE)': ratios_data.get('已动用资本回报率(ROCE)', {}).get(team, 0),
        }
    
    # 打印结果
    print("\n关键财务指标:")
    print(f"{'队伍':<15} {'累计股东回报率':<20} {'销售利润率':<15} {'ROE':<15} {'ROCE':<15}")
    print("-" * 90)
    for team in team_names:
        r = financial_ratios[team]
        roi = r.get('累计股东回报率', 0) or 0
        ros = r.get('销售利润率(ROS)', 0) or 0
        roe = r.get('股东权益回报率(ROE)', 0) or 0
        roce = r.get('已动用资本回报率(ROCE)', 0) or 0
        print(f"{team:<15} {roi:>20.2f}% {ros:>15.2f}% {roe:>15.2f}% {roce:>15.2f}%")
    
    return financial_ratios

def calculate_market_indicators(market_data, global_financial):
    """计算市场指标"""
    
    print("\n" + "=" * 80)
    print("计算市场指标")
    print("=" * 80)
    
    indicators = {}
    
    # 这里需要从边际计算表中提取各市场各技术的详细数据
    # 暂时先计算市场份额相关指标
    
    for market in market_data:
        indicators[market] = {}
        for tech in market_data[market]:
            indicators[market][tech] = {}
            
            for team in market_data[market][tech]:
                share = market_data[market][tech][team].get('市场份额', 0)
                indicators[market][tech][team] = {
                    '市场份额': share
                }
    
    return indicators

def generate_analysis_report(data, output_file='第二回合完整分析报告.md'):
    """生成完整分析报告"""
    
    print("\n" + "=" * 80)
    print("生成分析报告")
    print("=" * 80)
    
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("# 第二回合完整分析报告\n\n")
        f.write("## 一、全局财务数据\n\n")
        
        # 全局财务排名
        teams = list(data['global_financial'].keys())
        teams_sorted_by_profit = sorted(teams, key=lambda x: data['global_financial'][x].get('净利润', 0), reverse=True)
        teams_sorted_by_roi = sorted(teams, key=lambda x: data['financial_ratios'][x].get('累计股东回报率', 0), reverse=True)
        
        f.write("### 净利润排名\n\n")
        f.write("| 排名 | 队伍 | 销售额 | 净利润 | 现金 | 广告投入 | 研发投入 |\n")
        f.write("|------|------|--------|--------|------|----------|----------|\n")
        
        for rank, team in enumerate(teams_sorted_by_profit, 1):
            fin = data['global_financial'][team]
            f.write(f"| {rank} | {team} | {fin.get('销售额', 0):,.0f} | "
                   f"{fin.get('净利润', 0):,.0f} | {fin.get('现金', 0):,.0f} | "
                   f"{fin.get('广告投入', 0):,.0f} | {fin.get('研发投入', 0):,.0f} |\n")
        
        f.write("\n### 累计股东回报率排名（最终判定标准）\n\n")
        f.write("| 排名 | 队伍 | 累计股东回报率 | 销售利润率 | ROE | ROCE |\n")
        f.write("|------|------|---------------|-----------|-----|------|\n")
        
        for rank, team in enumerate(teams_sorted_by_roi, 1):
            ratios = data['financial_ratios'][team]
            f.write(f"| {rank} | {team} | {ratios.get('累计股东回报率', 0):.2f}% | "
                   f"{ratios.get('销售利润率(ROS)', 0):.2f}% | "
                   f"{ratios.get('股东权益回报率(ROE)', 0):.2f}% | "
                   f"{ratios.get('已动用资本回报率(ROCE)', 0):.2f}% |\n")
        
        # Hades详细分析
        f.write("\n## 二、Hades详细分析\n\n")
        
        hades_fin = data['global_financial']['Hades']
        hades_ratios = data['financial_ratios']['Hades']
        
        f.write("### 2.1 财务健康度\n\n")
        f.write(f"- **净利润**: {hades_fin.get('净利润', 0):,.0f} 千USD\n")
        f.write(f"- **净利润排名**: {teams_sorted_by_profit.index('Hades') + 1} / {len(teams)}\n")
        f.write(f"- **累计股东回报率**: {hades_ratios.get('累计股东回报率', 0):.2f}%\n")
        f.write(f"- **累计股东回报率排名**: {teams_sorted_by_roi.index('Hades') + 1} / {len(teams)}\n")
        f.write(f"- **现金**: {hades_fin.get('现金', 0):,.0f} 千USD\n")
        f.write(f"- **短期贷款**: {hades_fin.get('短期贷款', 0):,.0f} 千USD\n")
        f.write(f"- **长期贷款**: {hades_fin.get('长期贷款', 0):,.0f} 千USD\n")
        
        # 现金流分析
        available_cash = hades_fin.get('现金', 0) - 6000 - hades_fin.get('短期贷款', 0)
        f.write(f"- **可用资金**: {available_cash:,.0f} 千USD\n")
        
        if available_cash > 200000:
            cash_status = "✅ 充足（可以激进）"
        elif available_cash > 100000:
            cash_status = "⚠️ 中等（谨慎投入）"
        else:
            cash_status = "❌ 紧张（防守为主）"
        
        f.write(f"- **现金流状态**: {cash_status}\n")
        
        f.write("\n### 2.2 各市场各技术市场份额\n\n")
        
        for market in data['market_data']:
            f.write(f"#### {market}\n\n")
            f.write("| 技术 | 市场份额 |\n")
            f.write("|------|----------|\n")
            
            for tech in data['market_data'][market]:
                share = data['market_data'][market][tech].get('Hades', {}).get('市场份额', 0)
                f.write(f"| {tech} | {share:.2f}% |\n")
            f.write("\n")
    
    print(f"\n✅ 分析报告已生成: {output_file}")

def main():
    """主函数"""
    
    filename = 'results-r02.xls'
    
    print("=" * 80)
    print("第二回合Excel数据精确解析")
    print("=" * 80)
    
    # 读取Excel
    print(f"\n读取Excel文件: {filename}")
    df = pd.read_excel(filename, sheet_name='Results', header=None)
    print(f"Excel形状: {df.shape}")
    
    # 提取队伍名称（第5行，列1-10，Excel行号5对应pandas索引4）
    team_row = df.iloc[4, 1:11].values
    team_names = []
    for t in team_row:
        if pd.notna(t):
            t_str = str(t).strip()
            if t_str and t_str != 'nan':
                team_names.append(t_str)
    print(f"\n队伍名称: {team_names}")
    
    # 提取数据
    data = {
        'global_financial': extract_global_financial(df, team_names),
        'market_data': extract_market_data(df, team_names),
        'financial_ratios': extract_financial_ratios(df, team_names),
    }
    
    # 计算指标
    data['indicators'] = calculate_market_indicators(data['market_data'], data['global_financial'])
    
    # 生成报告
    generate_analysis_report(data)
    
    # 保存数据为JSON
    with open('第二回合数据.json', 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2, default=str)
    
    print("\n✅ 数据已保存为JSON: 第二回合数据.json")
    
    return data

if __name__ == "__main__":
    data = main()

