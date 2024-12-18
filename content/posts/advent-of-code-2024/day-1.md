---
title: Advent of Code 2024 - Day 1
date: Tue Dec 17 20:14:50 2024
toc: true
tags: ["Advent of Code"]
---

## Part 1

```python {linenos=inline}
def get_data(path):
    list_1 = []
    list_2 = []
    with open(path) as f:
        for line in f:
            item_1, item_2 = line.split()
            list_1.append(int(item_1))
            list_2.append(int(item_2))
    return list_1, list_2

def main(list_1, list_2):
    output = 0
    for element_1, element_2 in zip(sorted(list_1), sorted(list_2)):
        output += abs(element_2 - element_1)
    return output

if __name__ == "__main__":
    print(main(*get_data("day_1_input.txt")))
```

## Part 2

```python {linenos=inline}
import collections

def get_data(path):
    list_1 = []
    list_2 = []
    with open(path) as f:
        for line in f:
            item_1, item_2 = line.split()
            list_1.append(int(item_1))
            list_2.append(int(item_2))
    return list_1, list_2

def main(list_1, list_2):
    counter = collections.Counter(list_2)

    output = 0
    for element_1 in list_1:
        if element_1 in counter:
            output += element_1 * counter[element_1]
    return output

if __name__ == "__main__":
    print(main(*get_data("day_1_input.txt")))
```
