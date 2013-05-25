root = exports ? this

root.numToLetter = (num) -> String.fromCharCode(97 + (num % 26))

root.letterToNum = (letter) -> letter.charCodeAt(0)-97

root.normalizeToLetter = (num) ->
  if num > 25
    num-26
  else if num < 0
    num+26
  else
    num