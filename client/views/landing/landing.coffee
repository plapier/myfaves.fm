Template.Landing.events "click #submit": (event) ->
  $exfm_username = $('#exfm_username').val()
  $hypem_username = $('#hypem_username').val()
  $sc_username = $('#sc_username').val()
  UsernameSetter('exfm', $exfm_username)
  UsernameSetter('hypem', $hypem_username)
  UsernameSetter('sc', $sc_username)

Template.Landing.events "click #demo": (event) ->
  UsernameSetter('exfm', 'plapier')
  UsernameSetter('hypem', 'phillapier')


