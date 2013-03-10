soundcloud_id = "dcfa20cb4e60440dbf3e8bb3c54b68a8"
Session.setDefault('exfm_start', 0)
Session.setDefault('exfm_results', 21)
Session.set('exfm_results_total', null)

class ExfmTrackParser
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

class FetchExfmJSON
  constructor: ->
    @username = Session.get('exfm_username')
    @num_start = Session.get('exfm_start')
    @num_results = Session.get('exfm_results')
    @getResults()

  getResults: ->
    url = "http://ex.fm/api/v3/user/#{@username}/loved?start=#{@num_start}&results=#{@num_results}"
    Meteor.http.get url, (error, results) =>
      json_data = JSON.parse(results.content)
      @insertNewTracks(json_data)

  insertNewTracks: (json_data) ->
    tracks_data = json_data.songs
    Session.set('exfm_results_total', json_data.total)
    for track_data in tracks_data
      parsed_track = new ExfmTrackParser(track_data)
      Songs.insert parsed_track.data()

GetExfmUsername = ->
  username = $.totalStorage('exfm_username')
  if username
    Session.set('exfm_username', username)
  Session.get('exfm_username')

SetExfmUsername = (username) ->
  $.totalStorage('exfm_username', username)
  Session.set('exfm_username', username)

# fetch new user tracks when username is changed
FetchUserTracks = ->
  update = ->
    ctx = new Meteor.deps.Context() # invalidation context
    ctx.onInvalidate update # rerun update() on invalidation
    ctx.run ->
      Session.set('exfm_results_total', null)
      username = Session.get("exfm_username")
      if username
        new FetchExfmJSON()
  update()
FetchUserTracks()

# Fetch more user tracks (!defualt 20)
FetchMore = ->
  num_start     = Session.get('exfm_start')
  num_results   = Session.get('exfm_results')
  total_results = Session.get("exfm_results_total")
  if num_start <= total_results
    Session.set('exfm_start', num_start + num_results)
