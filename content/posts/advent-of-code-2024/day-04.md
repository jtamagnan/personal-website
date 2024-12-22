---
title: Advent of Code 2024 - Day 4
date: Tue Dec 17 22:06:56 2024
toc: true
tags: ["Advent of Code"]
---

## Part 1
```python {linenos=inline}
from __future__ import annotations

import collections
import dataclasses

@dataclasses.dataclass
class TentativeMatch:
    desired_letter: str
    y: int
    x: int
    dy: int
    dx: int

def get_data():
    data = []
    with open("day_4_input.txt") as f:
        for line in f:
            data.append(line.strip())
    return data

def main(grid):
    queue = collections.deque()
    for y, row in enumerate(grid):
        for x, _ in enumerate(row):
            queue.append(TentativeMatch("X", y, x, 0, 0))

    total = 0
    while queue:
        tm = queue.popleft()
        if tm.y < 0 or tm.y >= len(grid):
            continue
        if tm.x < 0 or tm.x >= len(grid[0]):
            continue

        current_char = grid[tm.y][tm.x]

        if current_char != tm.desired_letter:
            continue

        match current_char:
            case 'X':
                for dy, dx in [
                        [-1, -1],
                        [-1, 0],
                        [-1, 1],
                        [0, -1],
                        [0, 1],
                        [1, -1],
                        [1, 0],
                        [1, 1],
                ]:
                    queue.append(TentativeMatch("M", tm.y + dy, tm.x + dx, dy, dx))
            case 'M':
                queue.append(TentativeMatch("A", tm.y + tm.dy, tm.x + tm.dx, tm.dy, tm.dx))
            case "A":
                queue.append(TentativeMatch("S", tm.y + tm.dy, tm.x + tm.dx, tm.dy, tm.dx))
            case "S":
                total += 1
            case _:
                pass

    return total


if __name__ == "__main__":
    print(f"{main(get_data()) = }")
```

## Part 2
```python {linenos=inline}
from __future__ import annotations

import collections
import dataclasses

@dataclasses.dataclass
class TentativeMatch:
    desired_letter: str
    y: int
    x: int

def get_data():
    data = []
    with open("day_4_input_2.txt") as f:
        for line in f:
            data.append(line.strip())
    return data

def main(grid):
    queue = collections.deque()
    for y in range(1, len(grid) - 1):
        for x in range(1, len(grid[0]) - 1):
            queue.append(TentativeMatch("A", y, x))

    total = 0
    while queue:
        tm = queue.popleft()

        current_char = grid[tm.y][tm.x]

        if current_char != tm.desired_letter:
            continue

        valid_1 = (grid[tm.y - 1][tm.x - 1], grid[tm.y + 1][tm.x + 1]) in [("M", "S"), ("S", "M")]
        valid_2 = (grid[tm.y - 1][tm.x + 1], grid[tm.y + 1][tm.x - 1]) in [("M", "S"), ("S", "M")]

        if valid_1 and valid_2:
            total += 1

    return total


if __name__ == "__main__":
    print(f"{main(get_data()) = }")
```
