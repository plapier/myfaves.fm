Session.setDefault('hypem_username', false)
Session.setDefault('hypem_page', 1)

class HypemJSONFetcher
  constructor: ->
    @username = Session.get('hypem_username')
    @page     = Session.get('hypem_page')
    @getResults()
    # @test()

  getResults: ->
    url = "http://hypem.com/playlist/loved/#{@username}/json/#{@page}/data.js"
    Meteor.http.get url, (error, results) =>
      json_data = JSON.parse(results.content)
      for own key, each_song of json_data
        unless key is "version"
          new SongMatcher(each_song)
  test: ->
    song = hypem_faves[2]
    console.log "running hypem"
    new SongMatcher(song)

class SongMatcher
  constructor: (song) ->
    @artist = type: "artist", string: song.artist
    @title  = type: "title", string: song.title
    date = moment.unix(song.dateloved)
    @date_loved = moment.utc(date).format()
    @searchTitles()

  searchTitles: () ->
    # Search Titles -> match artists
    search = @title
    @getJSON(search)

  searchArtists: () ->
    # Search by artist -> match resulting titles
    unless @searched_artist is true
      @searched_artist = true
      search = @artist
      @getJSON(search)

  getJSON: (search) ->
    type = search.type
    query = search.string
    exfm_url = encodeURI("http://ex.fm/api/v3/song/search/#{query}?results=20")
    $.getJSON exfm_url, (data) =>
      @compareData(type, query, data)

  compareData: (type, query, data) ->
    if data.results > 0
      for track in data.songs
        hypem = @hypemMatchParser(type)
        exfm  = @exfmMatchParser(type, track)

        if _.isEqual(hypem, exfm)
          @track = track
          @insertTrack(track)
          found_match = true
          break

      unless found_match is true
        # No Artist Match found :( Try Searching for Artist
        @searchArtists()
    else
      # 0 Results from Exfm :( Try Searching for Artist
      @searchArtists()

  exfmMatchParser: (type, track) ->
    if type is "artist"
      track.title
    else
      track.artist

  hypemMatchParser: (type, track) ->
    if type is "artist"
      @title.string
    else
      @artist.string

  insertTrack: (track) ->
    hypem_date_loved = @date_loved
    parsed_track = new ExfmTrackParser("hypem", track, hypem_date_loved)
    Songs.insert parsed_track.data()

GetHypemUsername = ->
  username = $.totalStorage('hypem_username')
  if username
    Session.set('hypem_username', username)
  Session.get('hypem_username')

SetHypemUsername = (username) ->
  $.totalStorage('hypem_username', username)
  Session.set('hypem_username', username)

# fetch new user tracks when username is changed
FetchHypemUserTracks = ->
  Deps.autorun ->
    username = Session.get("hypem_username")
    if username
      new HypemJSONFetcher()
FetchHypemUserTracks()
