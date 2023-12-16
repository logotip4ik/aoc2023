import std/[strutils, tables]

type
  Board = seq[string]

let lines = readFile("input.txt").strip().splitLines()
const oneBill = 1000000000

proc moveRocksUp(lines: Board): Board =
  result = lines

  var hadMovedRocks = true
  var i = 0

  while hadMovedRocks:
    hadMovedRocks = false
    i += 1

    if i == 10000:
      echo "found inf loop:\n"
      echo result.join("\n") & "\n"
      break

    for i in countup(1, lines.len() - 1):
      for j in 0..<result[i].len():
        if result[i][j] == 'O' and result[i - 1][j] == '.':
          result[i][j] = '.'
          result[i - 1][j] = 'O'
          hadMovedRocks = true

proc moveRocksDown(lines: Board): Board =
  result = lines

  var hadMovedRocks = true
  var i = 0

  while hadMovedRocks:
    hadMovedRocks = false
    i += 1

    if i == 10000:
      echo "found inf loop:\n"
      echo result.join("\n") & "\n"
      break

    for i in countdown(result.len() - 2, 0):
      for j in 0..<result[i].len():
        if result[i][j] == 'O' and result[i + 1][j] == '.':
          result[i][j] = '.'
          result[i + 1][j] = 'O'
          hadMovedRocks = true

proc moveRocksRight(lines: Board): Board =
  result = lines
  
  var hadMovedRocks = true
  var i = 0

  while hadMovedRocks:
    hadMovedRocks = false
    i += 1

    if i == 10000:
      echo "found inf loop:\n"
      echo result.join("\n") & "\n"
      break

    for i in countup(0, result[0].len() - 2):
      for j in 0..<result.len():
        if result[j][i] == 'O' and result[j][i + 1] == '.':
          result[j][i] = '.'
          result[j][i + 1] = 'O'
          hadMovedRocks = true

proc moveRocksLeft(lines: Board): Board =
  result = lines

  var hadMovedRocks = true
  var i = 0

  while hadMovedRocks:
    hadMovedRocks = false
    i += 1

    if i == 10000:
      echo "found inf loop:\n"
      echo result.join("\n") & "\n"
      break

    for i in countdown(result[0].len() - 1, 1):
      for j in 0..<result.len():
        if result[j][i] == 'O' and result[j][i - 1] == '.':
          result[j][i] = '.'
          result[j][i - 1] = 'O'
          hadMovedRocks = true

var cache: Table[Board, Board]
proc cycle(lines: Board): Board =
  if lines in cache:
    return cache[lines]

  result = moveRocksUp(lines)
  result = moveRocksLeft(result)
  result = moveRocksDown(result)
  result = moveRocksRight(result)

  cache[lines] = result

var prevCacheLen = 0
var stepsToLoop = 0
var l = cycle(lines)

for i in 1..oneBill:
  l = cycle(l)

  if prevCacheLen == cache.len():
    stepsToLoop = prevCacheLen
    break
  else:
    prevCacheLen = cache.len()

let loopsInOneBill = int(oneBill / stepsToLoop)
let skippableCycles = loopsInOneBill * stepsToLoop
let cyclesToDo = oneBill - skippableCycles

l = lines
for i in 0..<cyclesToDo:
  l = cycle(l)

var sum = 0

for i, line in l:
  sum += line.count('O') * (lines.len() - i)

echo sum

# it should work (´。＿。｀)
# 95254 ?
# Yes, it works \^o^/
