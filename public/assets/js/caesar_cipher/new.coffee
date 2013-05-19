# Initialize Variables

english_letter_frequencies = [8.167,1.492,2.782,4.253,12.702,2.228,2.015,6.094,6.966,0.153,0.772,4.025,2.406,6.749,7.507,1.929,0.095,5.987,6.327,9.056,2.758,0.978,2.360,0.150,1.974,0.074]
shift = 0
data = []
datafix = []
count_array = []

numToLetter = (num) -> String.fromCharCode(97 + (num % 26))

letterToNum = (letter) -> letter.charCodeAt(0)-97

normalizeToLetter = (num) ->
  if num > 25
    num-26
  else if num < 0
    num+26
  else
    num

for i in [0..25]
  count_array[i] = 0
  data[i] = {"letter": numToLetter(i), "frequency": 0}

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
  
  encrypt()
  
encrypt = () ->
 
  message = $("#message").val()
  length = message.length
  encrypted_message = ""
  
  for i in [0..length-1]
    num = letterToNum(message.charAt(i))

    if num >= 0 && num < 26
      encrypted_message+=(numToLetter(normalizeToLetter(num + shift)))
    else
      encrypted_message+=message.charAt(i)
  
  
  $("#encrypted_message").html(encrypted_message)

updateShift = () ->
  
  $("#shift").html(shift)
  
  encrypt()

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
)