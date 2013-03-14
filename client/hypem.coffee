
class MatchSong
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
    parsed_track = new ExfmTrackParser(track, hypem_date_loved)
    Songs.insert parsed_track.data()


GetHypemData = () ->
  hypem_url = "http://hypem.com/playlist/loved/phillapier/json/1/data.js"
  $.getJSON hypem_url, (data) ->
    for own key, each_song of data
      unless key is "version"
        new MatchSong(each_song)

