(function() {
  var count_array, data, datafix, encrypt, english_letter_frequencies, i, letterToNum, normalizeToLetter, numToLetter, shift, updateData, updateShift, _i;

  english_letter_frequencies = [8.167, 1.492, 2.782, 4.253, 12.702, 2.228, 2.015, 6.094, 6.966, 0.153, 0.772, 4.025, 2.406, 6.749, 7.507, 1.929, 0.095, 5.987, 6.327, 9.056, 2.758, 0.978, 2.360, 0.150, 1.974, 0.074];

  shift = 0;

  data = [];

  datafix = [];

  count_array = [];

  numToLetter = function(num) {
    return String.fromCharCode(97 + (num % 26));
  };

  letterToNum = function(letter) {
    return letter.charCodeAt(0) - 97;
  };

  normalizeToLetter = function(num) {
    if (num > 25) {
      return num - 26;
    } else if (num < 0) {
      return num + 26;
    } else {
      return num;
    }
  };

  for (i = _i = 0; _i <= 25; i = ++_i) {
    count_array[i] = 0;
    data[i] = {
      "letter": numToLetter(i),
      "frequency": 0
    };
  }

  updateData = function() {
    var count, length, message, total, _j, _k, _l, _ref;

    message = $("#message").val();
    length = message.length;
    count = count_array.slice();
    for (i = _j = 0, _ref = length - 1; 0 <= _ref ? _j <= _ref : _j >= _ref; i = 0 <= _ref ? ++_j : --_j) {
      if (letterToNum(message.charAt(i)) < 26) {
        count[letterToNum(message.charAt(i))] += 1;
      }
    }
    total = 0.0;
    for (i = _k = 0; _k <= 25; i = ++_k) {
      total += count[i];
    }
    for (i = _l = 0; _l <= 25; i = ++_l) {
      data[i].frequency = count[i] / total;
    }
    return encrypt();
  };

  encrypt = function() {
    var encrypted_message, length, message, num, _j, _ref;

    message = $("#message").val();
    length = message.length;
    encrypted_message = "";
    for (i = _j = 0, _ref = length - 1; 0 <= _ref ? _j <= _ref : _j >= _ref; i = 0 <= _ref ? ++_j : --_j) {
      num = letterToNum(message.charAt(i));
      if (num >= 0 && num < 26) {
        encrypted_message += numToLetter(normalizeToLetter(num + shift));
      } else {
        encrypted_message += message.charAt(i);
      }
    }
    return $("#encrypted_message").html(encrypted_message);
  };

  updateShift = function() {
    $("#shift").html(shift);
    return encrypt();
  };

  $(document).ready(function() {
    $("#left_button").click(function() {
      shift = normalizeToLetter(shift - 1);
      return updateShift();
    });
    $("#right_button").click(function() {
      shift = normalizeToLetter(shift + 1);
      return updateShift();
    });
    $("#message").keyup(function() {
      return updateData();
    });
    return updateData();
  });

}).call(this);
