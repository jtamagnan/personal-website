---
title: Advent of Code 2024 - Day 11
date: Sun Dec 22 09:57:31 2024
toc: true
tags: ["Advent of Code"]
---

## Part 1
```python {linenos=inline}
from __future__ import annotations

import math
import dataclasses
import typing

@dataclasses.dataclass
class Node:
    value: int
    nxt: Node | None = None


def get_data(path: str) -> typing.Iterator[int]:
    with open(path) as f:
        yield from (int(x) for x in f.read().strip().split())

def blink(node):
    while node:
        match node.value:
            case 0:
                node.value = 1
            case it if int(math.log(it, 10)) % 2 == 1:
                digits = int(math.log(it, 10)) + 1
                leading_digits = int(str(it)[:digits // 2])
                trailing_digits = int(str(it)[digits // 2:])

                new_node = Node(trailing_digits, node.nxt)
                node.nxt = new_node
                node.value = leading_digits
                node = new_node
            case _:
                node.value *= 2024
        node = node.nxt

def main(data: typing.Iterator[int]) -> int:
    front_node = Node(next(data))
    last_node = front_node
    for datum in data:
        last_node.nxt = Node(datum)
        last_node = last_node.nxt

    for _ in range(25):
        blink(front_node)

    node_count = 0
    node = front_node
    while node:
        node_count += 1
        node = node.nxt

    return node_count


if __name__ == "__main__":
    print(main(get_data("day_11_input.txt")))
```

## Part 2
```python {linenos=inline}
from __future__ import annotations

import math
import collections
import typing

def get_data(path: str) -> typing.Iterator[int]:
    with open(path) as f:
        yield from (int(x) for x in f.read().strip().split())

def blink(counter: dict[int, int]) -> dict[int, int]:
    next_counter = collections.defaultdict(int)
    for k, count in counter.items():
        match k:
            case 0:
                next_counter[1] += count
            case it if int(math.log(it, 10)) % 2 == 1:
                digits = int(math.log(it, 10)) + 1
                leading_digits = int(str(it)[:digits // 2])
                trailing_digits = int(str(it)[digits // 2:])
                next_counter[leading_digits] += count
                next_counter[trailing_digits] += count
            case _:
                next_counter[k * 2024] += count

    return next_counter

def main(data: typing.Iterator[int]) -> int:
    counter = collections.defaultdict(int)

    for datum in data:
        counter[datum] += 1

    for _ in range(75):
        counter = blink(counter)

    return sum(counter.values())


if __name__ == "__main__":
    print(main(get_data("day_11_input.txt")))
```
