import std/[strutils, sequtils, nre]

type
  Bag = object
    red, green, blue: int

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

# var games: seq[Bag]
var sum = 0;
for i, line in lines:
  let game = line
      .substr(line.find(":") + 2, line.len)
      .split("; ")
      .mapIt(parseSetString(it))
  
  if game.allIt(it <= inputBag): sum += i + 1

echo sum
