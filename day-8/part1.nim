import std/[strutils, sequtils, tables]

let lines = readFile("input.txt").strip().splitLines()

let instructions = lines[0]
let map = lines[2..^1]
  .map(
    proc (x: string): (string, (string, string)) =
      let splitted = x.split(" = ")
      let moves = splitted[1][1..^2].split(", ")

      return (splitted[0], (moves[0], moves[1]))
  )
  .toTable()

const startPos = "AAA"
const endPos = "ZZZ"
var currentPos = startPos;
var i = 0

while currentPos != endPos:
  let move = instructions[i mod instructions.len()]

  if move == 'L':
    currentPos = map[currentPos][0]
  elif move == 'R':
    currentPos = map[currentPos][1]

  i += 1

echo i
