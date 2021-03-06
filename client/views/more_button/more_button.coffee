Template.MoreButton.events "click": (event) ->
  $clickedElement = $(event.currentTarget)
  $clickedElement.find('.text').addClass('hide')
  showButtonSpinner()
  FetchMoreExfm()
  FetchMoreHypem()
  FetchMoreSc()

@showButtonSpinner = ->
  opts =
    lines: 16 # The number of lines to draw
    length: 0 # The length of each line
    width: 3 # The line thickness
    radius: 16 # The radius of the inner circle
    corners: 1 # Corner roundness (0..1)
    rotate: 0 # The rotation offset
    direction: 1 # 1: clockwise, -1: counterclockwise
    color: "#fff" # #rgb or #rrggbb
    speed: 1.1 # Rounds per second
    trail: 62 # Afterglow percentage
    shadow: false # Whether to render a shadow
    hwaccel: false # Whether to use hardware acceleration
    className: "spinner" # The CSS class to assign to the spinner
    zIndex: 10 # The z-index (defaults to 2000000000)
    top: "auto" # Top position relative to parent in px
    left: "auto" # Left position relative to parent in px

  target = document.getElementById("more-button")
  spinner = new Spinner(opts).spin(target)
