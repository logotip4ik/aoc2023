import std/[strutils, sequtils, nre, math]

let digitRE = re"\d+"
let lines = readFile("input.txt")
  .splitLines()
  .filterIt(it.strip().len != 0)
  .mapIt(it.split(": ")[1])
  .mapIt(it.split(" | "))

var sum = 0

for line in lines:
  let winningNumbers = findAll(line[0], digitRE).deduplicate()
  let numbers = findAll(line[1], digitRE)

  let order = winningNumbers.mapIt(numbers.count(it)).foldl(a + b)

  if order == 0: continue

  sum += 2 ^ (order - 1)

echo sum
