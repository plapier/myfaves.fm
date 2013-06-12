Template.AboutModal.events 
  "click #about": (event) ->
    $("#about").removeClass('show').addClass('hide')

  "click .inner-wrapper": (event) ->
    event.stopPropagation()
