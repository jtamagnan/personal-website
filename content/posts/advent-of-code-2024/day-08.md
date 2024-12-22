---
title: Advent of Code 2024 - Day 8
date: Wed Dec 18 12:42:01 2024
toc: true
tags: ["Advent of Code"]
---

## Part 1
```python {linenos=inline}
from __future__ import annotations

import typing
import collections
import dataclasses
import itertools


@dataclasses.dataclass(frozen=True)
class Vector:
    y: int
    x: int

    def __sub__(self, b):
        return Vector(self.y - b.y, self.x - b.x)

    def __add__(self, b):
        return Vector(self.y + b.y, self.x + b.x)

    def is_valid(self, grid: list[str]) -> bool:
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


def get_data(path: str) -> typing.Iterable[str]:
    with open(path) as f:
        for line in f:
             yield line.strip()


def find_anode(node1: Vector, node2: Vector) -> typing.Iterable[Vector]:
    difference = node1 - node2
    yield node1 + difference
    yield node2 - difference


def find_anodes(nodes: set) -> typing.Iterable[Vector]:
    for chosen_nodes in itertools.combinations(nodes, 2):
        yield from find_anode(*chosen_nodes)

def main(grid: list[str]) -> int:
    #
    # Find and group all similar nodes
    #
    nodes = collections.defaultdict(set)
    for y, row in enumerate(grid):
        for x, char in enumerate(row):
            if char != ".":
                nodes[char].add(Vector(y, x))

    #
    # Calculate all anodes
    #
    all_nodes = set()
    anodes = set()
    for _, node_positions in nodes.items():
        all_nodes.update(node_positions)
        for anode in find_anodes(node_positions):
            if anode.is_valid(grid):
                anodes.add(anode)

    #
    # Find all anodes where there is not already a node
    #
    return len(anodes - all_nodes | anodes)


if __name__ == '__main__':
    print(main(list(get_data("day_8_input.txt"))))
```

## Part 2
```python {linenos=inline}
from __future__ import annotations

import typing
import collections
import dataclasses
import itertools


@dataclasses.dataclass(frozen=True)
class Vector:
    y: int
    x: int

    def __sub__(self, b):
        return Vector(self.y - b.y, self.x - b.x)

    def __add__(self, b):
        return Vector(self.y + b.y, self.x + b.x)

    def is_valid(self, grid: list[str]) -> bool:
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


def get_data(path: str) -> typing.Iterable[str]:
    with open(path) as f:
        for line in f:
             yield line.strip()


def find_anode(grid: list[str], node1: Vector, node2: Vector) -> typing.Iterable[Vector]:
    difference = node1 - node2

    #
    # The node itself is an anode
    #
    yield node1

    #
    # All nodes that are in the _positive_ line of the difference
    #
    new_node = node1 + difference
    while new_node.is_valid(grid):
        yield new_node
        new_node += difference

    #
    # All nodes that are in the _negative_ line of the difference
    #
    new_node = node1 - difference
    while new_node.is_valid(grid):
        yield new_node
        new_node -= difference


def find_anodes(grid: list[str], nodes: set) -> typing.Iterable[Vector]:
    for chosen_nodes in itertools.combinations(nodes, 2):
        yield from find_anode(grid, *chosen_nodes)


def main(grid: list[str]) -> int:
    #
    # Find and group all similar nodes
    #
    nodes = collections.defaultdict(set)
    for y, row in enumerate(grid):
        for x, char in enumerate(row):
            if char != ".":
                nodes[char].add(Vector(y, x))

    #
    # Calculate all anodes
    #
    all_nodes = set()
    anodes = set()
    for _, node_positions in nodes.items():
        all_nodes.update(node_positions)
        for anode in find_anodes(grid, node_positions):
            anodes.add(anode)

    #
    # Count all anodes even those that are on top of existing nodes
    #
    return len(anodes)


if __name__ == '__main__':
    print(main(list(get_data("day_8_input.txt"))))
```
