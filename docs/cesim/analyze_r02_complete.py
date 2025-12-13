"""
第二回合完整数据分析
根据完整分析框架提取所需数据并计算关键指标
"""

import pandas as pd
import numpy as np
import json
from pathlib import Path

# 队伍名称映射（从Excel中提取）
TEAM_NAMES = [
    '万物生长ING', '津门创赋奇谭', '虚怀若谷', 'Hades', '从容应队',
    '高雅人士队', 'PHY柿柿如意', '"烽"狂输出队', '决策全都队', '星河万里'
]

def parse_excel_data(filename='results-r02.xls'):
    """解析Excel数据"""
    
    print("=" * 80)
    print("第二回合数据分析 - 完整框架数据提取")
    print("=" * 80)
    
    # 读取Excel
    df = pd.read_excel(filename, sheet_name='Results', header=None)
    
    # 找到队伍名称行（第4行，索引3）
    team_row_idx = 3
    team_names = df.iloc[team_row_idx, 1:11].values.tolist()
    print(f"\n队伍名称: {team_names}")
    
    # 初始化数据结构
    data = {
        'teams': {},
        'markets': ['美国', '亚洲', '欧洲'],
        'techs': ['技术1', '技术2']
    }
    
    # 解析全局财务数据
    print("\n" + "=" * 80)
    print("1. 全局财务数据")
    print("=" * 80)
    
    global_financial = parse_global_financial(df, team_names)
    data['global_financial'] = global_financial
    
    # 解析各市场各技术数据
    print("\n" + "=" * 80)
    print("2. 各市场各技术数据")
    print("=" * 80)
    
    market_data = parse_market_tech_data(df, team_names)
    data['market_data'] = market_data
    
    # 计算关键指标
    print("\n" + "=" * 80)
    print("3. 计算关键指标")
    print("=" * 80)
    
    indicators = calculate_indicators(data)
    data['indicators'] = indicators
    
    # 生成分析报告
    print("\n" + "=" * 80)
    print("4. 生成分析报告")
    print("=" * 80)
    
    generate_report(data)
    
    return data

def parse_global_financial(df, team_names):
    """解析全局财务数据"""
    
    financial = {}
    
    # 查找关键财务指标
    for idx, row in df.iterrows():
        row_str = str(row.iloc[0]) if pd.notna(row.iloc[0]) else ''
        
        if '销售额' in row_str and '合计' not in row_str:
            # 销售额行
            values = row.iloc[1:11].values
            for i, team in enumerate(team_names):
                if team not in financial:
                    financial[team] = {}
                financial[team]['销售额'] = float(values[i]) if pd.notna(values[i]) else 0
        
        elif '净利润' in row_str or '本回合净利润' in row_str:
            # 净利润行
            values = row.iloc[1:11].values
            for i, team in enumerate(team_names):
                if team in financial:
                    financial[team]['净利润'] = float(values[i]) if pd.notna(values[i]) else 0
        
        elif '现金' in row_str and '千' in row_str:
            # 现金行
            values = row.iloc[1:11].values
            for i, team in enumerate(team_names):
                if team in financial:
                    financial[team]['现金'] = float(values[i]) if pd.notna(values[i]) else 0
        
        elif '广告' in row_str and len(row_str) < 10:
            # 广告投入行
            values = row.iloc[1:11].values
            for i, team in enumerate(team_names):
                if team in financial:
                    financial[team]['广告投入'] = float(values[i]) if pd.notna(values[i]) else 0
        
        elif '研发' in row_str and len(row_str) < 10:
            # 研发投入行
            values = row.iloc[1:11].values
            for i, team in enumerate(team_names):
                if team in financial:
                    financial[team]['研发投入'] = float(values[i]) if pd.notna(values[i]) else 0
    
    # 打印结果
    print("\n全局财务数据:")
    print(f"{'队伍':<15} {'销售额':<15} {'净利润':<15} {'现金':<15} {'广告':<15} {'研发':<15}")
    print("-" * 90)
    for team in team_names:
        if team in financial:
            f = financial[team]
            print(f"{team:<15} {f.get('销售额', 0):>15,.0f} {f.get('净利润', 0):>15,.0f} "
                  f"{f.get('现金', 0):>15,.0f} {f.get('广告投入', 0):>15,.0f} {f.get('研发投入', 0):>15,.0f}")
    
    return financial

def parse_market_tech_data(df, team_names):
    """解析各市场各技术数据"""
    
    market_data = {
        '美国': {'技术1': {}, '技术2': {}},
        '亚洲': {'技术1': {}, '技术2': {}},
        '欧洲': {'技术1': {}, '技术2': {}}
    }
    
    # 查找市场和技术标识
    current_market = None
    current_tech = None
    
    for idx, row in df.iterrows():
        row_str = str(row.iloc[0]) if pd.notna(row.iloc[0]) else ''
        
        # 识别市场
        if '美国' in row_str and '销售额' in row_str:
            current_market = '美国'
        elif '亚洲' in row_str and '销售额' in row_str:
            current_market = '亚洲'
        elif '欧洲' in row_str and '销售额' in row_str:
            current_market = '欧洲'
        
        # 识别技术
        if '技术1' in row_str:
            current_tech = '技术1'
        elif '技术2' in row_str:
            current_tech = '技术2'
        
        # 提取数据
        if current_market and current_tech:
            if '销售额' in row_str:
                values = row.iloc[1:11].values
                for i, team in enumerate(team_names):
                    if team not in market_data[current_market][current_tech]:
                        market_data[current_market][current_tech][team] = {}
                    market_data[current_market][current_tech][team]['销售额'] = float(values[i]) if pd.notna(values[i]) else 0
            
            elif '成本总额' in row_str or '单位销售的成本总额' in row_str:
                values = row.iloc[1:11].values
                for i, team in enumerate(team_names):
                    if team in market_data[current_market][current_tech]:
                        market_data[current_market][current_tech][team]['成本总额'] = float(values[i]) if pd.notna(values[i]) else 0
            
            elif '毛利' in row_str:
                values = row.iloc[1:11].values
                for i, team in enumerate(team_names):
                    if team in market_data[current_market][current_tech]:
                        market_data[current_market][current_tech][team]['毛利'] = float(values[i]) if pd.notna(values[i]) else 0
            
            elif '广告' in row_str and len(row_str) < 10:
                values = row.iloc[1:11].values
                for i, team in enumerate(team_names):
                    if team in market_data[current_market][current_tech]:
                        market_data[current_market][current_tech][team]['广告'] = float(values[i]) if pd.notna(values[i]) else 0
    
    # 查找价格、功能、销量数据（需要根据实际Excel结构调整）
    # 这里先打印找到的数据
    print("\n各市场各技术数据:")
    for market in market_data:
        print(f"\n{market}:")
        for tech in market_data[market]:
            print(f"  {tech}:")
            for team in team_names:
                if team in market_data[market][tech]:
                    data = market_data[market][tech][team]
                    print(f"    {team}: 销售额={data.get('销售额', 0):,.0f}, "
                          f"成本={data.get('成本总额', 0):,.0f}, 毛利={data.get('毛利', 0):,.0f}")
    
    return market_data

def calculate_indicators(data):
    """计算关键指标"""
    
    indicators = {}
    
    # 计算各队伍各市场各技术的指标
    for market in data['market_data']:
        if market not in indicators:
            indicators[market] = {}
        
        for tech in data['market_data'][market]:
            if tech not in indicators[market]:
                indicators[market][tech] = {}
            
            for team, team_data in data['market_data'][market][tech].items():
                if team not in indicators[market][tech]:
                    indicators[market][tech][team] = {}
                
                revenue = team_data.get('销售额', 0)
                cost = team_data.get('成本总额', 0)
                gross_margin = team_data.get('毛利', 0)
                advertising = team_data.get('广告', 0)
                
                # 计算指标
                if revenue > 0:
                    indicators[market][tech][team]['销售利润率'] = (gross_margin / revenue * 100) if revenue > 0 else 0
                    indicators[market][tech][team]['成本率'] = (cost / revenue * 100) if revenue > 0 else 0
                    indicators[market][tech][team]['广告ROI'] = (gross_margin / advertising) if advertising > 0 else 0
                else:
                    indicators[market][tech][team]['销售利润率'] = 0
                    indicators[market][tech][team]['成本率'] = 0
                    indicators[market][tech][team]['广告ROI'] = 0
    
    return indicators

def generate_report(data):
    """生成分析报告"""
    
    report_file = '第二回合数据分析报告.md'
    
    with open(report_file, 'w', encoding='utf-8') as f:
        f.write("# 第二回合数据分析报告\n\n")
        f.write("## 一、全局财务数据\n\n")
        
        # 全局财务排名
        teams = list(data['global_financial'].keys())
        teams_sorted = sorted(teams, key=lambda x: data['global_financial'][x].get('净利润', 0), reverse=True)
        
        f.write("### 净利润排名\n\n")
        f.write("| 排名 | 队伍 | 销售额 | 净利润 | 现金 | 广告投入 | 研发投入 |\n")
        f.write("|------|------|--------|--------|------|----------|----------|\n")
        
        for rank, team in enumerate(teams_sorted, 1):
            fin = data['global_financial'][team]
            f.write(f"| {rank} | {team} | {fin.get('销售额', 0):,.0f} | "
                   f"{fin.get('净利润', 0):,.0f} | {fin.get('现金', 0):,.0f} | "
                   f"{fin.get('广告投入', 0):,.0f} | {fin.get('研发投入', 0):,.0f} |\n")
        
        f.write("\n## 二、各市场各技术数据\n\n")
        
        for market in data['market_data']:
            f.write(f"### {market}\n\n")
            for tech in data['market_data'][market]:
                f.write(f"#### {tech}\n\n")
                f.write("| 队伍 | 销售额 | 成本总额 | 毛利 | 销售利润率 | 成本率 | 广告ROI |\n")
                f.write("|------|--------|----------|------|-----------|--------|---------|\n")
                
                teams_sorted = sorted(
                    data['market_data'][market][tech].keys(),
                    key=lambda x: data['market_data'][market][tech][x].get('毛利', 0),
                    reverse=True
                )
                
                for team in teams_sorted:
                    team_data = data['market_data'][market][tech][team]
                    indicators = data['indicators'][market][tech][team]
                    
                    f.write(f"| {team} | {team_data.get('销售额', 0):,.0f} | "
                           f"{team_data.get('成本总额', 0):,.0f} | {team_data.get('毛利', 0):,.0f} | "
                           f"{indicators.get('销售利润率', 0):.1f}% | {indicators.get('成本率', 0):.1f}% | "
                           f"{indicators.get('广告ROI', 0):.2f} |\n")
                f.write("\n")
    
    print(f"\n✅ 分析报告已生成: {report_file}")

if __name__ == "__main__":
    data = parse_excel_data('results-r02.xls')
    
    # 保存数据为JSON
    with open('第二回合数据.json', 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2, default=str)
    
    print("\n✅ 数据已保存为JSON: 第二回合数据.json")

