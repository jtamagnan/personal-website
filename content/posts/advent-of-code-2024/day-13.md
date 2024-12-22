---
title: Advent of Code 2024 - Day 13
date: Sun Dec 22 09:57:58 2024
toc: true
tags: ["Advent of Code"]
---

## Part 1
```python {linenos=inline}
from __future__ import annotations

import typing
import dataclasses
import re
import heapq

@dataclasses.dataclass(order=True)
class Vector:
    x: int
    y: int

    def __add__(self, b: typing.Self):
        return Vector(self.x + b.x, self.y + b.y)


@dataclasses.dataclass
class Problem:
    a: Vector
    b: Vector
    solution: Vector

def get_data(path):
    with open(path) as f:
        data = f.read()

    problem_data = data.split("\n\n")
    for problem_datum in problem_data:
        problem_components = []
        for line in problem_datum.splitlines():
            x, y = re.findall(r"(\d+)", line)
            problem_components.append(Vector(int(x), int(y)))
        yield Problem(*problem_components)


def find_problem_cost(problem: Problem) -> int:
    pqueue = [(0, 0, 0, Vector(0, 0))]

    visited = set()
    while pqueue:
        cost, a_presses, b_presses, pos = heapq.heappop(pqueue)

        key = (a_presses, b_presses)
        if key in visited:
            continue
        visited.add(key)

        if pos == problem.solution:
            return cost

        if pos.x > problem.solution.x or pos.y > problem.solution.y:
            continue

        if a_presses > 100 or b_presses > 100:
            continue

        heapq.heappush(pqueue, (cost + 3, a_presses + 1, b_presses, problem.a + pos))
        heapq.heappush(pqueue, (cost + 1, a_presses, b_presses + 1, problem.b + pos))
    return 0

def main(problems):
    output = 0
    for problem in problems:
        cost = find_problem_cost(problem)
        output += cost
    return output

if __name__ == "__main__":
    print(main(get_data("day_13_input_test.txt")))
    print(main(get_data("day_13_input.txt")))
```

## Part 2
```python {linenos=inline}
from __future__ import annotations

import typing
import dataclasses
import re

@dataclasses.dataclass(order=True)
class Vector:
    x: int
    y: int

    def __add__(self, b):
        if isinstance(b, Vector):
            return Vector(self.x + b.x, self.y + b.y)
        elif isinstance(b, int):
            return Vector(self.x + b, self.y + b)
        raise Exception(f"Cannot handle {b=}")

    def __sub__(self, b: typing.Self):
        return Vector(self.x - b.x, self.y - b.y)


@dataclasses.dataclass
class Problem:
    a: Vector
    b: Vector
    solution: Vector

def get_data(path):
    with open(path) as f:
        data = f.read()

    problem_data = data.split("\n\n")
    for problem_datum in problem_data:
        problem_components = []
        for line in problem_datum.splitlines():
            x, y = re.findall(r"(\d+)", line)
            problem_components.append(Vector(int(x), int(y)))
        yield Problem(problem_components[0], problem_components[1], problem_components[2] + 10000000000000)
        # yield Problem(problem_components[0], problem_components[1], problem_components[2])


def find_problem_cost(problem: Problem) -> int:
    numerator = problem.solution.x * problem.a.y - problem.a.x * problem.solution.y
    denominator = problem.b.x * problem.a.y - problem.b.y * problem.a.x
    b_presses = numerator / denominator
    a_presses = (problem.solution.y - b_presses * problem.b.y) / problem.a.y
    if b_presses != int(b_presses):
        return 0
    elif a_presses != int(a_presses):
        return 0
    else:
        return int(a_presses * 3 + b_presses)

def main(problems):
    output = 0
    for problem in problems:
        cost = find_problem_cost(problem)
        output += cost
    return output

if __name__ == "__main__":
    # print(main(get_data("day_13_input_test.txt")))
    print(main(get_data("day_13_input.txt")))
```
