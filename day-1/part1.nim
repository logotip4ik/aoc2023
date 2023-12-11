import std/[strutils, re, sequtils]

let lines = readFile("./input.txt").splitLines().filterIt(it.strip().len != 0)
var calibrationValue = 0;

for line in lines:
  let digits = findAll(line, re"\d")
  let calibration = digits[0] & digits[digits.len - 1]

  calibrationValue += calibration.parseInt()

echo calibrationValue
