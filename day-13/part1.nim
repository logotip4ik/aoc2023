import std/[strutils, sequtils]

let lines = readFile("input.txt").strip().splitLines()

let patternsCount = lines.count("") + 1
var patterns = newSeq[seq[string]](patternsCount)

var i = 0
for line in lines:
  if line.len() == 0:
    i += 1
  else:
    patterns[i].add(line)

proc validatePivot(pattern: seq[string], pivot: int): bool =
  for i in countup(0, pattern.len() - 1):
    let prevIdx = pivot - i
    let nextIdx = pivot + i + 1

    if prevIdx < 0 or nextIdx > pattern.len() - 1:
      return true

    if pattern[prevIdx] != pattern[nextIdx]:
      return false

  return false

proc findHorizontalMirror(pattern: seq[string]): int =
  for i in countup(0, pattern.len() - 2):
    if pattern[i] == pattern[i + 1]:
      if validatePivot(pattern, i) == true:
        return i + 1

  return -1

proc rotateMatrix(pattern: seq[string]): seq[string] =
  for i in 0..<pattern[0].len():
    var row = ""

    for j in 0..<pattern.len():
      row.add(pattern[j][i])

    result.add(row)

var sum = 0;
for pattern in patterns:
  var num = findHorizontalMirror(pattern)

  if num == -1:
    let rotated = rotateMatrix(pattern)
    num = findHorizontalMirror(rotated)
  else:
    num *= 100

  if num == -1:
    echo "broken pattern:\n" & pattern.join("\n") & "\n"
  else:
    sum += num

echo sum
