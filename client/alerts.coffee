class ShowAlert
  constructor: (track) ->
    @alert(track)

  alert: (track) ->
    audio = $(track).find('audio').get(0)
    if audio.paused
      @insertAlert("play")
    else
      @insertAlert("pause")

  insertAlert: (type) ->
    $('body').append( @alertHtml(type) )
    $(".alert.#{type}").on "animationend webkitAnimationEnd", ->
      @.remove()

  alertHtml: (type) ->
    alert = """
            <div class='alert #{type}'>
              <div class='icon'></div>
            </div>
            """
