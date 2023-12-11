import std/[strutils, sequtils, nre]

let numberRE = re"\d+"
let starRE = re"\*"
var lines = readFile("input.txt").splitLines().filterIt(it.strip().len != 0)

proc findNum(line: var string, pos: int): string =
  for m in findIter(line, numberRE):
    if (m.matchBounds.contains(pos)):
      line.delete(m.matchBounds.a, m.matchBounds.b)
      line.insert("*".repeat(m.match.len()), m.matchBounds.a)
      return m.match

var sum = 0;
for i, line in lines:
  let loopLines = [
    lines[max(i - 1, 0)],
    line,
    lines[min(i + 1, lines.len() - 1)],
  ]

  for star in findIter(line, starRE):
    let starIdx = star.matchBounds.a
    let loopIdxs = [
      max(starIdx - 1, 0),
      starIdx,
      min(starIdx + 1, line.len() - 1),
    ]

    var firstChar, secondChar = "";

    for j, l in loopLines:
      for idx in loopIdxs:
        if isDigit(l[idx]):
          if firstChar == "":
            firstChar = findNum(lines[i + j - 1], idx)
          elif secondChar == "":
            secondChar = findNum(lines[i + j - 1], idx)

    if firstChar != "" and secondChar != "":
      echo firstChar & " * " & secondChar
      sum += firstChar.parseInt() * secondChar.parseInt()
  
  echo "\n"

echo sum
