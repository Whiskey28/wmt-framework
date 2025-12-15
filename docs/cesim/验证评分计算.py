"""
验证第二回合美国市场综合评分计算
"""

# 技术1第二回合数据
tech1_r2 = {
    "决策全都队": {
        "毛利": 145294, "毛利排名": 1,
        "市场份额": 14.48, "份额排名": 1,
        "广告ROI": 6.95, "ROI排名": 1,
        "销售利润率": 50.0, "利润率排名": 9,
        "份额增长": 2.78, "增长排名": 1,
    },
    "高雅人士队": {
        "毛利": 131500, "毛利排名": 2,
        "市场份额": 12.18, "份额排名": 3,
        "广告ROI": 3.98, "ROI排名": 2,
        "销售利润率": 54.4, "利润率排名": 10,
        "份额增长": -0.97, "增长排名": 6,
    },
    "津门创赋奇谭": {
        "毛利": 125775, "毛利排名": 3,
        "市场份额": 11.00, "份额排名": 5,
        "广告ROI": 2.79, "ROI排名": 3,
        "销售利润率": 57.9, "利润率排名": 10,
        "份额增长": 0.32, "增长排名": 3,
    },
    "Hades": {
        "毛利": 107397, "毛利排名": 4,
        "市场份额": 10.38, "份额排名": 4,
        "广告ROI": 3.07, "ROI排名": 4,
        "销售利润率": 53.3, "利润率排名": 9,
        "份额增长": 0.97, "增长排名": 2,
    },
}

def calculate_score(data, weights):
    """计算综合得分"""
    # 将排名转换为得分（排名越高，得分越低，最高10分）
    def rank_to_score(rank, total=10):
        return 11 - rank
    
    # 增长得分（增长越大，得分越高）
    def growth_to_score(growth, max_growth=3.0, min_growth=-2.0):
        if growth >= max_growth:
            return 10
        elif growth <= min_growth:
            return 1
        else:
            # 线性映射
            return 1 + (growth - min_growth) / (max_growth - min_growth) * 9
    
    scores = {}
    for team, metrics in data.items():
        score = (
            rank_to_score(metrics["毛利排名"], 10) * weights["毛利"] +
            rank_to_score(metrics["份额排名"], 10) * weights["份额"] +
            rank_to_score(metrics["ROI排名"], 10) * weights["ROI"] +
            rank_to_score(metrics["利润率排名"], 10) * weights["利润率"] +
            growth_to_score(metrics["份额增长"]) * weights["增长"]
        )
        scores[team] = score
    
    return scores

weights = {
    "毛利": 0.30,
    "份额": 0.25,
    "ROI": 0.20,
    "利润率": 0.15,
    "增长": 0.10,
}

scores = calculate_score(tech1_r2, weights)

print("技术1综合得分：")
for team, score in sorted(scores.items(), key=lambda x: x[1], reverse=True):
    print(f"{team}: {score:.2f}")

