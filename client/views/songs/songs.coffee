Template.Songs.Track = ->
  Songs.find({}, {sort: {collection: 1, date_loved: -1}})

Template.Songs.rendered = ->
  tracks = this.findAll '.loading'
  delay = 0
  for track in tracks
    delay_str = "#{delay * 0.0001}s"
    $(track).css('-webkit-animation', "show-track 0.5s ease-in #{delay_str} forwards")
    delay = 500 + delay

Template.TrackItem.rendered = ->
  track = this.find '.loading'

  #code to execute after animation ends
  $(track).one "webkitAnimationEnd oanimationend msAnimationEnd animationend", (e) ->
    $(track).addClass('show').removeClass('loading')


# Template.Songs.created = ->
  # console.log "created"

# Template.Songs.destroyed = ->
  # console.log "destroyed"
