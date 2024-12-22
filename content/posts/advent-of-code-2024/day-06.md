---
title: Advent of Code 2024 - Day 6
date: Tue Dec 17 22:07:12 2024
toc: true
tags: ["Advent of Code"]
---

## Part 1
```python {linenos=inline}
import dataclasses


@dataclasses.dataclass
class Vector:
    y: int
    x: int


ROTATE = [
    Vector(-1, 0),
    Vector(0, 1),
    Vector(1, 0),
    Vector(0, -1),
]


def get_data(path):
    with open(path) as f:
       return [list(row) for row in f.read().strip().split()]


def main(grid) -> int:
    #
    # Find the dude's starting position
    #
    pos = Vector(0, 0)
    for y, row in enumerate(grid):
        for x, c in enumerate(row):
            if c == "^":
                pos = Vector(y, x)

    #
    # Have the starting tile be considered marked
    #
    checked_tiles = 1
    grid[pos.y][pos.x] = "X"

    #
    # Have the dude walk
    #
    direction = Vector(-1, 0)
    while True:
        next_pos = Vector(pos.y + direction.y, pos.x + direction.x)
        if not (next_pos.x >= 0 and next_pos.y >= 0 and next_pos.x < len(grid[0]) and next_pos.y < len(grid)):
            break
        next_tile = grid[next_pos.y][next_pos.x]

        if next_tile == "#":
            direction = ROTATE[(ROTATE.index(direction) + 1) % len(ROTATE)]
            continue
        elif next_tile == ".":
            grid[next_pos.y][next_pos.x] = "X"
            checked_tiles += 1
        pos = next_pos

    for row in grid:
        print("".join(row))
    return checked_tiles



if __name__ == '__main__':
    print(main(get_data("day_6_input.txt")))
```

## Part 2
```python {linenos=inline}
import dataclasses
import copy

@dataclasses.dataclass(frozen=True)
class Vector:
    y: int
    x: int

ROTATE = [
    Vector(-1, 0),
    Vector(0, 1),
    Vector(1, 0),
    Vector(0, -1),
]


def get_data(path):
    with open(path) as f:
       return [list(row) for row in f.read().strip().split()]


def is_loop(grid) -> bool:
    #
    # Find the dude's starting position
    #
    pos = Vector(0, 0)
    for y, row in enumerate(grid):
        for x, c in enumerate(row):
            if c == "^":
                pos = Vector(y, x)


    #
    # Have the dude walk
    #
    visited = set()
    direction = Vector(-1, 0)
    grid[pos.y][pos.x] = "."

    while True:
        #
        # If the guard has walked here before then quit
        #
        if (pos, direction) in visited:
            return True
        visited.add((pos, direction))

        #
        # If we'd walk off the edge then we ain't looping
        #
        next_pos = Vector(pos.y + direction.y, pos.x + direction.x)
        if not (next_pos.x >= 0 and next_pos.y >= 0 and next_pos.x < len(grid[0]) and next_pos.y < len(grid)):
            return False

        #
        # Decide what to do next by looking at the next tile
        #
        next_tile = grid[next_pos.y][next_pos.x]
        if next_tile == "#":
            direction = ROTATE[(ROTATE.index(direction) + 1) % len(ROTATE)]
        else:
            pos = next_pos


def main(grid):
    output = 0
    #
    # Place an obstacle at every single grid position and check if it
    # leads to a looping guard
    #
    for y in range(len(grid)):
        for x in range(len(grid[0])):
            if grid[y][x] == "#":
                continue
            new_grid = copy.deepcopy(grid)
            new_grid[y][x] = "#"
            output += int(is_loop(new_grid))
    return output


if __name__ == '__main__':
    print(main(get_data("day_6_input_test_2.txt")))
```
