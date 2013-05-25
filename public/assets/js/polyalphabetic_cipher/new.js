(function() {
  var decrypt, letterToNum, normalizeToLetter, numToLetter, shift, updateData;

  shift = "example";

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

  updateData = function() {
    return decrypt();
  };

  decrypt = function() {
    var decrypted_message, i, j, message, message_length, num_message_char, num_shift_key_char, shift_key, shift_length, _i, _ref;

    message = $("#message").val();
    shift_key = $("#shift_key").val();
    message_length = message.length;
    shift_length = shift_key.length;
    decrypted_message = "";
    j = 0;
    for (i = _i = 0, _ref = message_length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
      num_message_char = letterToNum(message.charAt(i));
      num_shift_key_char = letterToNum(shift_key.charAt(j));
      if (num_message_char >= 0 && num_message_char < 26 && num_shift_key_char >= 0 && num_shift_key_char < 26) {
        decrypted_message += numToLetter(normalizeToLetter(num_message_char + num_shift_key_char));
      } else {
        decrypted_message += message.charAt(i);
      }
      j = j + 1;
      if (j >= shift_length) {
        j = 0;
      }
    }
    return $("#decrypted_message").html(decrypted_message);
  };

  $(document).ready(function() {
    $("#message").keyup(function() {
      return updateData();
    });
    $("#shift_key").keyup(function() {
      return updateData();
    });
    return updateData();
  });

}).call(this);
