(function() {
  var calculate, count_array, data, datafix, decrypt, english_letter_frequencies, height, i, margin, redraw, shift, standard_deviation, svg, updateData, updateShift, width, x, xAxis, xfix, y, yAxis, yfix, _i, _j;

  english_letter_frequencies = [8.167, 1.492, 2.782, 4.253, 12.702, 2.228, 2.015, 6.094, 6.966, 0.153, 0.772, 4.025, 2.406, 6.749, 7.507, 1.929, 0.095, 5.987, 6.327, 9.056, 2.758, 0.978, 2.360, 0.150, 1.974, 0.074];

  shift = 25;

  data = [];

  datafix = [];

  count_array = [];

  for (i = _i = 0; _i <= 25; i = ++_i) {
    count_array[i] = 0;
    data[i] = {
      "letter": numToLetter(i),
      "frequency": 0
    };
  }

  for (i = _j = 0; _j <= 25; i = ++_j) {
    datafix[i] = {
      "letter": numToLetter(i),
      "frequency": english_letter_frequencies[i] / 100.0
    };
  }

  margin = {
    top: 20,
    right: 20,
    bottom: 30,
    left: 40
  };

  width = 960 - margin.left - margin.right;

  height = 240 - margin.top - margin.bottom;

  x = d3.scale.ordinal().rangeRoundBands([0, width], .1, 1);

  y = d3.scale.linear().range([height, 0]);

  xfix = d3.scale.ordinal().rangeRoundBands([0, width], .1, 1);

  yfix = d3.scale.linear().range([height, 0]);

  xAxis = d3.svg.axis().scale(x).orient("bottom");

  yAxis = d3.svg.axis().scale(y).orient("left");

  svg = d3.select("#barchart").append("svg").attr("width", width + margin.left + margin.right).attr("height", height + margin.top + margin.bottom).append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  x.domain(data.map(function(d) {
    return d.letter;
  }));

  y.domain([0, 0.2]);

  xfix.domain(datafix.map(function(d) {
    return d.letter;
  }));

  yfix.domain([0, 0.2]);

  svg.append("g").attr("class", "x axis").attr("transform", "translate(0," + height + ")").call(xAxis);

  svg.append("g").attr("class", "y axis").call(yAxis).append("text").attr("transform", "rotate(-90)").attr("y", 6).attr("dy", ".71em").style("text-anchor", "end").text("Frequency");

  svg.selectAll(".barfix").data(datafix).enter().append("rect").attr("class", "barfix").attr("x", function(d) {
    return xfix(d.letter);
  }).attr("width", x.rangeBand()).attr("y", function(d) {
    return yfix(d.frequency);
  }).attr("height", function(d) {
    return height - yfix(d.frequency);
  });

  svg.selectAll(".bar").data(data).enter().append("rect").attr("class", "bar").attr("x", function(d) {
    return x(d.letter);
  }).attr("width", x.rangeBand()).attr("y", function(d) {
    return y(d.frequency);
  }).attr("height", function(d) {
    return height - y(d.frequency);
  });

  updateData = function() {
    var count, length, message, total, _k, _l, _m, _ref;

    message = $("#message").val();
    length = message.length;
    count = count_array.slice();
    for (i = _k = 0, _ref = length - 1; 0 <= _ref ? _k <= _ref : _k >= _ref; i = 0 <= _ref ? ++_k : --_k) {
      if (letterToNum(message.charAt(i)) < 26) {
        count[letterToNum(message.charAt(i))] += 1;
      }
    }
    total = 0.0;
    for (i = _l = 0; _l <= 25; i = ++_l) {
      total += count[i];
    }
    for (i = _m = 0; _m <= 25; i = ++_m) {
      data[i].frequency = count[i] / total;
    }
    return redraw();
  };

  redraw = function() {
    var delay, transition, y0;

    y0 = y.domain([0, 0.2]);
    transition = svg.transition().duration(500);
    delay = function(d, i) {
      return i * 1;
    };
    transition.selectAll(".bar").delay(delay).attr("y", function(d) {
      return y0(d.frequency);
    });
    transition.select(".y.axis").call(yAxis).selectAll("g").delay(delay);
    svg.selectAll(".bar").data(data).transition().duration(1000).attr("y", function(d) {
      return y(d.frequency);
    }).attr("height", function(d) {
      return height - y(d.frequency);
    });
    return decrypt();
  };

  decrypt = function() {
    var decrypted_message, length, message, num, _k, _ref;

    message = $("#message").val();
    length = message.length;
    decrypted_message = "";
    for (i = _k = 0, _ref = length - 1; 0 <= _ref ? _k <= _ref : _k >= _ref; i = 0 <= _ref ? ++_k : --_k) {
      num = letterToNum(message.charAt(i));
      if (num >= 0 && num < 26) {
        decrypted_message += numToLetter(normalizeToLetter(num - shift));
      } else {
        decrypted_message += message.charAt(i);
      }
    }
    $("#decrypted_message").html(decrypted_message);
    return calculate();
  };

  updateShift = function() {
    var delay, transition, xfix0, _k;

    $("#shift").html(shift);
    decrypt();
    for (i = _k = 0; _k <= 25; i = ++_k) {
      datafix[i] = {
        "letter": numToLetter(normalizeToLetter(i - shift)),
        "frequency": english_letter_frequencies[normalizeToLetter(i - shift)] / 100.0
      };
    }
    xfix0 = xfix.domain(datafix.map(function(d) {
      return d.letter;
    }));
    transition = svg.transition().duration(400);
    delay = function(d, i) {
      return i * 1;
    };
    transition.select(".x.axis").call(xAxis).selectAll("g").delay(delay);
    return transition.selectAll(".barfix").delay(delay).attr("x", function(d) {
      return xfix0(d.letter);
    });
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
    updateData();
    return updateShift();
  });

  calculate = function() {
    var arr, arr2, corr, j, sdx, sdy, total, xmean, xy, ymean, _k, _l, _m, _n;

    arr = count_array.splice();
    arr2 = count_array.splice();
    for (i = _k = 0; _k <= 25; i = ++_k) {
      arr[i] = data[i].frequency;
      arr2[i] = datafix[i].frequency;
    }
    total = 0.0;
    for (i = _l = 0; _l <= 25; i = ++_l) {
      total += arr[i];
    }
    xmean = total / arr.length;
    total = 0.0;
    for (i = _m = 0; _m <= 25; i = ++_m) {
      total += arr2[i];
    }
    ymean = total / arr2.length;
    sdx = standard_deviation(arr);
    sdy = standard_deviation(arr2);
    xy = 0;
    for (j = _n = 0; _n <= 25; j = ++_n) {
      xy += (arr[j] - xmean) * (arr2[j] - ymean);
    }
    corr = Math.round(1 / (arr.length - 1) * xy / (sdx * sdy) * 10000) / 10000;
    $("#num_inputs").html(arr.length);
    $("#correlation").html(corr);
    $("#message_mean").html(xmean);
    $("#language_mean").html(ymean);
    $("#message_std").html(Math.round(sdx * 10000) / 10000);
    return $("#language_std").html(Math.round(sdy * 10000) / 10000);
  };

  standard_deviation = function(arr) {
    var flag, lcm, mean, sd, total, xm2, _k, _l;

    lcm = 0;
    flag = false;
    total = 0.0;
    for (i = _k = 0; _k <= 25; i = ++_k) {
      total += arr[i];
      mean = total / arr.length;
      mean = Math.round(mean * 10000) / 10000;
      xm2 = 0.0;
      for (i = _l = 0; _l <= 25; i = ++_l) {
        xm2 += Math.pow(arr[i] - mean, 2);
      }
      sd = xm2 / (arr.length - 1);
      sd = Math.sqrt(sd);
      return sd;
    }
  };

}).call(this);
