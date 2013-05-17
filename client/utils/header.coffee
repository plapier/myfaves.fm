$(window).ready ->
  setTimeout(fn, 1400)

fn = ->
  console.log "run"
  $('li.track').each ->
    console.log "done"
    $(@).addClass('show-track')

#your function
