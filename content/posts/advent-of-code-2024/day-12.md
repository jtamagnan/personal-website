---
title: Advent of Code 2024 - Day 12
date: Sun Dec 22 09:57:46 2024
toc: true
tags: ["Advent of Code"]
---

## Part 1
```python {linenos=inline}
from __future__ import annotations

import dataclasses


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


def get_data(path: str) -> list[str]:
    output = []
    with open(path) as f:
        for line in f:
            output.append(line.strip())
    return output


def region_search(grid, starting_point: Vector) -> tuple[int, int, set[Vector]]:
    """
    A function that flows through a given region and returns the
    region's area, perimeter, and the (y,x) positions of all plots in
    it.
    """
    area = 0
    perimeter = 0

    crop = grid[starting_point.y][starting_point.x]

    stack = [starting_point]
    counted_plots = set()
    while stack:
        pos = stack.pop()

        if pos in counted_plots:
            continue

        counted_plots.add(pos)

        area += 1
        perimeter += 4

        for delta in [
                Vector(1, 0),
                Vector(-1, 0),
                Vector(0, 1),
                Vector(0, -1),
        ]:
            next_position = pos + delta
            if not next_position.is_valid(grid):
                continue

            if grid[next_position.y][next_position.x] == crop:
                perimeter -= 1
                stack.append(next_position)

    return area, perimeter, counted_plots


def main(grid: list[str]) -> int:
    checked_plots = set()

    area_perimeter = 0
    for y, row in enumerate(grid):
        for x, _ in enumerate(row):
            starting_point = Vector(y, x)
            if starting_point in checked_plots:
                # If this plot was already contained in a previously
                # checked region then skip it.
                continue

            #
            # Find the data about the region starting at this point
            #
            area, perimeter, region_plots = region_search(grid, starting_point)
            area_perimeter += area * perimeter
            checked_plots |= region_plots

    return area_perimeter


if __name__ == "__main__":
    # print(main(get_data("day_12_input_test.txt")))
    print(main(get_data("day_12_input.txt")))
```

## Part 2
```python {linenos=inline}
from __future__ import annotations

import dataclasses


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


DELTAS = [
    Vector(1, 0),
    Vector(0, 1),
    Vector(-1, 0),
    Vector(0, -1)
]


def rotate(vector):
    return DELTAS[(DELTAS.index(vector) + 1) % len(DELTAS)]


def get_data(path: str) -> list[str]:
    output = []
    with open(path) as f:
        for line in f:
            output.append(line.strip())
    return output


def region_search(grid, starting_point) -> tuple[int, int, set[Vector]]:
    counted_plots = set()
    area = 0
    sides = set()

    stack = [starting_point]
    while stack:
        pos = stack.pop()
        crop = grid[pos.y][pos.x]

        if pos in counted_plots:
            continue

        counted_plots.add(pos)

        area += 1

        potential_sides = {(pos, delta) for delta in DELTAS}
        for delta in DELTAS:
            next_position = pos + delta
            if not next_position.is_valid(grid):
                continue

            if grid[next_position.y][next_position.x] == crop:
                stack.append(next_position)
                if delta.x:
                    potential_sides.remove((pos, delta))
                else:
                    potential_sides.remove((pos, delta))


        sides |= potential_sides

    bad_sides = set()
    for side in sides:
        pos, direction = side
        if (pos + rotate(direction), direction) in sides:
            bad_sides.add(side)

    return area, len(sides - bad_sides), counted_plots


def main(grid: list[str]) -> int:
    checked_plots = set()

    area_perimeter = 0
    for y, row in enumerate(grid):
        for x, _ in enumerate(row):
            starting_point = Vector(y, x)
            if starting_point in checked_plots:
                # If this plot was already contained in a previously
                # checked region then skip it.
                continue

            # Find the data about the region starting at this point
            #
            area, sides, region_plots = region_search(grid, starting_point)
            area_perimeter += area * sides
            checked_plots |= region_plots

    return area_perimeter


if __name__ == "__main__":
    # print(main(get_data("day_12_input_test.txt")))
    print(main(get_data("day_12_input.txt")))
```
