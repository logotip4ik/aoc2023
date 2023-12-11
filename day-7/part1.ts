import fs from 'fs'

enum CardType {
  FiveOfAKind = 7,
  FourOfAKind = 6,
  FullHouse = 5,
  ThreeOfAKind = 4,
  TwoPair = 3,
  OnePair = 2,
  HighCard = 1,
}
const labels = ['A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2'].reverse()

const lines: string[] = fs.readFileSync('input.txt', "utf-8").trim().split("\n")

type Card = {
  hand: string
  bid: number
  type: CardType
}

const cards: Card[] = []
for (const line of lines) {
  const splitted = line.split(" ")
  const hand: Card = {
    hand: splitted[0],
    bid: Number(splitted[1]),
    type: determinType(splitted[0]),
  }

  cards.push(hand)
}

const sum = cards
  .sort((a, b) => {
    if (a.type !== b.type) {
      return a.type - b.type
    }

    return compareHands(a.hand, b.hand)
  })
  .reduce((acc, card, i) => acc + (card.bid * (i + 1)),0)

console.log(sum)

function compareHands(handA: string, handB: string): number {
  for (let i = 0; i < handA.length; i++) {
    const a = labels.indexOf(handA[i])
    const b = labels.indexOf(handB[i])

    if (a !== b) {
      return a - b
    }
  }

  return 0
}

function determinType(hand: string): CardType {
  const splittedHand = hand.split('')
  const uniqHand = Array.from(new Set(splittedHand))

  if (uniqHand.length === 1) {
    return CardType.FiveOfAKind
  }

  if (uniqHand.length === 2) {
    const c = count(splittedHand, uniqHand[0])
    if (c === 1 || c === 4) {
      return CardType.FourOfAKind
    } else {
      return CardType.FullHouse
    }
  }

  if (uniqHand.length === 3) {
    if (
      count(splittedHand, uniqHand[0]) === 2
      || count(splittedHand, uniqHand[1]) === 2
      || count(splittedHand, uniqHand[2]) === 2
    ) {
      return CardType.TwoPair
    }
    else {
      return CardType.ThreeOfAKind
    }
  }

  if (uniqHand.length === 4) {
    return CardType.OnePair
  }

  return CardType.HighCard
}

function count<T>(array: T[], element: T): number {
  return array.filter(x => x == element).length
}
