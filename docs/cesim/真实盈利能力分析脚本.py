"""
真实盈利能力分析脚本
用于识别转移定价影响，计算真实市场层面利润
"""

import pandas as pd
import numpy as np

# ==================== 配置参数 ====================

# 单位功能成本（USD/功能/件）
FEATURE_COST_PER_UNIT = 6.0

# 运输关税成本（USD/件）
SHIPPING_COSTS = {
    '美国->亚洲': 27.0,
    '美国->欧洲': 12.0,
    '亚洲->欧洲': 8.0,
    '亚洲->美国': 30.0,
    '欧洲->美国': 15.0,
    '欧洲->亚洲': 10.0,
    '本地': 0.0
}

# ==================== 数据类定义 ====================

class MarketTechData:
    """市场×技术的数据类"""
    def __init__(self, team, market, tech):
        self.team = team
        self.market = market
        self.tech = tech
        
        # 基础数据
        self.price = 0.0  # 售价
        self.sales = 0.0  # 销量（千件）
        self.features = 0  # 功能数
        self.advertising = 0.0  # 广告投入（千USD）
        
        # 财务数据（从边际计算表）
        self.revenue = 0.0  # 销售额（千USD）
        self.total_cost = 0.0  # 成本总额（可能含转移定价，千USD）
        self.sales_profit = 0.0  # 销售利润（千USD）
        self.gross_margin = 0.0  # 毛利（千USD）
        
        # 成本明细（需要计算或提取）
        self.unit_production_cost = 0.0  # 单位生产成本
        self.unit_feature_cost = 0.0  # 单位功能成本
        self.unit_shipping_cost = 0.0  # 单位运输关税
        self.unit_advertising_cost = 0.0  # 单位广告成本
        
        # 真实市场层面利润
        self.unit_direct_cost = 0.0  # 单位直接成本
        self.unit_contribution_margin = 0.0  # 单位贡献利润
        self.market_level_profit = 0.0  # 市场层面利润
        self.market_level_margin = 0.0  # 市场层面利润率
    
    def calculate_unit_feature_cost(self):
        """计算单位功能成本"""
        self.unit_feature_cost = self.features * FEATURE_COST_PER_UNIT
        return self.unit_feature_cost
    
    def calculate_unit_advertising_cost(self):
        """计算单位广告成本"""
        if self.sales > 0:
            self.unit_advertising_cost = self.advertising / self.sales
        else:
            self.unit_advertising_cost = 0.0
        return self.unit_advertising_cost
    
    def calculate_unit_shipping_cost(self, production_location, shipping_route=None):
        """
        计算单位运输关税成本
        
        Args:
            production_location: 生产地（'美国'、'亚洲'、'欧洲'）
            shipping_route: 运输路线（如果已知），否则根据生产地和销售地自动确定
        """
        if shipping_route:
            self.unit_shipping_cost = SHIPPING_COSTS.get(shipping_route, 0.0)
        else:
            # 自动确定运输路线
            route = self._determine_shipping_route(production_location)
            self.unit_shipping_cost = SHIPPING_COSTS.get(route, 0.0)
        return self.unit_shipping_cost
    
    def _determine_shipping_route(self, production_location):
        """根据生产地和销售地确定运输路线"""
        if production_location == self.market:
            return '本地'
        
        route = f"{production_location}->{self.market}"
        return route
    
    def calculate_market_direct_cost(self, unit_production_cost, production_location=None):
        """
        计算市场直接成本
        
        Args:
            unit_production_cost: 单位生产成本（需要外部提供）
            production_location: 生产地（用于计算运输关税）
        """
        # 计算各项单位成本
        self.unit_production_cost = unit_production_cost
        self.calculate_unit_feature_cost()
        self.calculate_unit_advertising_cost()
        
        if production_location:
            self.calculate_unit_shipping_cost(production_location)
        
        # 单位直接成本
        self.unit_direct_cost = (
            self.unit_production_cost +
            self.unit_feature_cost +
            self.unit_shipping_cost +
            self.unit_advertising_cost
        )
        
        # 总市场直接成本
        total_direct_cost = self.unit_direct_cost * self.sales
        
        return total_direct_cost
    
    def calculate_market_level_profit(self, unit_production_cost, production_location=None):
        """
        计算真实市场层面利润
        
        Args:
            unit_production_cost: 单位生产成本
            production_location: 生产地
        """
        total_direct_cost = self.calculate_market_direct_cost(
            unit_production_cost, production_location
        )
        
        # 市场层面利润
        self.market_level_profit = self.revenue - total_direct_cost
        
        # 市场层面利润率
        if self.revenue > 0:
            self.market_level_margin = (self.market_level_profit / self.revenue) * 100
        else:
            self.market_level_margin = 0.0
        
        # 单位贡献利润
        self.unit_contribution_margin = (
            self.price - self.unit_direct_cost
        )
        
        return self.market_level_profit
    
    def to_dict(self):
        """转换为字典，便于导出"""
        return {
            '队伍': self.team,
            '市场': self.market,
            '技术': self.tech,
            '售价': self.price,
            '销量(千件)': self.sales,
            '功能数': self.features,
            '广告投入(千USD)': self.advertising,
            '销售额(千USD)': self.revenue,
            '成本总额(千USD)': self.total_cost,
            '单位生产成本': self.unit_production_cost,
            '单位功能成本': self.unit_feature_cost,
            '单位运输关税': self.unit_shipping_cost,
            '单位广告成本': self.unit_advertising_cost,
            '单位直接成本': self.unit_direct_cost,
            '单位贡献利润': self.unit_contribution_margin,
            '市场层面利润(千USD)': self.market_level_profit,
            '市场层面利润率(%)': self.market_level_margin,
        }

# ==================== 分析函数 ====================

def estimate_unit_production_cost(total_cost, sales, features, advertising, shipping_cost_per_unit):
    """
    从总成本中估算单位生产成本
    
    方法：从总成本中扣除功能成本、广告成本、运输关税，剩余即为生产成本
    """
    if sales == 0:
        return 0.0
    
    # 计算各项成本
    total_feature_cost = features * FEATURE_COST_PER_UNIT * sales
    total_shipping_cost = shipping_cost_per_unit * sales
    
    # 生产成本 = 总成本 - 功能成本 - 广告成本 - 运输关税
    total_production_cost = (
        total_cost - 
        total_feature_cost - 
        advertising - 
        total_shipping_cost
    )
    
    unit_production_cost = total_production_cost / sales if sales > 0 else 0.0
    
    return max(0, unit_production_cost)  # 确保不为负


def analyze_transfer_pricing(data_list):
    """
    分析转移定价
    
    识别可能存在转移定价的情况：
    1. 单位成本显著偏离市场平均
    2. 跨市场利润率差异巨大
    """
    # 按市场和技术分组
    market_tech_groups = {}
    for data in data_list:
        key = (data.market, data.tech)
        if key not in market_tech_groups:
            market_tech_groups[key] = []
        market_tech_groups[key].append(data)
    
    transfer_pricing_flags = []
    
    # 对每个市场×技术组合进行分析
    for (market, tech), data_list in market_tech_groups.items():
        # 计算市场平均单位直接成本
        avg_unit_direct_cost = np.mean([
            d.unit_direct_cost for d in data_list if d.unit_direct_cost > 0
        ])
        
        # 计算市场平均利润率
        avg_margin = np.mean([
            d.market_level_margin for d in data_list if d.market_level_margin != 0
        ])
        
        # 检查每个队伍
        for data in data_list:
            flags = []
            
            # 检查1：单位成本偏离度
            if avg_unit_direct_cost > 0:
                cost_deviation = (
                    (data.unit_direct_cost - avg_unit_direct_cost) / 
                    avg_unit_direct_cost * 100
                )
                if abs(cost_deviation) > 20:
                    flags.append(f"单位成本偏离市场平均{cost_deviation:.1f}%")
            
            # 检查2：利润率偏离度
            if avg_margin != 0:
                margin_deviation = data.market_level_margin - avg_margin
                if abs(margin_deviation) > 15:
                    flags.append(f"利润率偏离市场平均{margin_deviation:.1f}%")
            
            if flags:
                transfer_pricing_flags.append({
                    '队伍': data.team,
                    '市场': data.market,
                    '技术': data.tech,
                    '警告': ' | '.join(flags)
                })
    
    return transfer_pricing_flags


def cross_market_analysis(data_list, team):
    """
    跨市场对比分析
    
    分析同一队伍在不同市场的真实盈利能力，识别转移定价
    """
    team_data = [d for d in data_list if d.team == team]
    
    if not team_data:
        return None
    
    results = []
    for data in team_data:
        results.append({
            '市场': data.market,
            '技术': data.tech,
            '市场层面利润率(%)': data.market_level_margin,
            '单位贡献利润': data.unit_contribution_margin,
            '市场层面利润(千USD)': data.market_level_profit,
        })
    
    # 检查利润率差异
    margins = [r['市场层面利润率(%)'] for r in results]
    if len(margins) > 1:
        margin_range = max(margins) - min(margins)
        if margin_range > 15:
            print(f"⚠️  {team}在不同市场的利润率差异为{margin_range:.1f}%，可能存在转移定价")
    
    return results


# ==================== 主分析函数 ====================

def analyze_real_profitability(market_report_df, margin_calc_df, 
                                production_location='美国',
                                unit_production_cost_estimate=None):
    """
    主分析函数：计算真实市场层面盈利能力
    
    Args:
        market_report_df: 市场报告数据框（包含价格、功能、广告、销量）
        margin_calc_df: 边际计算数据框（包含销售额、成本、利润）
        production_location: 生产地（用于计算运输关税）
        unit_production_cost_estimate: 单位生产成本估算值（字典：{队伍: {市场: {技术: 成本}}}）
    """
    all_data = []
    
    # 遍历每个队伍、市场、技术
    for _, market_row in market_report_df.iterrows():
        team = market_row.get('队伍')
        market = market_row.get('市场')
        tech = market_row.get('技术')
        
        if not all([team, market, tech]):
            continue
        
        # 创建数据对象
        data = MarketTechData(team, market, tech)
        
        # 从市场报告提取数据
        data.price = float(market_row.get('价格', 0) or 0)
        data.sales = float(market_row.get('销量', 0) or 0)
        data.features = int(market_row.get('功能', 0) or 0)
        data.advertising = float(market_row.get('广告', 0) or 0)
        
        # 从边际计算表提取数据
        margin_row = margin_calc_df[
            (margin_calc_df['队伍'] == team) &
            (margin_calc_df['市场'] == market) &
            (margin_calc_df['技术'] == tech)
        ]
        
        if not margin_row.empty:
            row = margin_row.iloc[0]
            data.revenue = float(row.get('销售额', 0) or 0)
            data.total_cost = float(row.get('成本总额', 0) or 0)
            data.sales_profit = float(row.get('销售利润', 0) or 0)
            data.gross_margin = float(row.get('毛利', 0) or 0)
            
            # 估算单位生产成本
            if unit_production_cost_estimate:
                cost = unit_production_cost_estimate.get(team, {}).get(market, {}).get(tech)
                if cost:
                    unit_prod_cost = cost
                else:
                    # 从总成本反推
                    unit_prod_cost = estimate_unit_production_cost(
                        data.total_cost,
                        data.sales,
                        data.features,
                        data.advertising,
                        SHIPPING_COSTS.get(f"{production_location}->{market}", 0)
                    )
            else:
                # 从总成本反推
                unit_prod_cost = estimate_unit_production_cost(
                    data.total_cost,
                    data.sales,
                    data.features,
                    data.advertising,
                    SHIPPING_COSTS.get(f"{production_location}->{market}", 0)
                )
            
            # 计算真实市场层面利润
            data.calculate_market_level_profit(
                unit_prod_cost,
                production_location
            )
            
            all_data.append(data)
    
    return all_data


# ==================== 输出函数 ====================

def generate_profitability_ranking(data_list, market=None, tech=None):
    """
    生成盈利能力排名表
    
    Args:
        data_list: MarketTechData列表
        market: 指定市场（可选）
        tech: 指定技术（可选）
    """
    # 筛选数据
    filtered_data = data_list
    if market:
        filtered_data = [d for d in filtered_data if d.market == market]
    if tech:
        filtered_data = [d for d in filtered_data if d.tech == tech]
    
    # 按市场层面利润排序
    sorted_data = sorted(
        filtered_data,
        key=lambda x: x.market_level_profit,
        reverse=True
    )
    
    # 转换为DataFrame
    results = [d.to_dict() for d in sorted_data]
    df = pd.DataFrame(results)
    
    return df


def generate_report(data_list, output_file='真实盈利能力分析报告.xlsx'):
    """
    生成完整分析报告
    
    包含：
    1. 真实盈利能力排名（按市场层面利润）
    2. 单位贡献利润排名
    3. 转移定价识别
    4. 跨市场对比分析
    """
    writer = pd.ExcelWriter(output_file, engine='openpyxl')
    
    # 1. 所有数据汇总
    all_results = [d.to_dict() for d in data_list]
    df_all = pd.DataFrame(all_results)
    df_all.to_excel(writer, sheet_name='全部数据', index=False)
    
    # 2. 按市场层面利润排名
    df_profit_rank = generate_profitability_ranking(data_list)
    df_profit_rank.to_excel(writer, sheet_name='利润排名', index=False)
    
    # 3. 按单位贡献利润排名
    df_sorted = sorted(data_list, key=lambda x: x.unit_contribution_margin, reverse=True)
    df_unit_rank = pd.DataFrame([d.to_dict() for d in df_sorted])
    df_unit_rank.to_excel(writer, sheet_name='单位贡献利润排名', index=False)
    
    # 4. 转移定价识别
    transfer_flags = analyze_transfer_pricing(data_list)
    if transfer_flags:
        df_transfer = pd.DataFrame(transfer_flags)
        df_transfer.to_excel(writer, sheet_name='转移定价警告', index=False)
    
    # 5. 按市场和技术分组排名
    markets = set(d.market for d in data_list)
    techs = set(d.tech for d in data_list)
    
    for market in markets:
        for tech in techs:
            df_rank = generate_profitability_ranking(data_list, market=market, tech=tech)
            if not df_rank.empty:
                sheet_name = f"{market}_{tech}"[:31]  # Excel限制31字符
                df_rank.to_excel(writer, sheet_name=sheet_name, index=False)
    
    writer.close()
    print(f"✅ 分析报告已生成：{output_file}")


# ==================== 示例使用 ====================

if __name__ == "__main__":
    print("真实盈利能力分析脚本")
    print("=" * 50)
    print("\n使用方法：")
    print("1. 准备市场报告数据框（包含：队伍、市场、技术、价格、功能、广告、销量）")
    print("2. 准备边际计算数据框（包含：队伍、市场、技术、销售额、成本总额、销售利润、毛利）")
    print("3. 调用 analyze_real_profitability() 函数进行分析")
    print("4. 调用 generate_report() 生成报告\n")
    
    print("示例代码：")
    print("""
    # 加载数据
    market_report_df = pd.read_csv('market_report.csv')
    margin_calc_df = pd.read_csv('margin_calc.csv')
    
    # 执行分析
    data_list = analyze_real_profitability(
        market_report_df,
        margin_calc_df,
        production_location='美国'
    )
    
    # 生成报告
    generate_report(data_list, '真实盈利能力分析报告.xlsx')
    
    # 查看排名
    df_rank = generate_profitability_ranking(data_list, market='美国', tech='技术1')
    print(df_rank.head())
    """)

