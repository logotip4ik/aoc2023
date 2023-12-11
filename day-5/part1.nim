import std/[strutils, sequtils]

let file = readFile("input.txt").strip().splitLines()
var seeds = file[0].split(": ")[1].splitWhitespace().map(parseInt)
var maps = newSeq[seq[(int, int, int)]](7)

# NOTE: this is not fully my solution
# i came up with different one, that transformes seeds with current map when it sees empy line
# but, it did not work for some reason

proc transform(seed: int): int =
  result = seed

  for map in maps:
    for (dest, sourceStart, rangeLen) in map:
      if result >= sourceStart and result < sourceStart + rangeLen:
        result = dest + (result - sourceStart)
        break

var i = -1;
for line in file[2..^1]:
  if line.len == 0:
    continue

  if not line[0].isDigit():
    i += 1
    continue

  let nums = line.splitWhitespace().map(parseInt)
  maps[i].add(
    (nums[0], nums[1], nums[2])
  )


for i, seed in seeds:
  seeds[i] = transform(seed)

echo min(seeds)
