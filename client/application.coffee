@Songs = new Meteor.Collection(null)

GetUsernames = ->
  UsernameGetter("exfm")
  UsernameGetter("hypem")
  UsernameGetter("sc")
  if UsernameGetter('exfm') or UsernameGetter('hypem') or UsernameGetter('sc')
    true

###### CLIENT #######
if Meteor.isClient
  Template.RenderTemplate.has_username = ->
    GetUsernames()

  Template.Username.events "keyup input#username-input": (event) ->
    if event.keyCode is 13
      $inputElement = $('#username-input')
      SetUsername('exfm', $inputElement.val())
      $inputElement.parent().hide()

  Template.RenderPlaylist.events "click li.track": (event) ->
    event.preventDefault()
    clickedElement = $(event.currentTarget)
    new PlaySong(clickedElement)

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

  Template.Header.events "keyup header input#exfm_username": (event) ->
    if event.keyCode is 13
      username = $('#exfm_username').val()
      UsernameSetter('exfm', username)

  Template.Header.events "keyup header input#hypem_username": (event) ->
    if event.keyCode is 13
      username = $('#hypem_username').val()
      UsernameSetter('hypem', username)

  Template.Header.events "keyup header input#soundcloud_username": (event) ->
    if event.keyCode is 13
      username = $('#soundcloud_username').val()
      UsernameSetter('sc', username)

  Template.Songs.Track = ->
    Songs.find({}, {sort: {date_loved: -1}})


# ---- Helper Functions ----
