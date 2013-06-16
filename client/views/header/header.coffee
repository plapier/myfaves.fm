@setUser = (user) ->
  username = $("##{user}_username").val()
  UsernameSetter("#{user}", username)

Template.Header.exfm_username = ->
  username = Session.get('exfm_username')
  if username?
     username

Template.Header.hypem_username = ->
  username = Session.get('hypem_username')
  if username?
    username

Template.Header.sc_username = ->
  username = Session.get('sc_username')
  if username?
    username

Template.Header.events
  "keyup input#exfm_username": (event) ->
    if event.keyCode is 13
      setUser('exfm')
  "blur input#exfm_username": (event) ->
    setUser('exfm')

Template.Header.events
  "keyup input#hypem_username": (event) ->
    if event.keyCode is 13
      setUser('hypem')
  "blur input#hypem_username": (event) ->
    setUser('hypem')

Template.Header.events
  "keyup input#sc_username": (event) ->
    if event.keyCode is 13
      setUser('sc')
  "blur input#sc_username": (event) ->
    setUser('sc')


### About Button ###
Template.Header.events "click #about-button": (event) ->
  $("#about").removeClass('hide').addClass('show')
