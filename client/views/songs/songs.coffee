Template.Songs.Track = ->
  Songs.find({}, {sort: {collection: 1, date_loved: -1}})

# Template.Songs.Track = ->
  # console.log "Rendered"
  # $item = $(@.find(".track"))
  # Meteor.defer ->
    # $item.addClass "loaded"


# Template.Songs.rendered = ->
  # tracks = this.findAll '.track'
  # delay = 0
  # for track in tracks
    # delay_str = (delay * 0.0001)
    # console.log delay_str
    # # $(track).css('animation-delay', "#{delay_str}s").addClass('show animate')
    # delay = 500 + delay


Template.TrackItem.rendered = ->
  track = this.find '.track'
  $(track).addClass 'show animate'

  # code to execute after animation ends
  # delay = 500

  $(track).one "webkitAnimationEnd oanimationend msAnimationEnd animationend", (e) ->
    # $(track).addClass('show')
    # $(track).addClass('show').removeClass('animate')


# Template.Songs.created = ->
  # console.log "created"

# Template.Songs.destroyed = ->
  # console.log "destroyed"
