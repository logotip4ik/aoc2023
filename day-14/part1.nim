import std/[strutils]

var lines = readFile("input.txt").strip().splitLines()

var hadMovedRocks = true
while hadMovedRocks:
  hadMovedRocks = false

  for i in 1..<lines.len():
    for j in 0..<lines[i].len():
      if lines[i][j] == 'O' and lines[i - 1][j] == '.':
        lines[i - 1][j] = 'O'
        lines[i][j] = '.'
        hadMovedRocks = true

var sum = 0

for i, line in lines:
  sum += line.count('O') * (lines.len() - i)

echo sum
