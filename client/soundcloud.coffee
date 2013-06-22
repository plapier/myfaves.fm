@soundcloud_id = "dcfa20cb4e60440dbf3e8bb3c54b68a8"
Session.setDefault('sc_username', null)
Session.set('sc_collection', 1)
Session.set('sc_tracks', [])
Session.set('sc_status', null)
Session.set('sc_offset', 0)
Session.set('sc_limit', 20)

class @ScTrackParser
  constructor: (source, track_data) ->
    @source = source
    @track  = track_data
    @date_loved = moment.utc(@track.created_at).format()
    @artist = @track.user.username
    @title  = @track.title
    @splitTitle()

  splitTitle: ->
    if @title.search(' - ') isnt -1
      split   = @title.split(' - ')
      @artist = split[0]
      @title  = split[1]

  url: ->
    @track.stream_url + '?client_id=' + soundcloud_id

  data: ->
    collection: Session.get("#{@source}_collection")
    source: @source
    artist: @artist
    title:  @title
    url:    @url()
    date_loved: @date_loved

class @ScJSONFetcher
  constructor: ->
    @username = Session.get('sc_username')
    @offset   = Session.get('sc_offset')
    @limit    = Session.getNonReactive('sc_limit')
    @getResults()

  getResults: ->
    url = "http://api.soundcloud.com/users/#{@username}/favorites.json?client_id=#{soundcloud_id}&limit=#{@limit}&offset=#{@offset}"
    Meteor.http.get url, (error, results) =>
      if error
        flash.error 'sc', "Soundcloud couldn't be reached. The service might be down."
        Session.set('sc_status', 'ready')

      else if results.statusCode is 200
        @insertNewTracks(results.data)

      else if results.statusCode is 404
        flash.error 'sc', "Soundcloud: User doesn't exist"
        $('#soundcloud_username').addClass('error')

  insertNewTracks: (tracks_data) ->
    if _.size(tracks_data) is 0
      flash.info 'sc', "Soundcloud: #{@username} has 0 favorite tracks"

    tracks = []
    for track in tracks_data
      parsed_track = new ScTrackParser("sc", track)
      tracks.push(parsed_track.data())
    Session.set('sc_tracks', tracks)
    Session.set('sc_status', 'ready')

@FetchMoreSc = ->
  if Session.getNonReactive('sc_username')
    collection = Session.getNonReactive('sc_collection')
    offset     = Session.getNonReactive('sc_offset')
    limit      = Session.getNonReactive('sc_limit')
    console.log offset
    console.log limit
    Session.set("sc_status", 'Fetching...')
    Session.set('sc_collection', collection + 1)
    Session.set('sc_offset', offset + limit)
