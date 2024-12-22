---
title: Advent of Code 2024 - Day 2
date: Tue Dec 17 20:16:06 2024
toc: true
tags: ["Advent of Code"]
---

## Part 1
```python {linenos=inline}
def get_data(path):
    with open(path) as f:
        for line in f:
            line = line.strip()
            yield [int(x) for x in line.split()]


def is_safe(report):
    is_decending = report[0] > report[1]

    for i, j in zip(report[:-1], report[1:]):
        if is_decending:
            if not (1 <= i - j <= 3):
                return False
        else:
            if not (1 <= j - i <= 3):
                return False

    return True

def main(data):
    safe_reports = 0
    for report in data:
        if is_safe(report):
            safe_reports += 1
    return safe_reports


if __name__ == '__main__':
    print(main(get_data("day_2_input.txt")))
```

## Part 2
```python {linenos=inline}
def get_data():
    with open("day_2_input.txt") as f:
        for line in f:
            line = line.strip()
            yield [int(x) for x in line.split()]


def is_safe(report):
    is_decending = report[0] > report[1]

    for i, j in zip(report[:-1], report[1:]):
        if is_decending:
            if not (1 <= i - j <= 3):
                return False
        else:
            if not (1 <= j - i <= 3):
                return False

    return True

def any_safe(report):
    for i in range(len(report)):
        new_report = report[:i] + report[i + 1:]
        if is_safe(new_report):
            return True
    return False

def main(data):
    safe_reports = 0
    for report in data:
        if any_safe(report):
            safe_reports += 1
    return safe_reports


if __name__ == '__main__':
    print(main(get_data()))
```
