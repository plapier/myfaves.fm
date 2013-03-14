Songs = new Meteor.Collection(null)
Session.setDefault('exfm_username', false)

###### CLIENT #######
if Meteor.isClient
  Template.RenderTemplate.has_username = ->
    GetExfmUsername()

  Template.Username.events "keyup input#username-input": (event) ->
    if event.keyCode is 13
      $inputElement = $('#username-input')
      SetExfmUsername($inputElement.val())
      $inputElement.parent().hide()

  Template.RenderPlaylist.events "click li.track": (event) ->
    event.preventDefault()
    clickedElement = $(event.currentTarget)
    new PlaySong(clickedElement)

  Template.Header.current_username = ->
    Session.get('exfm_username')

  Template.Header.events "keyup header input": (event) ->
    if event.keyCode is 13
      exfm_username = $('header input').val()
      SetExfmUsername(exfm_username)
      ResetSessionVars()
      Songs.remove({})

  Template.Songs.Track = ->
    new FetchExfmJSON()
    GetHypemData()
    Songs.find({}, {sort: {date_loved: -1}})

# ---- Helper Functions ----

###### SERVER #######
if Meteor.isServer
  Meteor.startup ->
# code to run on server at startup
