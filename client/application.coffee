@Songs = new Meteor.Collection(null)

GetUsernames = ->
  UsernameGetter("exfm")
  UsernameGetter("hypem")
  UsernameGetter("sc")
  if UsernameGetter('exfm') or UsernameGetter('hypem') or UsernameGetter('sc')
    true

###### CLIENT #######
if Meteor.isClient
  Template.RenderTemplate.has_username = ->
    GetUsernames()

  Template.RenderPlaylist.events "click li.track": (event) ->
    event.preventDefault()
    clickedElement = $(event.currentTarget)
    new PlaySong(clickedElement)

  Template.RenderPlaylist.empty_database = ->
    if Session.equals('exfm_status', 'Fetching...') \
    or Session.equals('hypem_status', 'Fetching...') \
    or Session.equals('sc_status', 'Fetching...')
      true

# ---- Helper Functions ----
