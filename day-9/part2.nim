import std/[strutils, sequtils]

var lines = readFile("input.txt")
  .strip()
  .splitLines()
  .mapIt(it.splitWhitespace().mapIt(it.parseInt()))

proc calcNextRow(row: seq[int]): seq[int] =
  for i in countup(0, row.len() - 2):
    result.add(row[i + 1] - row[i])

proc predictBackwards(line: seq[int]): int =
  var stack: seq[seq[int]] = @[
    line.toSeq(),
    calcNextRow(line)
  ]

  while not stack[^1].allIt(it == 0):
    stack.add(calcNextRow(stack[^1]))

  for i in countdown(stack.len() - 2, 0):
    stack[i].insert(stack[i][0] - stack[i + 1][0], 0)

  return stack[0][0]

var sum = 0
for i, line in lines:
  sum += predictBackwards(lines[i])

echo sum
