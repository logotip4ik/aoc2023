import std/[strutils, sequtils, nre]

let numberRE = re"\d+"
let lines = readFile("input.txt").splitLines().filterIt(it.strip().len != 0)

var sum = 0;
for i, line in lines:
  for result in findIter(line, numberRE):
    var shouldAdd = false

    let bnds = result.matchBounds()
    let prevLine = lines[max(i - 1, 0)]
    let nextLine = lines[min(i + 1, lines.len() - 1)]
    let prevCharIdx = max(bnds.a - 1, 0)
    let nextCharIdx = min(bnds.b + 1, line.len() - 1)

    if prevLine[prevCharIdx] != '.' and not isDigit(prevLine[prevCharIdx]): shouldAdd = true
    elif prevLine[bnds.a] != '.' and not isDigit(prevLine[bnds.a]): shouldAdd = true
    elif prevLine[bnds.b] != '.' and not isDigit(prevLine[bnds.b]): shouldAdd = true
    elif prevLine[nextCharIdx] != '.' and not isDigit(prevLine[nextCharIdx]): shouldAdd = true

    elif nextLine[prevCharIdx] != '.' and not isDigit(nextLine[prevCharIdx]): shouldAdd = true
    elif nextLine[bnds.a] != '.' and not isDigit(nextLine[bnds.a]): shouldAdd = true
    elif nextLine[bnds.b] != '.' and not isDigit(nextLine[bnds.b]): shouldAdd = true
    elif nextLine[nextCharIdx] != '.' and not isDigit(nextLine[nextCharIdx]): shouldAdd = true

    elif line[prevCharIdx] != '.' and not isDigit(line[prevCharIdx]): shouldAdd = true
    elif line[nextCharIdx] != '.' and not isDigit(line[nextCharIdx]): shouldAdd = true

    if not shouldAdd:
      for j in bnds.a + 1..<bnds.b:
        if prevLine[j] != '.' and not isDigit(prevLine[j]):
          shouldAdd = true
          break
        elif nextLine[j] != '.' and not isDigit(nextLine[j]):
          shouldAdd = true
          break

    if shouldAdd: sum += result.match.parseInt()

echo sum
