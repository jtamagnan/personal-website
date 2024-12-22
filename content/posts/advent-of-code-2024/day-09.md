---
title: Advent of Code 2024 - Day 9
date: Sun Dec 22 09:57:16 2024
toc: true
tags: ["Advent of Code"]
---

## Part 1
```python {linenos=inline}
from __future__ import annotations

def get_data(path: str) -> str:
    with open(path) as f:
        return f.read().strip()

def main(data: str):
    intermediate = []
    is_disk = False
    counter = -1
    for char in data:
        is_disk = not(is_disk)
        if is_disk:
            counter += 1
            intermediate.extend([str(counter)] * int(char))
        else:
            intermediate.extend(['.'] * int(char))

    left = 0
    right = len(intermediate) - 1
    while True:
        while intermediate[left] != ".":
            left += 1
        while intermediate[right] == ".":
            right -= 1
        if left >= right:
            break
        intermediate[left] = intermediate[right]
        intermediate[right] = "."

    total = 0
    for base, char in enumerate(intermediate):
        if char == ".":
            break
        total += int(char) * base

    return total



if __name__ == "__main__":
    # print(main(get_data("day_9_input_test.txt")))
    print(main(get_data("day_9_input.txt")))
```

## Part 2
```python {linenos=inline}
from __future__ import annotations

import dataclasses


def get_data(path: str) -> str:
    with open(path) as f:
        return f.read().strip()

@dataclasses.dataclass
class Region:
    is_disk: bool
    size: int
    name: str = "."

def main(data: str):
    intermediate: list[Region] = []
    is_disk = False
    counter = -1
    for datum in data:
        is_disk = not(is_disk)
        if is_disk:
            counter += 1
            intermediate.append(Region(True, int(datum), str(counter)))
        else:
            intermediate.append(Region(False, int(datum)))

    for i in range(len(intermediate) - 1, -1, -1):
        disk_region = intermediate[i]
        if disk_region.is_disk:
            for j in range(i):
                free_region = intermediate[j]
                if not free_region.is_disk and free_region.size >= disk_region.size:
                    intermediate.insert(j, disk_region)
                    free_region.size -= disk_region.size
                    intermediate[i + 1] = Region(False, disk_region.size)
                    break

    final_intermediate = []
    for region in intermediate:
        if region.size:
            final_intermediate.extend([region.name] * region.size)
    print("".join(final_intermediate))

    total = 0
    for base, char in enumerate(final_intermediate):
        if char == ".":
            continue
        total += int(char) * base

    return total



if __name__ == "__main__":
    print(main(get_data("day_9_input_test.txt")))
    # print(main(get_data("day_9_input.txt")))
```

## Part 2 Linked List
```python {linenos=inline}
from __future__ import annotations

import dataclasses


def get_data(path: str) -> str:
    with open(path) as f:
        return f.read().strip()

@dataclasses.dataclass
class Region:
    is_disk: bool
    size: int
    name: str = "."
    prev_r: Region | None = None
    next_r: Region | None = None

def main(data: str):
    first_region = None
    last_region = None
    is_disk = False
    counter = -1

    for datum in data:
        is_disk = not(is_disk)
        if is_disk:
            counter += 1
            if first_region and last_region:
                last_region.next_r = Region(True, int(datum), str(counter), last_region)
                last_region = last_region.next_r
            else:
                first_region = Region(True, int(datum), str(counter))
                last_region = first_region
        else:
            assert last_region
            last_region.next_r = Region(False, int(datum), prev_r=last_region)
            last_region = last_region.next_r

    assert first_region
    assert last_region

    right = last_region
    while right:
        next_right = right.prev_r

        if right.is_disk:
            left = first_region
            while left and left != right:
                #
                # We've found a spot where an insertion works
                #
                if not left.is_disk and left.size >= right.size:
                    left.size -= right.size

                    #
                    # Insert a new empty region where the right region was
                    #
                    new_region = Region(False, right.size, prev_r=right.prev_r, next_r=right.next_r)
                    if right.next_r:
                        right.next_r.prev_r = new_region
                    if right.prev_r:
                        right.prev_r.next_r = new_region

                    #
                    # Insert the right_region before the left_region
                    #
                    right.next_r = left
                    right.prev_r = left.prev_r
                    if left.prev_r:
                        left.prev_r.next_r = right
                    left.prev_r = right

                    break
                left = left.next_r

        right = next_right


    final_intermediate = []
    region = first_region
    while region:
        if region.size:
            final_intermediate.extend([region.name] * region.size)
        region = region.next_r

    total = 0
    for base, char in enumerate(final_intermediate):
        if char == ".":
            continue
        total += int(char) * base

    return total



if __name__ == "__main__":
    # print(main(get_data("day_9_input_test.txt")))
    print(main(get_data("day_9_input.txt")))
```
