---
title: Advent of Code 2024 - Day 14
date: Sun Dec 22 09:58:22 2024
toc: true
tags: ["Advent of Code"]
---

## Part 1
```python {linenos=inline}
from __future__ import annotations

import typing
import dataclasses
import re
import collections

@dataclasses.dataclass
class Vector:
    x: int
    y: int

    def __add__(self, b: typing.Self):
        return Vector(self.x + b.x, self.y + b.y)

@dataclasses.dataclass
class Guard:
    pos: Vector
    vel: Vector

    def move(self, shape: Vector):
        self.pos.x = (self.pos.x + self.vel.x) % shape.x
        self.pos.y = (self.pos.y + self.vel.y) % shape.y


    def get_quadrant(self, shape: Vector):
        if self.pos.x < shape.x // 2:
            x = 0
        elif shape.x - shape.x // 2 <= self.pos.x:
            x = 1
        else:
            return None

        if self.pos.y < shape.y // 2:
            y = 0
        elif shape.y - shape.y // 2 <= self.pos.y:
            y = 1
        else:
            return None

        return (x, y)

def get_data(path):
    with open(path) as f:
        data = f.read()

    for guard_line in data.strip().splitlines():
        if m := re.search(r"p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)", guard_line):
            pos = Vector(int(m.group(1)), int(m.group(2)))
            vel = Vector(int(m.group(3)), int(m.group(4)))
            yield Guard(pos, vel)
        else:
            raise Exception("Could not parse line `{line}`")


def main(guards: list[Guard], shape: Vector, iterations=100):
    for _ in range(iterations):
        for guard in guards:
            guard.move(shape)

    counter = collections.Counter(g.get_quadrant(shape) for g in guards)
    total = 1
    for k, v in counter.items():
        if k is not None:
            total *= v
    return total

if __name__ == "__main__":
    # print(main(list(get_data("day_14_input_test.txt")), Vector(11, 7)))
    print(main(list(get_data("day_14_input.txt")), Vector(101, 103)))
```

## Part 2
```python {linenos=inline}
from __future__ import annotations

import typing
import dataclasses
import re
import collections

@dataclasses.dataclass
class Vector:
    x: int
    y: int

    def __add__(self, b: typing.Self):
        return Vector(self.x + b.x, self.y + b.y)

@dataclasses.dataclass
class Guard:
    pos: Vector
    vel: Vector

    def move(self, shape: Vector):
        self.pos.x = (self.pos.x + self.vel.x) % shape.x
        self.pos.y = (self.pos.y + self.vel.y) % shape.y


    def get_quadrant(self, shape: Vector):
        if self.pos.x < shape.x // 2:
            x = 0
        elif shape.x - shape.x // 2 <= self.pos.x:
            x = 1
        else:
            return None

        if self.pos.y < shape.y // 2:
            y = 0
        elif shape.y - shape.y // 2 <= self.pos.y:
            y = 1
        else:
            return None

        return (x, y)

def get_data(path):
    with open(path) as f:
        data = f.read()

    for guard_line in data.strip().splitlines():
        if m := re.search(r"p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)", guard_line):
            pos = Vector(int(m.group(1)), int(m.group(2)))
            vel = Vector(int(m.group(3)), int(m.group(4)))
            yield Guard(pos, vel)
        else:
            raise Exception("Could not parse line `{line}`")


def format_grid(guards, shape):
    grid = [["." for _ in range(shape.x)] for _ in range(shape.y)]
    for g in guards:
        grid[g.pos.y][g.pos.x] = "x"

    return "\n".join("".join(row) for row in grid)

def main(guards: list[Guard], shape: Vector, iterations=10000):
    for i in range(iterations):
        for guard in guards:
            guard.move(shape)
        grid_str = format_grid(guards, shape)
        if "x" * 10 in grid_str:
            print(i + 1)
            print(grid_str)

if __name__ == "__main__":
    # print(main(list(get_data("day_14_input_test.txt")), Vector(11, 7)))
    print(main(list(get_data("day_14_input.txt")), Vector(101, 103)))
```
