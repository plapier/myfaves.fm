Session.setDefault('sc_username', 'phil-lapier')

class @ScTrackParser
  constructor: (source, track_data) ->
    @source = source
    @track  = track_data
    @date_loved = moment.utc(@track.created_at).format()
    @artist = @track.user.username
    @title  = @track.title
    @splitTitle()

  splitTitle: ->
    if @title.search(' - ') isnt -1
      split = @title.split(' - ')
      @artist = split[0]
      @title  = split[1]

  url: ->
    @track.stream_url + '?client_id=' + soundcloud_id

  data: ->
    source: @source
    artist: @artist
    title:  @title
    url:    @url()
    date_loved: @date_loved

class ScJSONFetcher
  constructor: ->
    @username = Session.get('sc_username')
    @getResults()

  getResults: ->
    url = "http://api.soundcloud.com/users/#{@username}/favorites.json?client_id=#{soundcloud_id}"
    Meteor.http.get url, (error, results) =>
      json_data = JSON.parse(results.content)
      @insertNewTracks(json_data)

  insertNewTracks: (tracks_data) ->
    # Session.set('exfm_results_total', json_data.total)
    for track_data in tracks_data
      # console.log track_data
      parsed_track = new ScTrackParser("soundcloud", track_data)
      # console.log parsed_track.data()
      Songs.insert parsed_track.data()

# @GetExfmUsername = ->
  # username = $.totalStorage('exfm_username')
  # if username
    # Session.set('exfm_username', username)
  # Session.get('exfm_username')

# @SetExfmUsername = (username) ->
  # $.totalStorage('exfm_username', username)
  # Session.set('exfm_username', username)

# @ResetSessionVars = ->
  # Session.set('exfm_start', 0)
  # Session.set('exfm_results', 21)
  # Session.set('exfm_results_total', null)

# fetch new user tracks when username is changed
FetchScUserTracks = ->
  Deps.autorun ->
    username = Session.get("sc_username")
    if username
      new ScJSONFetcher()
FetchScUserTracks()

# # Fetch more user tracks (!defualt 20)
# FetchMore = ->
  # num_start     = Session.get('exfm_start')
  # num_results   = Session.get('exfm_results')
  # total_results = Session.get("exfm_results_total")
  # if num_start <= total_results
    # Session.set('exfm_start', num_start + num_results)

