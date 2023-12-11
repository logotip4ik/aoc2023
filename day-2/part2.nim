import std/[strutils, sequtils, nre]

type
  Bag = object
    red, green, blue: int

proc power* (bag: Bag): int=
  result = bag.red * bag.green * bag.blue

proc `<=`* (bag: Bag, value: Bag): bool =
  result = bag.red <= value.red and bag.green <= value.green and bag.blue <= value.blue

const inputBag = Bag(red: 12, green: 13, blue: 14)
let cubeRE = re"(?:(?<green>\d+)\sgreen)|(?:(?<red>\d+)\sred)|(?:(?<blue>\d+)\sblue)"
let lines = readFile("input.txt").splitLines().filterIt(it.strip().len != 0)

proc parseSetString(setString: string): Bag =
  result = Bag()

  for capture in setString.split(", ").mapIt(it.match(cubeRE).get.captures):
    if "red" in capture: result.red += capture["red"].parseInt()
    elif "green" in capture: result.green += capture["green"].parseInt()
    elif "blue" in capture: result.blue += capture["blue"].parseInt()

proc findMinBag(game: seq[Bag]): Bag =
  result = Bag()

  for bag in game:
    if bag.red > result.red: result.red = bag.red
    if bag.green > result.green: result.green = bag.green
    if bag.blue > result.blue: result.blue = bag.blue

var sum = 0;
for i, line in lines:
  let game = line
      .substr(line.find(":") + 2, line.len)
      .split("; ")
      .mapIt(parseSetString(it))

  let minBagforGame = findMinBag(game)
  
  sum += minBagforGame.power()

echo sum
