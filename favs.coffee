Songs = new Meteor.Collection(null)
Session.setDefault('username', false)



###### CLIENT #######
if Meteor.isClient
  Template.RenderTemplate.has_username = ->
    Session.get('username')

  Template.Username.events "keyup input#username-input": (event) ->
    if event.keyCode is 13
      $inputElement = $('#username-input')
      username = $inputElement.val()
      Session.set('username',  username)
      $inputElement.parent().hide()

  Template.Songs.Track = ->
    FetchExfmData()
    Songs.find({})

  Template.Header.current_username = ->
    Session.get('username')

  Template.Header.events "keyup header input": (event) ->
    if event.keyCode is 13
      $inputElement = $('header input')
      username = $inputElement.val()
      Session.set('username',  username)

  Template.RenderPlaylist.events "click li.track": (event) ->
    event.preventDefault()
    clickedElement = $(event.currentTarget)
    new PlaySong(clickedElement)


###### SERVER #######
if Meteor.isServer
  Meteor.startup ->
# code to run on server at startup
