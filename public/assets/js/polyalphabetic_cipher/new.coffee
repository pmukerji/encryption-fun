# Initialize Variables

shift = "example"

numToLetter = (num) -> String.fromCharCode(97 + (num % 26))

letterToNum = (letter) -> letter.charCodeAt(0)-97

normalizeToLetter = (num) ->
  if num > 25
    num-26
  else if num < 0
    num+26
  else
    num

# Define function for updating the data when the message changes
updateData = () -> 
  
  decrypt()
  
decrypt = () ->
 

  message = $("#message").val()
  shift_key = $("#shift_key").val()
  message_length = message.length
  shift_length = shift_key.length
  
  decrypted_message = ""
  
  j = 0
  
  for i in [0..message_length-1]
    num_message_char = letterToNum(message.charAt(i))
    num_shift_key_char = letterToNum(shift_key.charAt(j))
    
    if num_message_char >= 0 && num_message_char < 26 && num_shift_key_char >= 0 && num_shift_key_char < 26
      decrypted_message+=(numToLetter(normalizeToLetter(num_message_char + num_shift_key_char)))
    else
      decrypted_message+=message.charAt(i)
    
    j = j+1
    if j >= shift_length
      j = 0
  
  
  $("#decrypted_message").html(decrypted_message)


$( document ).ready( () ->

  $("#message").keyup( () -> updateData())
  $("#shift_key").keyup( () -> updateData())
  
  updateData()
)