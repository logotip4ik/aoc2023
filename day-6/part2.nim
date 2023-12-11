import std/[strutils, sequtils]

type
  Race = tuple
    time, dist: int

let line = readFile("input.txt")
  .strip()
  .splitLines()
  .mapIt(it.split(": ")[1].strip())
  .mapIt(it.splitWhitespace().join("").parseInt())

proc countWins(race: Race): int =
  result = 0

  for duration in countup(1, race.time - 1):
    let diff = race.time - duration
    let traveled = diff * duration
    if traveled > race.dist: result += 1

let race: Race = (time: line[0], dist: line[1])

# Absolutely loving nim (release mode), finished in 74 millis
echo countWins(race)
