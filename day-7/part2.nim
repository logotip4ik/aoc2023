import std/[strutils, sequtils, algorithm]

type
  GameType = enum
    HighCard
    OnePair
    TwoPair
    ThreeOfAKind
    FullHouse
    FourOfAKind
    FiveOfAKind
  Game = object
    hand: string
    bid: int
    ttype: GameType

const labels = ['A', 'K', 'Q', 'T', '9', '8', '7', '6', '5', '4', '3', '2', 'J'].reversed()

proc `<`(a: Game, b: Game): bool =
  if a.ttype != b.ttype:
    return a.ttype < b.ttype

  for i, _ in a.hand:
    let aIdx = labels.find(a.hand[i])
    let bIdx = labels.find(b.hand[i])

    if aIdx != bIdx:
      return aIdx < bIdx

proc determinType(normalHand: string): GameType =
  var hand = normalHand

  if hand.contains('J'):
    var maxChar = ('A', 0)
    for ch in hand[0..^1]:
      if ch == 'J': continue
      let count = hand.count(ch)
      if count > maxChar[1]:
        maxChar[0] = ch
        maxChar[1] = count
    hand = hand.replace('J', maxChar[0])

  if normalHand != hand and normalHand == "2JJJJ":
    echo normalHand & " => " & hand

  let handDeduplicated = hand.items.toSeq().deduplicate()

  if handDeduplicated.len() == 1:
    return GameType.FiveOfAKind

  if handDeduplicated.len() == 2:
    let count = hand.count(handDeduplicated[0])
    if count == 4 or count == 1: return GameType.FourOfAKind
    else: return GameType.FullHouse

  if handDeduplicated.len() == 3:
    if hand.count(handDeduplicated[0]) == 3 or hand.count(handDeduplicated[1]) == 3 or hand.count(handDeduplicated[2]) == 3:
      return GameType.ThreeOfAKind
    else:
      return GameType.TwoPair

  if handDeduplicated.len() == 4:
    return GameType.OnePair

  return GameType.HighCard

proc newGame(hand: string, bid: int): Game =
  return Game(
    hand: hand,
    bid: bid,
    ttype: determinType(hand)
  )

let games: seq[Game] = readFile("input.txt")
  .strip()
  .splitLines()
  .map(
    proc (game: string): Game = 
      let t = game.splitWhitespace()
      return newGame(t[0], t[1].parseInt())
  )

var winnings = 0;
for rank, game in games.sorted():
  echo game
  winnings += (rank + 1) * game.bid

echo winnings
