import std/[strutils,sequtils]

type
  Operation = enum
    Equals
    Dash

let input = readFile("input.txt")
  .strip()
  .split(",")
  .map(
    proc (x: string): (string, Operation, int) =
      var opType = Operation.Dash
      var splitted = x.split('-')

      if splitted.len() == 1:
        splitted = x.split('=')
        opType = Operation.Equals
      
      return (
        splitted[0],
        opType,
        if splitted[1].len != 0: splitted[1].parseInt else: 0
      )
  )

proc hashString(s: string): int =
  result = 0

  for c in s:
    result += int(c)
    result *= 17
    result = result mod 256

var boxes = newSeq[seq[(string, int)]](256)
for step in input:
  let boxIdx = hashString(step[0])
  let lens = (step[0], step[2])

  case step[1]:
    of Operation.Equals:
      var replaced = false
      for i in 0..<boxes[boxIdx].len():
        if boxes[boxIdx][i][0] == lens[0]:
          boxes[boxIdx][i] = lens
          replaced = true
        
      if not replaced:
        boxes[boxIdx].add(lens)
    of Operation.Dash:
      var lensIdx = -1
      for i in 0..<boxes[boxIdx].len():
        if boxes[boxIdx][i][0] == lens[0]:
          lensIdx = i
          break

      if lensIdx != -1:
        boxes[boxIdx].delete(lensIdx..lensIdx)

var sum = 0
for i, box in boxes:
  for j, lens in box:
    sum += (i + 1) * (j + 1) * lens[1]

echo sum
