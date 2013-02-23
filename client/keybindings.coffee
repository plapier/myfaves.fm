$(document).keyup (event) ->
  keyCode = event.keyCode or event.which
  arrow =
    left: 37
    right: 39

  switch keyCode
    when arrow.left then playPrev()
    when arrow.right then playNext()
