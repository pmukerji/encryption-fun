# Initialize Variables

english_letter_frequencies = [8.167,1.492,2.782,4.253,12.702,2.228,2.015,6.094,6.966,0.153,0.772,4.025,2.406,6.749,7.507,1.929,0.095,5.987,6.327,9.056,2.758,0.978,2.360,0.150,1.974,0.074]
shift = 25
data = []
datafix = []
count_array = []

for i in [0..25]
  count_array[i] = 0
  data[i] = {"letter": numToLetter(i), "frequency": 0}

for i in [0..25]
  datafix[i] = {"letter": numToLetter(i), "frequency": english_letter_frequencies[i]/100.0}
  
# Chart Styling

# Margins around the plot
margin = {top: 20,right: 20,bottom: 30,left: 40}

#Width and height of the plot
width = 960 - margin.left - margin.right
height = 240 - margin.top - margin.bottom

# X and Y range for typed message
x = d3.scale.ordinal().rangeRoundBands([0, width], .1, 1)
y = d3.scale.linear().range([height, 0])

# X and Y range for the fixed language specific probabilities
xfix = d3.scale.ordinal().rangeRoundBands([0, width], .1, 1)
yfix = d3.scale.linear().range([height, 0])

# Setup the X Axis
xAxis = d3.svg.axis().scale(x).orient("bottom")

# Setup the Y Axis
yAxis = d3.svg.axis().scale(y).orient("left");

# Add Chart
svg = d3.select("#barchart").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")")


# Map the Data domains
x.domain(data.map( (d) -> d.letter ))
y.domain([0, 0.2])
xfix.domain(datafix.map( (d) -> d.letter ))
yfix.domain([0, 0.2])

# Create an element for the x access
svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis);
  
# Create another element for the y access
svg.append("g")
    .attr("class", "y axis")
    .call(yAxis)
  .append("text")
    .attr("transform", "rotate(-90)")
    .attr("y", 6)
    .attr("dy", ".71em")
    .style("text-anchor", "end")
    .text("Frequency")

# Add the probability bars
svg.selectAll(".barfix")
    .data(datafix)
  .enter().append("rect")
    .attr("class", "barfix")
    .attr("x", (d) -> xfix(d.letter) )
    .attr("width", x.rangeBand())
    .attr("y", (d) -> yfix(d.frequency) )
    .attr("height", (d) -> (height-yfix(d.frequency)) )

# Add the message letter frequency bars
svg.selectAll(".bar")
    .data(data)
  .enter().append("rect")
    .attr("class", "bar")
    .attr("x", (d) -> x(d.letter) )
    .attr("width", x.rangeBand())
    .attr("y", (d) -> y(d.frequency) )
    .attr("height", (d) -> (height - y(d.frequency)) )

# Define function for updating the data when the message changes
updateData = () -> 
  
  # Grab the message
  message = $("#message").val()
  length = message.length
  count = count_array.slice()
  
  # Build the frequency of each char
  for i in [0..length-1]
    if letterToNum(message.charAt(i)) < 26
      count[letterToNum(message.charAt(i))] += 1
  
  total = 0.0;
  for i in [0..25]
    total += count[i];
  for i in [0..25]
    data[i].frequency = count[i]/total
  
  redraw()

redraw = () ->
    
  y0 = y.domain([0, 0.2])

  transition = svg.transition().duration(500)
  delay = (d, i) -> i*1

  transition.selectAll(".bar").delay(delay).attr("y", (d) -> y0(d.frequency) )

  transition.select(".y.axis")
      .call(yAxis)
    .selectAll("g")
      .delay(delay);

  svg.selectAll(".bar")
      .data(data)
    .transition()
      .duration(1000)
      .attr("y", (d) -> y(d.frequency) )
      .attr("height", (d) -> height-y(d.frequency) )
  
  decrypt()
  
decrypt = () ->
 
  message = $("#message").val()
  length = message.length
  decrypted_message = ""
  
  for i in [0..length-1]
    num = letterToNum(message.charAt(i))

    if num >= 0 && num < 26
      decrypted_message+=(numToLetter(normalizeToLetter(num - shift)))
    else
      decrypted_message+=message.charAt(i)
  
  
  $("#decrypted_message").html(decrypted_message)
  calculate()



updateShift = () ->
  
  $("#shift").html(shift)
  
  decrypt()
  
  for i in [0..25]
    datafix[i] = {
      "letter": numToLetter(normalizeToLetter(i-shift)), 
      "frequency": english_letter_frequencies[normalizeToLetter(i-shift)]/100.0
    }
  
  xfix0 = xfix.domain(datafix.map( (d) -> d.letter ))
  
  transition = svg.transition().duration(400)
  delay = (d, i) -> i*1
  
  transition.select(".x.axis")
      .call(xAxis)
    .selectAll("g")
      .delay(delay);
      
  transition.selectAll(".barfix")
      .delay(delay)
      .attr("x", (d) -> xfix0(d.letter) )


$( document ).ready( () ->

  # Prepare the shifting buttons
  $("#left_button").click( () ->
    shift = normalizeToLetter(shift - 1)
    updateShift()
  )
  $("#right_button").click( () ->
    shift = normalizeToLetter(shift + 1);
    updateShift()
  )
  $("#message").keyup( () -> updateData())
  updateData()
  updateShift()
)

calculate = () ->

  arr = count_array.splice()
  arr2 = count_array.splice()

  for i in [0..25]
    arr[i] = data[i].frequency
    arr2[i] = datafix[i].frequency
  
  total=0.0
  
  for i in [0..25]
    total += arr[i]

  xmean=total/arr.length

  total=0.0
  for i in [0..25]
    total += arr2[i]
  ymean=total/arr2.length

  sdx=standard_deviation(arr)
  sdy=standard_deviation(arr2)
  xy=0

  for j in [0..25]
  	xy+=(arr[j]-xmean)*(arr2[j]-ymean)
  
  corr=Math.round(1/(arr.length-1)*xy/(sdx*sdy)*10000)/10000
  $("#num_inputs").html(arr.length)
  $("#correlation").html(corr)
  $("#message_mean").html(xmean)
  $("#language_mean").html(ymean)
  $("#message_std").html(Math.round(sdx*10000)/10000)
  $("#language_std").html(Math.round(sdy*10000)/10000)

standard_deviation = (arr) ->
  
	lcm=0
	flag=false
	total=0.0
  
	for i in [0..25]
		total+=arr[i]
  
  mean=total/arr.length
	
  mean=Math.round(mean*10000)/10000	
  
  xm2=0.0

  for i in [0..25]
    xm2+=Math.pow((arr[i]-mean),2)
    
  sd=xm2/(arr.length-1)
  
  sd=Math.sqrt(sd)
  
  return sd