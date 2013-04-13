soundcloud_id = "dcfa20cb4e60440dbf3e8bb3c54b68a8"
Session.setDefault('exfm_username', false)
Session.setDefault('exfm_start', 0)
Session.setDefault('exfm_results', 21)
Session.set('exfm_results_total', null)

class @ExfmTrackParser
  constructor: (source, track_data, date_loved) ->
    @source = source
    @track  = track_data
    @artist = @track.artist
    @title  = @track.title
    @setDate(date_loved)

  setDate: (date_loved) ->
    if date_loved
      @date_loved = date_loved
    else
      @date_loved = moment.utc(@track.user_love.created_on).format()

  url: ->
    if @track.url.search("soundcloud") isnt -1
      soundcloudURL = @track.url + '?client_id=' + soundcloud_id
      @track.url = soundcloudURL
    else
      @track.url

  data: ->
    source: @source
    artist: @artist
    title:  @title
    url:    @url()
    date_loved: @date_loved

class ExfmJSONFetcher
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
      parsed_track = new ExfmTrackParser("exfm", track_data)
      Songs.insert parsed_track.data()

@GetExfmUsername = ->
  username = $.totalStorage('exfm_username')
  if username
    Session.set('exfm_username', username)
  Session.get('exfm_username')

@SetExfmUsername = (username) ->
  $.totalStorage('exfm_username', username)
  Session.set('exfm_username', username)

@ResetSessionVars = ->
  Session.set('exfm_start', 0)
  Session.set('exfm_results', 21)
  Session.set('exfm_results_total', null)

# fetch new user tracks when username is changed
FetchExfmUserTracks = ->
  Deps.autorun ->
    Session.set('exfm_results_total', null)
    username = Session.get("exfm_username")
    if username
      new ExfmJSONFetcher()
FetchExfmUserTracks()

# Fetch more user tracks (!defualt 20)
FetchMore = ->
  num_start     = Session.get('exfm_start')
  num_results   = Session.get('exfm_results')
  total_results = Session.get("exfm_results_total")
  if num_start <= total_results
    Session.set('exfm_start', num_start + num_results)
