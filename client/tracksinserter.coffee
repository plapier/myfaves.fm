TracksInserter = ->
  Deps.autorun ->

    exfm_tracks  = Session.get('exfm_tracks')
    hypem_tracks = Session.get('hypem_tracks')
    sc_tracks    = Session.get('sc_tracks')

    # -- DEBUG
    # exfm_status  = Session.get('exfm_status')
    # hypem_status = Session.get('hypem_status')
    # sc_status    = Session.get('sc_status')
    # console.log "Exfm: #{exfm_status}, Hypem: #{hypem_status}, Sc: #{sc_status}"
    # unless exfm_status is "Fetching..." or hypem_status is "Fetching..." or sc_status is "Fetching..."

    unless Session.equals('exfm_status', 'Fetching...') or Session.equals('hypem_status', 'Fetching...') or Session.equals('sc_status', 'Fetching...')
      all_tracks = []

      if exfm_tracks?
        for key in exfm_tracks
          all_tracks.push(key)

      if hypem_tracks?
        for key in hypem_tracks
          all_tracks.push(key)

      if sc_tracks?
        for key in sc_tracks
          all_tracks.push(key)

      for key in all_tracks
        Songs.insert key

      # console.log "Super Success!!"

TracksInserter()
