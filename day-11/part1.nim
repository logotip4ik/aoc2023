import std/[strutils, nre]

type
  Galaxy = tuple[i, x, y: int]
  Connection = tuple[a, b: Galaxy]

var lines = readFile("input.txt").strip().splitLines()

# Expanding space
var i = 0
while i < lines.len():
  if not lines[i].contains('#'):
    lines.insert(
      '.'.repeat(lines[0].len()),
      i
    )
    i += 2
  else:
    i += 1

i = 0
while i < lines[0].len():
  var containsGalaxy = false
  for line in lines:
    if line[i] == '#':
      containsGalaxy = true
      break
  
  if not containsGalaxy:
    for j, _ in lines:
      lines[j].insert(
        ".",
        i
      )
    i += 2
  else:
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
  let yDiff = abs(conn.a.y - conn.b.y)
  let xDiff = abs(conn.a.x - conn.b.x)

  return yDiff + xDiff

var sum = 0
for i, galaxy in galaxies:
  for j in countup(i + 1, galaxies.len() - 1):
    sum += findMinDistance((galaxy, galaxies[j]))

echo sum
