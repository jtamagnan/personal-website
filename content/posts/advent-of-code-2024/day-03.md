---
title: Advent of Code 2024 - Day 3
date: Tue Dec 17 22:06:49 2024
toc: true
tags: ["Advent of Code"]
---

## Part 1
```python {linenos=inline}
import re

def get_data():
    with open("day_3_input.txt") as f:
        return f.read().strip()

def get_mults(data):
    regex = r"mul\((\d+),(\d+)\)"
    for match in re.finditer(regex, data):
        yield [int(match[0]), int(match[1])]

def main(data):
    output = 0
    for x, y in get_mults(data):
        output += x * y
    return output

if __name__ == "__main__":
    print(f"{main(get_data()) = }")
```

## Part 2
```python {linenos=inline}
import re

def get_data():
    with open("day_3_input.txt") as f:
        return f.read().strip()

def get_mults(data):
    regex = r"mul\((\d+),(\d+)\)|do\(\)|don't\(\)"
    enabled = True
    for m in re.finditer(regex, data):
        match m.group(0):
            case "do()":
                enabled = True
            case "don't()":
                enabled = False
            case _:
                if enabled:
                    yield [int(m.group(1)), int(m.group(2))]

def main(data):
    output = 0
    for x, y in get_mults(data):
        output += x * y
    return output

if __name__ == "__main__":
    print(f"{main(get_data()) = }")
```
