# Initialize Variables

shift = 0

# Define function for updating the data when the message changes
updateData = () -> 
  
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