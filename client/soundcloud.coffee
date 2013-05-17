Session.setDefault('sc_username', null)
Session.set('sc_tracks', [])
Session.set('sc_status', null)

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
      split   = @title.split(' - ')
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

class @ScJSONFetcher
  constructor: ->
    @username = Session.get('sc_username')
    @getResults()

  getResults: ->
    url = "http://api.soundcloud.com/users/#{@username}/favorites.json?client_id=#{soundcloud_id}"
    Meteor.http.get url, (error, results) =>
      json_data = JSON.parse(results.content)
      @insertNewTracks(json_data)

  insertNewTracks: (tracks_data) ->
    tracks = []
    for track in tracks_data
      parsed_track = new ScTrackParser("soundcloud", track)
      tracks.push(parsed_track.data())
    Session.set('sc_tracks', tracks)
    Session.set('sc_status', 'ready')
