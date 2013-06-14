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

  Template.Landing.events "click #submit": (event) ->
    $exfm_username = $('#exfm_username').val()
    $hypem_username = $('#hypem_username').val()
    $sc_username = $('#sc_username').val()
    UsernameSetter('exfm', $exfm_username)
    UsernameSetter('hypem', $hypem_username)
    UsernameSetter('sc', $sc_username)

  Template.RenderPlaylist.events "click li.track": (event) ->
    event.preventDefault()
    clickedElement = $(event.currentTarget)
    new PlaySong(clickedElement)

  Template.Header.exfm_username = ->
    username = Session.get('exfm_username')
    if username?
       username

  Template.Header.hypem_username = ->
    username = Session.get('hypem_username')
    if username?
      username

  Template.Header.sc_username = ->
    username = Session.get('sc_username')
    if username?
      username

  Template.Header.events
    "keyup input#exfm_username": (event) ->
      if event.keyCode is 13
        setUser('exfm')
    "blur input#exfm_username": (event) ->
      setUser('exfm')

  Template.Header.events
    "keyup input#hypem_username": (event) ->
      if event.keyCode is 13
        setUser('hypem')
    "blur input#hypem_username": (event) ->
      setUser('hypem')

  Template.Header.events
    "keyup input#sc_username": (event) ->
      if event.keyCode is 13
        setUser('sc')
    "blur input#sc_username": (event) ->
      setUser('sc')

  Template.Header.events "click #about-button": (event) ->
    $("#about").removeClass('hide').addClass('show')



  Template.Songs.Track = ->
    Songs.find({}, {sort: {date_loved: -1}})

  Template.RenderPlaylist.empty_database = ->
    if Session.equals('exfm_status', 'Fetching...') \
    or Session.equals('hypem_status', 'Fetching...') \
    or Session.equals('sc_status', 'Fetching...')
      true

  Template.Spinner.rendered = ->
    showSpinner()

# ---- Helper Functions ----
@setUser = (user) ->
  username = $("##{user}_username").val()
  UsernameSetter("#{user}", username)
