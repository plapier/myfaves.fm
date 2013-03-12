# $("#api").bind "ready.rdio", ->
  # $(this).rdio().play "a171827"
  #
GetHypemData = () ->
  # hurl = "http://hypem.com/playlist/loved/phillapier/json/1/data.js"
  # $.getJSON hurl, (data) ->
    # song = data[2]
    # matchSong(song)
  matchSong = (song) ->
    artist = song.artist
    title = song.title
    # console.log artist, title
    # console.log song
    # d = matchTitle(artist, title)
    matchArtist(artist, title)
     # matchTitle(artist, title)

  matchArtist = (artist, title) ->
    console.log "Trying to match artist:", artist
    exfm = encodeURI("http://ex.fm/api/v3/song/search/#{title}?results=30")
    $.getJSON exfm, (data) ->
      console.log data
      if data.results > 0
        for track in data.songs
          console.log track.artist
          if _.isEqual(artist, track.artist)
            console.log "Artist Match found!", track.artist
            console.log track
            c = true
            break
          else
            false
        if c is true
          console.log "Done! :)"
        else
          console.log "No Artist Match found :("
          matchTitle(artist, title)
      else
        console.log "0 Results"
        matchTitle(artist, title)

  matchTitle = (artist, title) ->
    console.log "Trying to match title", title
    exfm = encodeURI("http://ex.fm/api/v3/song/search/#{artist}?results=20")
    $.getJSON exfm, (data) ->
      console.log data
      for track in data.songs
        # console.log track.title
        if _.isEqual(title, track.title)
          console.log "Title Match found!", track.title
          console.log track
          return true

  song = hypem_favs[10]
  matchSong(song)

GetHypemData()
