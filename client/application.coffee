@Songs = new Meteor.Collection(null)

GetUsernames = ->
  GetExfmUsername()
  GetHypemUsername()
  GetScUsername()
  if GetExfmUsername() or GetHypemUsername() or GetScUsername()
    true


###### CLIENT #######
if Meteor.isClient
  Template.RenderTemplate.has_username = ->
    GetUsernames()

  Template.Username.events "keyup input#username-input": (event) ->
    if event.keyCode is 13
      $inputElement = $('#username-input')
      SetExfmUsername($inputElement.val())
      $inputElement.parent().hide()

  Template.RenderPlaylist.events "click li.track": (event) ->
    event.preventDefault()
    clickedElement = $(event.currentTarget)
    new PlaySong(clickedElement)

  Template.Header.exfm_username = ->
    username = Session.get('exfm_username')
    unless username is false
      username

  Template.Header.hypem_username = ->
    username = Session.get('hypem_username')
    unless username is false
      username

  Template.Header.sc_username = ->
    username = Session.get('sc_username')
    unless username is false
      username

  Template.Header.events "keyup header input#exfm_username": (event) ->
    if event.keyCode is 13
      exfm_username = $('#exfm_username').val()
      SetExfmUsername(exfm_username)
      ResetSessionVars()
      Songs.remove({source: "exfm"})

  Template.Header.events "keyup header input#hypem_username": (event) ->
    if event.keyCode is 13
      hypem_username = $('#hypem_username').val()
      SetHypemUsername(hypem_username)
      Songs.remove({source: "hypem"})

  Template.Header.events "keyup header input#soundcloud_username": (event) ->
    if event.keyCode is 13
      sc_username = $('#soundcloud_username').val()
      SetScUsername(sc_username)
      Songs.remove({source: "soundcloud"})

  Template.Songs.Track = ->
    Songs.find({}, {sort: {date_loved: -1}})

# ---- Helper Functions ----

###### SERVER #######
if Meteor.isServer
  Meteor.startup ->
# code to run on server at startup
