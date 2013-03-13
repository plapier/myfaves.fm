
class MatchSong
  constructor: (song) ->
    @artist = type: "artist", string: song.artist
    @title  = type: "title", string: song.title
    @date_loved = song.dateloved
    # console.log @date_loved
    @searchTitles()

  searchTitles: () ->
    # Search Titles -> match artists
    # console.log "Searching for #{@title.type}:", @title.string
    search = @title
    @getJSON(search)

  searchArtists: () ->
    # Search by artist -> match resulting titles
    unless @searched_artist is true
      @searched_artist = true
      # console.log "Searching for #{@title.type}:", @title.string
      search = @artist
      @getJSON(search)

  getJSON: (search) ->
    type = search.type
    query = search.string
    exfm_url = encodeURI("http://ex.fm/api/v3/song/search/#{query}?results=20")
    $.getJSON exfm_url, (data) =>
      # console.log data
      @compareData(type, query, data)

  compareData: (type, query, data) ->
    if data.results > 0
      for track in data.songs
        hypem = @hypemMatchParser(type)
        exfm  = @exfmMatchParser(type, track)

        if _.isEqual(hypem, exfm)
          # console.log "Found match:", exfm, track
          @track = track
          @insertTrack(track)
          found_match = true
          break

      if found_match is true
        # console.log "Done! :)"
      else
        # console.log "No Artist Match found :("
        @searchArtists()
    else
      # console.log "0 Results"
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
    parsed_track = new ExfmTrackParser(track)
    Songs.insert parsed_track.data()


GetHypemData = () ->
  # hurl = "http://hypem.com/playlist/loved/phillapier/json/1/data.js"
  # $.getJSON hurl, (data) ->
    # song = data[2]
    # matchSong(song)
  # song = hypem_faves[2]
  # new MatchSong(song)
  console.log hypem_faves
  for own key, each_song of hypem_faves
    unless key is "version"
      new MatchSong(each_song)

