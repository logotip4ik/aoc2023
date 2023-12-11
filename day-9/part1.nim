import std/[strutils, sequtils]

var lines = readFile("input.txt")
  .strip()
  .splitLines()
  .mapIt(it.splitWhitespace().mapIt(it.parseInt()))

proc calcNextRow(row: seq[int]): seq[int] =
  for i in countup(0, row.len() - 2):
    result.add(row[i + 1] - row[i])

proc predict(line: seq[int]): int =
  var stack: seq[seq[int]] = @[
    line.toSeq(),
    calcNextRow(line)
  ]

  while not stack[^1].allIt(it == 0):
    stack.add(calcNextRow(stack[^1]))

  for i in countdown(stack.len() - 2, 0):
    stack[i].add(stack[i + 1][^1] + stack[i][^1])

  return stack[0][^1]

var sum = 0
for i, line in lines:
  sum += predict(lines[i])

echo sum
