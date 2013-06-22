Template.Songs.Track = ->
  Songs.find({}, {sort: {collection: 1, date_loved: -1}})

# Template.Songs.created = ->
  # console.log "created"

# Template.Songs.rendered = ->
  # console.log "rendered"

# Template.Songs.destroyed = ->
  # console.log "destroyed"
