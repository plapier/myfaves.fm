Session.setDefault('hypem_username', null)
Session.setDefault('hypem_page', 1)
Session.set('hypem_tracks', [])
Session.set('hypem_status', null)

class @HypemJSONFetcher
  constructor: ->
    @username = Session.get('hypem_username')
    @page     = Session.get('hypem_page')
    @getResults()
    # @debug()

  getResults: ->
    url = "http://hypem.com/playlist/loved/#{@username}/json/#{@page}/data.js"
    Meteor.http.get url, (error, results) =>
      if error
        $('#hypem_username').addClass('error')

      else if results.statusCode is 200
        @parseResults(results.data)

      else
        console.log "Something went wrong with HypeMachine"

  parseResults: (songs) ->
    if _.size(songs) <= 1
      flash.info 'hypem', "Hypem: #{@username} has 0 favorite tracks"

    # Use Promisses to wait for all asynchonous tasks to be finsihed
    promises = []
    for own key, song of songs
      unless key is "version"
        promise = new RSVP.Promise((resolve, reject) ->
          new SongMatcher(song, resolve, reject)
        )
        promises.push(promise)

    RSVP.all(promises).then ((values) ->
      tracks = []
      for key in values
        if key isnt "No Match Found"
          tracks.push(key)

      # Push all returned data to Session
      Session.set('hypem_tracks', tracks)
      Session.set('hypem_status', 'ready')
    )

  debug: ->
    console.log "running hypem debug"
    songs = [hypem_faves[2], hypem_faves[3], hypem_faves[5]]
    song  = hypem_faves[2]
    @parseResults(songs)

class SongMatcher
  constructor: (song, resolve, reject) ->
    @resolve    = resolve
    @reject     = reject
    @source     = 'hypem'
    @artist     = type: 'artist', string: song.artist
    @title      = type: 'title', string: song.title
    date        = moment.unix(song.dateloved)
    @date_loved = moment.utc(date).format()
    @searchTitles()

  searchTitles: () ->
    # Search Titles -> match artists
    search = @title
    @getJSON(search)

  getJSON: (search) ->
    type = search.type
    query = search.string
    query = query.replace(/\//g, '') # remove all forwardslash
    url = encodeURI "http://ex.fm/api/v3/song/search/#{query}?results=20"
    Meteor.http.get url, (error, results) =>
      @compareData(type, query, results.data)


  compareData: (type, query, results) ->
    if results.results > 0
      for track in results.songs
        hypem = @hypemMatchParser(type)
        exfm  = @exfmMatchParser(type, track)

        if _.isEqual(hypem, exfm)
          @track = track
          @parseTrack(track)
          found_match = true
          break

      unless found_match is true
        # No Artist Match found :( Try Searching for Artist
        @searchArtists()
    else
      # 0 Results from Exfm :( Try Searching for Artist
      @searchArtists()

  searchArtists: () ->
    # Search by artist -> match resulting titles
    if @searched_artist isnt true
      @searched_artist = true
      search = @artist
      @getJSON(search)
    else
      @resolve("No Match Found")

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

  parseTrack: (track) ->
    hypem_date_loved = @date_loved
    parsed_track = new ExfmTrackParser(@source, track, hypem_date_loved)
    @resolve(parsed_track.data())
