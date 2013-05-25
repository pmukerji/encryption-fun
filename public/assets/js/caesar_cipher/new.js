(function() {
  var encrypt, shift, updateData, updateShift;

  shift = 0;

  updateData = function() {
    return encrypt();
  };

  encrypt = function() {
    var encrypted_message, i, length, message, num, _i, _ref;

    message = $("#message").val();
    length = message.length;
    encrypted_message = "";
    for (i = _i = 0, _ref = length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
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
