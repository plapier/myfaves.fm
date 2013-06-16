Template.Songs.Track = ->
  Songs.find({}, {sort: {date_loved: -1}})
