import std/[strutils, sequtils, re]

let digitRE = re"^(\d|one|two|three|four|five|six|seven|eight|nine)"
let lines = readFile("input.txt").splitLines().filterIt(it.strip().len != 0)
var sum = 0;

func normalizeNumString(str: string): string =
  try:
    discard str.parseInt()
    return str
  except ValueError:
    case str:
      of "one": return "1"
      of "two": return "2"
      of "three": return "3"
      of "four": return "4"
      of "five": return "5"
      of "six": return "6"
      of "seven": return "7"
      of "eight": return "8"
      of "nine": return "9"
      else: return ""

for line in lines:
  var digits: seq[string]

  for i in 0..line.len:
    let chunk = line.substr(i, i + 5)
    let (first, last) = chunk.findBounds(digitRE)

    if first == -1:
      continue

    let digit = chunk.substr(first, last)
    let normalizedDigit = normalizeNumString(digit)

    if normalizedDigit.len != 0:
      digits.add(normalizedDigit)
    
  let digit = normalizeNumString(digits[0]) & normalizeNumString(digits[digits.len - 1])
  sum += digit.parseInt()

echo sum
