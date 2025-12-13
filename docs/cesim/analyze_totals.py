#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
简单分析第一回合各市场各技术总销量，并按报告中的增长率推算第二回合需求区间。
"""

import pandas as pd


def main():
    df = pd.read_csv("results-r01.csv", header=None)

    def sum_sales(market: str, tech: str) -> float:
        """在 CSV 里根据 '市场报告, X' + '技术Y' + '\"销售, 千件\"' 三行定位并求和。"""
        start = None
        for idx, v in df[0].items():
            if isinstance(v, str) and v.strip() == f"市场报告, {market}":
                start = idx
                break
        if start is None:
            return 0.0

        tech_row = None
        for idx in range(start, len(df)):
            v = df.iloc[idx, 0]
            if isinstance(v, str) and v.strip() == tech:
                tech_row = idx
                break
            if isinstance(v, str) and v.startswith("市场报告,") and idx > start:
                break
        if tech_row is None:
            return 0.0

        sales_row = None
        for idx in range(tech_row, min(tech_row + 10, len(df))):
            v = df.iloc[idx, 0]
            if isinstance(v, str) and "销售, 千件" in v:
                sales_row = idx
                break
        if sales_row is None:
            return 0.0

        row = df.iloc[sales_row]
        # 队伍列从索引 1 开始，最多 10 列
        values = []
        for col in range(1, 11):
            val = row[col]
            if pd.notna(val):
                values.append(float(val))
        return sum(values)

    markets = ["美国", "亚洲", "欧洲"]
    techs = ["技术1", "技术2"]

    print("第一回合各市场各技术总销量(千件)：")
    base = {}
    for m in markets:
        for t in techs:
            total = sum_sales(m, t)
            base[(m, t)] = total
            print(f"{m} {t}: {total:.3f}")

    # 根据报告中的增长率估算第二回合需求区间
    growth = {
        ("美国", "技术1"): (0.08, 0.10),
        ("美国", "技术2"): (0.10, 0.15),
        ("亚洲", "技术1"): (0.09, 0.09),
        ("亚洲", "技术2"): (0.20, 0.25),
        ("欧洲", "技术1"): (0.10, 0.10),
        ("欧洲", "技术2"): (0.08, 0.08),
    }

    print("\n第二回合各市场各技术需求区间(千件)：")
    for key, total in base.items():
        if total == 0:
            continue
        g = growth.get(key)
        if not g:
            continue
        lo, hi = g
        d_lo = total * (1 + lo)
        d_hi = total * (1 + hi)
        print(f"{key[0]} {key[1]}: {d_lo:.1f} ~ {d_hi:.1f}")


if __name__ == "__main__":
    main()


