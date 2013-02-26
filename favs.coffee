Songs = new Meteor.Collection(null)
Session.setDefault('username', false)
soundcloud_id = "dcfa20cb4e60440dbf3e8bb3c54b68a8"

class TrackParser
  constructor: (track_data) ->
    @track  = track_data
    @artist = @track.artist
    @title  = @track.title

  url: ->
    if @track.url.search("soundcloud") isnt -1
      soundcloudURL = @track.url + '?client_id=' + soundcloud_id
      @track.url = soundcloudURL
    else
      @track.url

  data: ->
    artist: @artist
    title:  @title
    url:    @url()

FetchUserTracks = ->
  Songs.remove({})
  username = Session.get('username')
  url = "http://ex.fm/api/v3/user/" + username + "/loved?" + "results=20"
  Meteor.http.get url, (error, results) ->
    tracks_data = JSON.parse(results.content)
    for track_data in tracks_data.songs
      parsed_track = new TrackParser(track_data)
      Songs.insert parsed_track.data()


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
    FetchUserTracks()
    Songs.find({})


if Meteor.isServer
  Meteor.startup ->
# code to run on server at startup


