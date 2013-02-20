Songs = new Meteor.Collection("songs")

if Meteor.isClient

  url = "http://ex.fm/api/v3/user/plapier/loved?"
  Meteor.http.get "http://ex.fm/api/v3/user/plapier/loved?", (error, results) ->
    track_data = JSON.parse(results.content)
    console.log(track_data)
    Songs.insert track_data

  # soundcloud_id = "dcfa20cb4e60440dbf3e8bb3c54b68a8"
  # Song = $.getJSON "http://ex.fm/api/v3/user/plapier/loved?&results=20", (data) ->
    # objects = data.songs[0]

  # AllSongs = JSON.parse(Song.responseText)

  # Songs.insert artist: objects.artist

  # Template.Songs = ->
    # artist: () -> 
    # title: () ->
      # objects.title

  # Template.Songs.title = ->

    # $.each data.songs, (key) ->
      # # check for soundcloud url and set client_ID
      # if @.url.search("soundcloud") isnt -1
        # soundcloudURL = @.url + '?client_id=' + soundcloud_id
        # @.url = soundcloudURL

  # Template.Songs.Track = ->
    # Songs.find(artist)

  Template.Songs.events "click input": ->
    # template data, if any, is available in 'this'
    console.log "You pressed the button"  if typeof console isnt "undefined"

if Meteor.isServer
  Meteor.startup ->
# code to run on server at startup


