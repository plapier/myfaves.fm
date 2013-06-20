# fetch new user tracks when username is changed
FetchUserTracks = (source) ->
  Deps.autorun ->
    Session.set('exfm_results_total', null) if source is 'exfm'

    username = Session.get("#{source}_username")
    if username?
      Session.set("#{source}_status", 'Fetching...')
      console.log "status: fetching"
      switch source
        when 'exfm' then new ExfmJSONFetcher()
        when 'hypem' then new HypemJSONFetcher()
        when 'sc'    then new ScJSONFetcher()

FetchUserTracks('exfm')
FetchUserTracks('hypem')
FetchUserTracks('sc')


@UsernameGetter = (source) ->
  username = $.totalStorage("#{source}_username")
  Session.set("#{source}_username", username)
  Session.get("#{source}_username")

@UsernameSetter = (source, username) ->
  username = null if username.length is 0
  unless Session.equals("#{source}_username", username)
    flash.clear source
    if not username?
      SetUsername(source, null)
      Songs.remove({})
    else if username.length > 0
      SetUsername(source, username)
      Songs.remove({})
    # else
      # Songs.remove({source: source})
    if source is 'exfm'
      ResetSessionVars()

@SetUsername = (source, username) ->
  $.totalStorage("#{source}_username", username)
  Session.set("#{source}_username", username)
  Session.set("#{source}_collection", 1) # reset collection num
  unless username?
    Session.set("#{source}_tracks", null)
    Session.set("#{source}_status", null)
