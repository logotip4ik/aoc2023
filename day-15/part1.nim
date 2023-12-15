import std/[strutils,sequtils]

let input = readFile("input.txt").strip().split(",")

proc hashString(s: string): int =
  result = 0

  for c in s:
    result += int(c)
    result *= 17
    result = result mod 256

echo input.map(hashString).foldl(a + b)
