---
title: Advent of Code 2024 - Day 7
date: Tue Dec 17 22:07:20 2024
toc: true
tags: ["Advent of Code"]
---

## Part 1
```python {linenos=inline}
from __future__ import annotations

import typing


def get_data(path: str) -> typing.Iterable[tuple[int, list[int]]]:
    with open(path) as f:
        for line in f:
            line = line.strip()
            goal, nums = line.split(":")
            yield int(goal), [int(n) for n in nums.strip().split()]


def is_match(goal: int, inputs: list[int]) -> bool:
    #
    # Set the initial start point
    #
    stack: list[tuple[int, int]]= [(inputs[0], 1)]
    while stack:
        cur, depth = stack.pop()
        #
        # We've exhausted the inputs
        #
        if depth == len(inputs):
            # We've reach our goal, celebrate
            if cur == goal:
                return True
            # We aren't yet at the goal, this path was a failure
            else:
                continue

        #
        # We've overshot no point in continuing down this path.
        #
        if cur > goal:
            continue

        stack.append((cur * inputs[depth], depth + 1))
        stack.append((cur + inputs[depth], depth + 1))

    return False


def main(data: typing.Iterable[tuple[int, list[int]]]) -> int:
    output = 0
    for goal, inputs in data:
        if is_match(goal, inputs):
            output += goal

    return output


if __name__ == '__main__':
    print(main(get_data("day_7_input.txt")))
```

## Part 2
```python {linenos=inline}
def get_data(path):
    with open(path) as f:
        for line in f:
            line = line.strip()
            goal, nums = line.split(":")
            yield int(goal), [int(n) for n in nums.strip().split()]


def is_match(goal, inputs):
    stack = [(inputs[0], 1)]
    while stack:
        cur, depth = stack.pop()
        if depth == len(inputs):
            if cur == goal:
                return True
            else:
                continue
        if cur > goal:
            continue

        stack.append((cur * inputs[depth], depth + 1))
        stack.append((cur + inputs[depth], depth + 1))
        stack.append((int(str(cur) + str(inputs[depth])), depth + 1))

    return False


def main(data) -> int:
    output = 0
    for goal, inputs in data:
        if is_match(goal, inputs):
            output += goal
    return output


if __name__ == '__main__':
    print(main(get_data("day_7_input.txt")))
```
