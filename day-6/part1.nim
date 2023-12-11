import std/[strutils, sequtils]

type
  Race = tuple
    time, dist: int

let lines = readFile("input.txt")
  .strip()
  .splitLines()
  .mapIt(it.split(": ")[1].strip())
  .mapIt(it.splitWhitespace().map(parseInt))

var wins = newSeq[int](lines[0].len())

proc countWins(race: Race): int =
  result = 0

  for duration in countup(1, race.time - 1):
    let diff = race.time - duration
    let traveled = diff * duration
    if traveled > race.dist: result += 1

for i in countup(0, lines[0].len() - 1):
  let race: Race = (lines[0][i], lines[1][i])

  wins[i] = countWins(race)

echo wins.foldl(a * b)
