---
title: Advent of Code 2024 - Day 10
date: Sun Dec 22 09:57:23 2024
toc: true
tags: ["Advent of Code"]
---

## Part 1
from __future__ import annotations

import dataclasses
import typing

@dataclasses.dataclass(frozen=True)
class Vector:
    y: int
    x: int

    def __add__(self, b):
        return Vector(self.y + b.y, self.x + b.x)

    def is_valid(self, grid: list[list[int]]) -> bool:
        if self.x < 0:
            return False
        elif self.y < 0:
            return False
        elif self.x >= len(grid[0]):
            return False
        elif self.y >= len(grid):
            return False
        else:
            return True

def get_data(path: str) -> typing.Iterator[list[int]]:
    with open(path) as f:
        for line in f:
            yield [int(x) for x in line.strip()]

def main(data: typing.Iterator[list[int]]):
    grid = list(data)

    stack = []
    for y, row in enumerate(grid):
        for x, c in enumerate(row):
            if c == 0:
                stack.append((Vector(y, x), Vector(y, x)))

    seen_paths = set()
    paths = 0
    while stack:
        pos, initial = stack.pop()
        current_elevation = grid[pos.y][pos.x]

        if current_elevation == 9:
            key = (pos, initial)
            if key not in seen_paths:
                paths += 1
                seen_paths.add(key)
            continue

        for delta in [
                Vector(1, 0),
                Vector(-1, 0),
                Vector(0, 1),
                Vector(0, -1)
        ]:
            next_position = pos + delta
            if not next_position.is_valid(grid):
                continue

            if grid[next_position.y][next_position.x] == current_elevation + 1:
                stack.append((next_position, initial))

    return paths


if __name__ == "__main__":
    # print(main(get_data("day_10_input_test.txt")))
    print(main(get_data("day_10_input.txt")))
```

## Part 2
from __future__ import annotations

import dataclasses
import typing

@dataclasses.dataclass(frozen=True)
class Vector:
    y: int
    x: int

    def __add__(self, b):
        return Vector(self.y + b.y, self.x + b.x)

    def is_valid(self, grid: list[list[int]]) -> bool:
        if self.x < 0:
            return False
        elif self.y < 0:
            return False
        elif self.x >= len(grid[0]):
            return False
        elif self.y >= len(grid):
            return False
        else:
            return True

def get_data(path: str) -> typing.Iterator[list[int]]:
    with open(path) as f:
        for line in f:
            yield [int(x) for x in line.strip()]

def main(data: typing.Iterator[list[int]]):
    grid = list(data)

    stack = []
    for y, row in enumerate(grid):
        for x, c in enumerate(row):
            if c == 0:
                stack.append(Vector(y, x))

    paths = 0
    while stack:
        pos = stack.pop()
        current_elevation = grid[pos.y][pos.x]

        if current_elevation == 9:
            paths += 1
            continue

        for delta in [
                Vector(1, 0),
                Vector(-1, 0),
                Vector(0, 1),
                Vector(0, -1)
        ]:
            next_position = pos + delta
            if not next_position.is_valid(grid):
                continue

            if grid[next_position.y][next_position.x] == current_elevation + 1:
                stack.append(next_position)

    return paths


if __name__ == "__main__":
    print(main(get_data("day_10_input_test.txt")))
    print(main(get_data("day_10_input.txt")))
```
