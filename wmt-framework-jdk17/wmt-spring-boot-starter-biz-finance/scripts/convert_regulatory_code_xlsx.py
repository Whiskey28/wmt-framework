#!/usr/bin/env python3
"""将监管集市码表 xlsx 转为 regulatory-code.csv（仅所属行业代码 / GB/T 4754-2017）。

用法:
  python3 convert_regulatory_code_xlsx.py \\
    --xlsx /path/to/1.1行内处理-监管集市码表.xlsx \\
    --out  ../src/main/resources/regulatory-code.csv

建树规则: 最长已存在前缀作为 parentCode；门类 parentCode 为空。
"""

from __future__ import annotations

import argparse
import csv
import re
from pathlib import Path

REMARK = "《国民经济行业分类》（GB/T 4754-2017）"
TABLE_NAME = "所属行业代码"


def code_type(code: str) -> int:
    if re.fullmatch(r"[A-T]", code):
        return 1
    if re.fullmatch(r"[A-T]\d{2}", code):
        return 2
    if re.fullmatch(r"[A-T]\d{3}", code):
        return 3
    if re.fullmatch(r"[A-T]\d{4}", code):
        return 4
    if len(code) == 1:
        return 1
    if len(code) == 3:
        return 2
    if len(code) == 4:
        return 3
    return 4


def longest_prefix_parent(code: str, code_set: set[str]) -> str:
    for i in range(len(code) - 1, 0, -1):
        if code[:i] in code_set:
            return code[:i]
    return ""


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--xlsx", required=True, type=Path)
    parser.add_argument("--out", required=True, type=Path)
    args = parser.parse_args()

    try:
        import openpyxl
    except ImportError as e:
        raise SystemExit("需要 openpyxl: pip install openpyxl") from e

    wb = openpyxl.load_workbook(args.xlsx, read_only=True, data_only=True)
    rows = list(wb["Sheet1"].iter_rows(values_only=True))[1:]
    wb.close()

    items: list[tuple[str, str]] = []
    for row in rows:
        name = str(row[1]).strip() if row[1] else ""
        remark = str(row[4]).strip() if row[4] else ""
        if name != TABLE_NAME or remark != REMARK:
            continue
        code = None if row[2] is None else str(row[2]).strip()
        if not code:
            continue
        code_name = "" if row[3] is None else str(row[3]).replace("\xa0", " ").strip()
        items.append((code, code_name))

    seen: set[str] = set()
    uniq: list[tuple[str, str]] = []
    for code, code_name in items:
        if code in seen:
            continue
        seen.add(code)
        uniq.append((code, code_name))

    code_set = {c for c, _ in uniq}
    args.out.parent.mkdir(parents=True, exist_ok=True)
    with args.out.open("w", encoding="utf-8", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["code", "name", "type", "parentCode"])
        for code, code_name in uniq:
            writer.writerow([code, code_name, code_type(code), longest_prefix_parent(code, code_set)])

    print(f"wrote {args.out} rows={len(uniq)}")


if __name__ == "__main__":
    main()
