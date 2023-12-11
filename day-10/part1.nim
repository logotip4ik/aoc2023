import std/[strutils, sequtils, tables]

let lines = readFile("input.txt").strip().splitLines()

type
  # x, y, left-top corner is -1, -1
  Move = tuple
    x, y: int
  Pos = Move
  Connection = tuple
    a, b: Move
  Searcher = object
    currentPos, prevPos: Pos

proc `+`(a: Move, b: Move): Move =
  result.x = a.x + b.x
  result.y = a.y + b.y

const connections: Table[char, Connection] = {
  '|': (a: ( 0, -1), b: ( 0, 1)),
  '-': (a: (-1,  0), b: ( 1, 0)),
  'L': (a: ( 0, -1), b: ( 1, 0)),
  'J': (a: ( 0, -1), b: (-1, 0)),
  '7': (a: (-1,  0), b: ( 0, 1)),
  'F': (a: ( 1,  0), b: ( 0, 1)),
}.toTable()

proc move(searcher: var Searcher) =
  let c = lines[searcher.currentPos.y][searcher.currentPos.x]
  let connection = connections[c]
  var nextPos = searcher.currentPos + connection.a

  if nextPos == searcher.prevPos:
    nextPos = searcher.currentPos + connection.b

  searcher.prevPos = searcher.currentPos
  searcher.currentPos = nextPos

var startPos: Pos;
for y, line in lines:
  let x = line.find('S')
  if x != -1:
    startPos = (x, y)
    break

var searchers: seq[Searcher]
const possibleMoves = [
  ( 0, -1),
  ( 1,  0),
  ( 0,  1),
  (-1,  0),
]
for move in possibleMoves:
  let nextPos = startPos + move
  if nextPos.x >= 0 and nextPos.y >= 0 and nextPos.y <= lines.len() and nextPos.x <= lines[nextPos.y].len():
    let c = lines[nextPos.y][nextPos.x]
    if c == '.': continue
    let m = connections[c]

    if m.a + move == (0, 0) or m.b + move == (0, 0):
      searchers.add(
        Searcher(currentPos: startPos + move, prevPos: startPos)
      )

var i = 1;
while searchers[0].currentPos != searchers[1].currentPos:
  searchers[0].move()
  searchers[1].move()
  i += 1

echo i
