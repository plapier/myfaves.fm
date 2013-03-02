$(window).keydown (event) ->
  keyCode = event.keyCode or event.which
  arrow =
    left: 37
    right: 39
  space = 32

  switch keyCode
    when arrow.left then playPrev()
    when arrow.right then playNext()
    when space
      event.preventDefault()
      playOrPause()
      # new playSong.playOrPause()
