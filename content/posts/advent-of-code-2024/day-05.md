---
title: Advent of Code 2024 - Day 5
date: Tue Dec 17 22:07:05 2024
toc: true
tags: ["Advent of Code"]
---

## Part 1
```python {linenos=inline}
from __future__ import annotations

import collections


def get_data() -> tuple[dict[str, list[str]], list[list[str]]]:
    with open("day_5_input.txt") as f:
        data = f.read()

    raw_rules, raw_rows = data.split("\n\n")

    rules = collections.defaultdict(list)
    for rule_line in raw_rules.strip().split():
        k, y = rule_line.split("|")
        rules[k].append(y)

    rows = []
    for row in raw_rows.strip().split():
        rows.append(row.split(","))

    return rules, rows


def valid_row(rules: dict[str, list[str]], row: list[str]) -> bool:
    row_data = {}
    for i, page in enumerate(row):
        row_data[page] = i

    for before, afters in rules.items():
        for after in afters:
            if before in row_data and after in row_data:
                if row_data[before] > row_data[after]:
                    return False
    return True


def main(rules: dict[str, list[str]], rows: list[list[str]]) -> int:
    output = 0
    for row in rows:
        if valid_row(rules, row):
            output += int(row[len(row) // 2])
    return output


if __name__ == "__main__":
    print(main(*get_data()))
```

## Part 2
```python {linenos=inline}
from __future__ import annotations

import collections


def get_data() -> tuple[dict[str, list[str]], list[list[str]]]:
    with open("day_5_input_test.txt") as f:
        data = f.read()

    raw_rules, raw_rows = data.split("\n\n")

    rules = collections.defaultdict(list)
    for rule_line in raw_rules.strip().split():
        k, y = rule_line.split("|")
        rules[k].append(y)

    rows = []
    for row in raw_rows.strip().split():
        rows.append(row.split(","))

    return rules, rows


def valid_row(rules: dict[str, list[str]], row: list[str]) -> bool:
    row_data = {}
    for i, page in enumerate(row):
        row_data[page] = i

    for before, afters in rules.items():
        for after in afters:
            if before in row_data and after in row_data:
                if row_data[before] > row_data[after]:
                    return False
    return True


def fix_row(rules: dict[str, list[str]], row: list[str]) -> list[str]:
    while not valid_row(rules, row):
        row_data = {}
        for i, page in enumerate(row):
            row_data[page] = i

        for before, afters in rules.items():
            for after in afters:
                if before in row_data and after in row_data:
                    if row_data[before] > row_data[after]:
                        row[row_data[before]], row[row_data[after]] = row[row_data[after]], row[row_data[before]]
                        row_data[before], row_data[after] = row_data[after], row_data[before]
    return row


def main(rules: dict[str, list[str]], rows: list[list[str]]) -> int:
    output = 0
    for row in rows:
        if not valid_row(rules, row):
            row = fix_row(rules, row)
            output += int(row[len(row) // 2])
    return output


if __name__ == "__main__":
    print(main(*get_data()))
```
