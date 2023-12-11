import std/[strutils, nre]

type
  Galaxy = tuple[i, x, y: int]
  Connection = tuple[a, b: Galaxy]

var lines = readFile("input.txt").strip().splitLines()

# Find what columns and rows should be multiplied by 1000000 (1 mill)
var i = 0
var emptyRows: seq[int]
var emptyCols: seq[int]

while i < lines.len():
  if not lines[i].contains('#'):
    emptyRows.add(i)

  i += 1

i = 0
while i < lines[0].len():
  var containsGalaxy = false
  for line in lines:
    if line[i] == '#':
      containsGalaxy = true
      break
  
  if not containsGalaxy:
    emptyCols.add(i)

  i += 1

# Find galaxies
let galaxyRE = re"#"
var galaxies: seq[Galaxy]
for y, line in lines:
  for galaxy in line.findIter(galaxyRE):
    galaxies.add(
      (galaxies.len() + 1, galaxy.matchBounds.a, y)
    )

# Make pairs and find distance
proc findMinDistance(conn: Connection): int =
  var yDiff = abs(conn.a.y - conn.b.y)
  var xDiff = abs(conn.a.x - conn.b.x)

  let xMin = min(conn.a.x, conn.b.x)
  let xMax = max(conn.a.x, conn.b.x)

  for num in emptyCols:
    if num > xMin and num < xMax:
      xDiff += 999999

  let yMin = min(conn.a.y, conn.b.y)
  let yMax = max(conn.a.y, conn.b.y)

  for num in emptyRows:
    if num > yMin and num < yMax:
      yDiff += 999999

  return yDiff + xDiff

var sum = 0
for i, galaxy in galaxies:
  for j in countup(i + 1, galaxies.len() - 1):
    sum +=
      findMinDistance((galaxy, galaxies[j]))

echo sum
