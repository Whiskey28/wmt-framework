#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
尖峰时刻商业模拟 - 第一回合数据分析脚本
"""
import pandas as pd
import numpy as np
import json
from collections import defaultdict

# 读取CSV数据
df = pd.read_csv('results-r01.csv', header=None)

# 队伍名称（Hades是第5列，索引为4）
TEAM_NAMES = ['万物生长ING', '津门创赋奇谭', '虚怀若谷', 'Hades', '从容应队', 
              '高雅人士队', 'PHY柿柿如意', '"烽"狂输出队', '决策全都队', '星河万里']
HADES_INDEX = 4  # Hades在队伍列表中的索引

# 市场名称
MARKETS = ['美国', '亚洲', '欧洲']
TECHNOLOGIES = ['技术1', '技术2']

# 汇率（第二回合）
EXCHANGE_RATES = {
    'RMB': 0.1235,  # 1 RMB = 0.1235 USD
    'EUR': 1.4400   # 1 EUR = 1.4400 USD
}

# 运输和关税成本（第二回合，USD/件）
SHIPPING_COSTS = {
    '美国->亚洲': 15.0 + 12.0,  # 运输15 + 关税12
    '美国->欧洲': 9.0 + 3.0,    # 运输9 + 关税3
    '亚洲->美国': 15.0 + 12.0,  # 运输15 + 关税12
    '亚洲->欧洲': 5.0 + 3.0     # 运输5 + 关税3
}

# 功能成本（USD/功能/件）
FEATURE_COST_PER_UNIT = 6.0

def find_section(df, section_name):
    """查找数据段"""
    for idx, row in df.iterrows():
        if pd.notna(row[0]) and section_name in str(row[0]):
            return idx
    return None

def extract_market_data(df, market_name, team_index):
    """提取特定市场的数据"""
    section_start = find_section(df, f'市场报告, {market_name}')
    if section_start is None:
        return None
    
    data = {}
    
    # 查找技术1和技术2的数据
    for tech_idx, tech in enumerate(['技术1', '技术2'], 1):
        tech_start = find_section(df.iloc[section_start:], tech)
        if tech_start is None:
            continue
        
        tech_start += section_start
        tech_data = {}
        
        # 提取价格、功能、广告、销量数据
        for i in range(tech_start, min(tech_start + 20, len(df))):
            row = df.iloc[i]
            if pd.isna(row[0]):
                continue
            
            label = str(row[0]).strip()
            value = row[team_index + 1] if team_index + 1 < len(row) else None
            
            if '售价' in label or '价格' in label:
                tech_data['price'] = value
            elif '功能' in label and '数量' in label:
                tech_data['features'] = value
            elif '广告' in label:
                tech_data['advertising'] = value
            elif '销售' in label and '千件' in label:
                tech_data['sales'] = value
        
        data[tech] = tech_data
    
    # 提取市场份额
    market_share_start = find_section(df.iloc[section_start:], f'{market_name} 市场份额')
    if market_share_start:
        market_share_start += section_start
        for i in range(market_share_start, min(market_share_start + 10, len(df))):
            row = df.iloc[i]
            if pd.notna(row[0]) and '技术' in str(row[0]):
                tech_name = str(row[0]).strip()
                if tech_name in data:
                    share = row[team_index + 1] if team_index + 1 < len(row) else None
                    if pd.notna(share):
                        data[tech_name]['market_share'] = share
    
    return data

def extract_global_data(df, team_index):
    """提取全球数据"""
    data = {}
    
    # 提取损益表数据
    pnl_start = find_section(df, '损益表, 千 USD, 全球')
    if pnl_start:
        for i in range(pnl_start, min(pnl_start + 30, len(df))):
            row = df.iloc[i]
            if pd.isna(row[0]):
                continue
            
            label = str(row[0]).strip()
            value = row[team_index + 1] if team_index + 1 < len(row) else None
            
            if '销售额' in label and '合计' not in label:
                data['sales_revenue'] = value
            elif '自身生产成本' in label:
                data['own_production_cost'] = value
            elif '功能成本' in label:
                data['feature_cost'] = value
            elif '外包生产成本' in label:
                data['outsourcing_cost'] = value
            elif '运输和关税' in label:
                data['shipping_tariff'] = value
            elif '广告' in label:
                data['advertising'] = value
            elif '研发' in label:
                data['rd'] = value
            elif '本回合利润' in label:
                data['net_profit'] = value
    
    # 提取资产负债表数据
    balance_start = find_section(df, '资产负债表, 千 USD, 全球')
    if balance_start:
        for i in range(balance_start, min(balance_start + 20, len(df))):
            row = df.iloc[i]
            if pd.isna(row[0]):
                continue
            
            label = str(row[0]).strip()
            value = row[team_index + 1] if team_index + 1 < len(row) else None
            
            if '现金及等价物' in label:
                data['cash'] = value
            elif '短期贷款' in label:
                data['short_term_loan'] = value
            elif '长期贷款' in label:
                data['long_term_loan'] = value
    
    return data

def extract_all_teams_market_data(df, market_name):
    """提取所有队伍的市场数据"""
    section_start = find_section(df, f'市场报告, {market_name}')
    if section_start is None:
        return None
    
    teams_data = {}
    
    # 查找技术1和技术2的数据
    for tech in ['技术1', '技术2']:
        tech_start = find_section(df.iloc[section_start:], tech)
        if tech_start is None:
            continue
        
        tech_start += section_start
        tech_data = {}
        
        # 提取所有队伍的价格、功能、广告、销量
        for i in range(tech_start, min(tech_start + 20, len(df))):
            row = df.iloc[i]
            if pd.isna(row[0]):
                continue
            
            label = str(row[0]).strip()
            
            if '售价' in label or '价格' in label:
                for team_idx in range(len(TEAM_NAMES)):
                    value = row[team_idx + 1] if team_idx + 1 < len(row) else None
                    if pd.notna(value):
                        if team_idx not in tech_data:
                            tech_data[team_idx] = {}
                        tech_data[team_idx]['price'] = value
            elif '功能' in label and '数量' in label:
                for team_idx in range(len(TEAM_NAMES)):
                    value = row[team_idx + 1] if team_idx + 1 < len(row) else None
                    if pd.notna(value):
                        if team_idx not in tech_data:
                            tech_data[team_idx] = {}
                        tech_data[team_idx]['features'] = value
            elif '广告' in label:
                for team_idx in range(len(TEAM_NAMES)):
                    value = row[team_idx + 1] if team_idx + 1 < len(row) else None
                    if pd.notna(value):
                        if team_idx not in tech_data:
                            tech_data[team_idx] = {}
                        tech_data[team_idx]['advertising'] = value
            elif '销售' in label and '千件' in label:
                for team_idx in range(len(TEAM_NAMES)):
                    value = row[team_idx + 1] if team_idx + 1 < len(row) else None
                    if pd.notna(value):
                        if team_idx not in tech_data:
                            tech_data[team_idx] = {}
                        tech_data[team_idx]['sales'] = value
        
        teams_data[tech] = tech_data
    
    # 提取市场份额
    market_share_start = find_section(df.iloc[section_start:], f'{market_name} 市场份额')
    if market_share_start:
        market_share_start += section_start
        for i in range(market_share_start, min(market_share_start + 10, len(df))):
            row = df.iloc[i]
            if pd.notna(row[0]) and '技术' in str(row[0]):
                tech_name = str(row[0]).strip()
                if tech_name in teams_data:
                    for team_idx in range(len(TEAM_NAMES)):
                        share = row[team_idx + 1] if team_idx + 1 < len(row) else None
                        if pd.notna(share):
                            if team_idx not in teams_data[tech_name]:
                                teams_data[tech_name][team_idx] = {}
                            teams_data[tech_name][team_idx]['market_share'] = share
    
    return teams_data

def calculate_unit_economics(hades_data, market_data, market_name, tech_name):
    """计算单位经济模型"""
    if tech_name not in market_data:
        return None
    
    tech_data = market_data[tech_name]
    if not tech_data or 'price' not in tech_data or 'sales' not in tech_data:
        return None
    
    # 基础数据
    price = float(tech_data.get('price', 0)) if pd.notna(tech_data.get('price')) else 0
    sales = float(tech_data.get('sales', 0)) if pd.notna(tech_data.get('sales')) else 0
    features = float(tech_data.get('features', 0)) if pd.notna(tech_data.get('features')) else 0
    advertising = float(tech_data.get('advertising', 0)) if pd.notna(tech_data.get('advertising')) else 0
    
    if sales == 0:
        return None
    
    # 转换价格到USD（如果需要）
    if market_name == '亚洲' and 'RMB' in str(tech_data.get('price', '')):
        price_usd = price * EXCHANGE_RATES['RMB']
    elif market_name == '欧洲' and 'EUR' in str(tech_data.get('price', '')):
        price_usd = price * EXCHANGE_RATES['EUR']
    else:
        price_usd = price
    
    # 计算单位成本
    # 从全球数据中提取总成本，然后按销量分摊
    total_production_cost = float(hades_data.get('own_production_cost', 0) or 0) + \
                           float(hades_data.get('outsourcing_cost', 0) or 0)
    total_feature_cost = float(hades_data.get('feature_cost', 0) or 0)
    total_shipping = float(hades_data.get('shipping_tariff', 0) or 0)
    total_advertising = float(hades_data.get('advertising', 0) or 0)
    
    # 计算该市场该技术的总销量（需要从销量数据中提取）
    # 这里简化处理，假设按广告投入比例分摊
    total_advertising_all = total_advertising
    if total_advertising_all > 0:
        advertising_ratio = advertising / total_advertising_all
    else:
        advertising_ratio = 1.0 / 6  # 假设6个市场技术组合平均分配
    
    # 单位成本估算
    unit_production_cost = (total_production_cost * advertising_ratio) / sales if sales > 0 else 0
    unit_feature_cost = (features * FEATURE_COST_PER_UNIT) if features > 0 else 0
    
    # 运输关税（根据市场）
    if market_name == '亚洲':
        unit_shipping = SHIPPING_COSTS['美国->亚洲']
    elif market_name == '欧洲':
        unit_shipping = SHIPPING_COSTS['美国->欧洲']
    else:
        unit_shipping = 0
    
    unit_advertising = advertising / sales if sales > 0 else 0
    
    # 管理成本分摊（简化：按销量比例）
    # 固定管理成本：美国35000，亚洲10000，欧洲10000
    fixed_admin = {
        '美国': 35000,
        '亚洲': 10000,
        '欧洲': 10000
    }.get(market_name, 0)
    unit_admin = fixed_admin / sales if sales > 0 else 0
    
    unit_total_cost = unit_production_cost + unit_feature_cost + unit_shipping + unit_advertising + unit_admin
    
    # 单位贡献利润
    unit_contribution = price_usd - unit_total_cost
    
    # 贡献利润率
    contribution_margin = (unit_contribution / price_usd * 100) if price_usd > 0 else 0
    
    # 总贡献利润
    total_contribution = unit_contribution * sales
    
    return {
        'market': market_name,
        'technology': tech_name,
        'price_usd': price_usd,
        'sales': sales,
        'features': features,
        'advertising': advertising,
        'unit_production_cost': unit_production_cost,
        'unit_feature_cost': unit_feature_cost,
        'unit_shipping': unit_shipping,
        'unit_advertising': unit_advertising,
        'unit_admin': unit_admin,
        'unit_total_cost': unit_total_cost,
        'unit_contribution': unit_contribution,
        'contribution_margin': contribution_margin,
        'total_contribution': total_contribution
    }

def analyze_competition(all_teams_data, market_name, tech_name):
    """分析竞争态势"""
    if market_name not in all_teams_data or tech_name not in all_teams_data[market_name]:
        return None
    
    teams_data = all_teams_data[market_name][tech_name]
    
    prices = []
    features = []
    advertising = []
    market_shares = []
    
    for team_idx, data in teams_data.items():
        if 'price' in data and pd.notna(data['price']):
            price = float(data['price'])
            # 转换到USD
            if market_name == '亚洲':
                price *= EXCHANGE_RATES['RMB']
            elif market_name == '欧洲':
                price *= EXCHANGE_RATES['EUR']
            prices.append(price)
        
        if 'features' in data and pd.notna(data['features']):
            features.append(float(data['features']))
        
        if 'advertising' in data and pd.notna(data['advertising']):
            advertising.append(float(data['advertising']))
        
        if 'market_share' in data and pd.notna(data['market_share']):
            market_shares.append(float(data['market_share']))
    
    if not prices:
        return None
    
    hades_data = teams_data.get(HADES_INDEX, {})
    hades_price = float(hades_data.get('price', 0)) if 'price' in hades_data and pd.notna(hades_data.get('price')) else 0
    if market_name == '亚洲' and hades_price > 0:
        hades_price *= EXCHANGE_RATES['RMB']
    elif market_name == '欧洲' and hades_price > 0:
        hades_price *= EXCHANGE_RATES['EUR']
    
    hades_features = float(hades_data.get('features', 0)) if 'features' in hades_data and pd.notna(hades_data.get('features')) else 0
    hades_advertising = float(hades_data.get('advertising', 0)) if 'advertising' in hades_data and pd.notna(hades_data.get('advertising')) else 0
    hades_share = float(hades_data.get('market_share', 0)) if 'market_share' in hades_data and pd.notna(hades_data.get('market_share')) else 0
    
    avg_price = np.mean(prices) if prices else 0
    avg_features = np.mean(features) if features else 0
    avg_advertising = np.mean(advertising) if advertising else 0
    
    price_competitiveness = ((avg_price - hades_price) / avg_price * 100) if avg_price > 0 else 0
    feature_competitiveness = ((hades_features - avg_features) / avg_features * 100) if avg_features > 0 else 0
    advertising_competitiveness = ((hades_advertising - avg_advertising) / avg_advertising * 100) if avg_advertising > 0 else 0
    
    # 竞争强度评分（1-5）
    # 基于价格分散度、功能分散度、广告投入水平
    price_std = np.std(prices) if len(prices) > 1 else 0
    feature_std = np.std(features) if len(features) > 1 else 0
    
    competition_intensity = 3  # 默认中等
    if avg_advertising > 50000:  # 高广告投入
        competition_intensity += 1
    if price_std < avg_price * 0.1:  # 价格战
        competition_intensity += 1
    if avg_features > 5:  # 功能军备竞赛
        competition_intensity += 1
    
    competition_intensity = min(5, max(1, competition_intensity))
    
    return {
        'market': market_name,
        'technology': tech_name,
        'hades_price': hades_price,
        'avg_price': avg_price,
        'price_competitiveness': price_competitiveness,
        'hades_features': hades_features,
        'avg_features': avg_features,
        'feature_competitiveness': feature_competitiveness,
        'hades_advertising': hades_advertising,
        'avg_advertising': avg_advertising,
        'advertising_competitiveness': advertising_competitiveness,
        'hades_market_share': hades_share,
        'competition_intensity': competition_intensity
    }

# 主分析流程
print("开始分析数据...")

# 提取Hades的全球数据
hades_global = extract_global_data(df, HADES_INDEX)
print(f"Hades全球数据提取完成")

# 提取Hades各市场数据
hades_market_data = {}
for market in MARKETS:
    hades_market_data[market] = extract_market_data(df, market, HADES_INDEX)
    print(f"Hades {market}市场数据提取完成")

# 提取所有队伍的市场数据
all_teams_market_data = {}
for market in MARKETS:
    all_teams_market_data[market] = extract_all_teams_market_data(df, market)
    print(f"所有队伍 {market}市场数据提取完成")

# 计算单位经济模型
unit_economics = []
for market in MARKETS:
    for tech in TECHNOLOGIES:
        economics = calculate_unit_economics(hades_global, hades_market_data[market], market, tech)
        if economics:
            unit_economics.append(economics)

# 分析竞争态势
competition_analysis = []
for market in MARKETS:
    for tech in TECHNOLOGIES:
        comp = analyze_competition(all_teams_market_data, market, tech)
        if comp:
            competition_analysis.append(comp)

# 保存分析结果
results = {
    'hades_global': hades_global,
    'hades_market_data': hades_market_data,
    'unit_economics': unit_economics,
    'competition_analysis': competition_analysis
}

with open('analysis_results.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=2, default=str)

print("分析完成，结果已保存到 analysis_results.json")

