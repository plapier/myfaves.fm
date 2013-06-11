Template.AboutModal.events 
  "click #about": (event) ->
    $("#about").hide()

  "click .inner-wrapper": (event) ->
    event.stopPropagation()
