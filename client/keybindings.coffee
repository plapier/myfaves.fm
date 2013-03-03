$(window).keydown (event) ->
  keyCode = event.keyCode or event.which
  arrow =
    left: 37
    right: 39
  space = 32

  track = $('li.playing')
  switch keyCode
    # when arrow.left then playPrev()
    when arrow.left then new PlaySong(track.prev())
    # when arrow.right then playNext()
    when arrow.right then new PlaySong(track.next())
    when space
      event.preventDefault()
      unless track?
        new PlaySong(track)
