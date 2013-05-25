(function() {
  var root;

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  root.numToLetter = function(num) {
    return String.fromCharCode(97 + (num % 26));
  };

  root.letterToNum = function(letter) {
    return letter.charCodeAt(0) - 97;
  };

  root.normalizeToLetter = function(num) {
    if (num > 25) {
      return num - 26;
    } else if (num < 0) {
      return num + 26;
    } else {
      return num;
    }
  };

}).call(this);
