$(window).keydown (event) ->
  keyCode = event.keyCode or event.which
  arrow =
    left: 37
    right: 39
  space = 32

  track = $('li.playing')

  switch keyCode
    when arrow.left
      unless track.prev().length is 0
        new PlaySong(track.prev())

    when arrow.right
      if track.length is 0
        track = $('li:first-child')
        new PlaySong(track)
      else if track.next().length is 1
        new PlaySong(track.next())

    when space
      event.preventDefault()
      unless track.length is 0
        new PlaySong(track)
