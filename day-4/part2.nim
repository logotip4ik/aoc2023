import std/[strutils, sequtils, nre, math]

let digitRE = re"\d+"
let lines = readFile("input.txt")
  .splitLines()
  .filterIt(it.strip().len != 0)
  .mapIt(it.split(": ")[1])
  .mapIt(it.split(" | "))

var sum = 0
var copies = newSeqWith[int](lines.len(), 1)

proc copyNextScratchcards(list: var seq[int], frompos, next: int) =
  let instances = list[frompos]
  for i in countup(frompos + 1, frompos + next):
    list[i] += instances

for i, line in lines:
  let winningNumbers = findAll(line[0], digitRE).deduplicate()
  let numbers = findAll(line[1], digitRE)

  let order = winningNumbers.mapIt(numbers.count(it)).foldl(a + b)
  
  copyNextScratchcards(copies, i, order)

echo sum(copies)
