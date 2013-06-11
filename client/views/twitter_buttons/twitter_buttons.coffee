addTwitterWidget = ->
  not ((d, s, id) ->
    js = undefined
    fjs = d.getElementsByTagName(s)[0]
    unless d.getElementById(id)
      js = d.createElement(s)
      js.id = id
      js.src = "//platform.twitter.com/widgets.js"
      fjs.parentNode.insertBefore js, fjs
  ) document, "script", "twitter-wjs"

Template.Landing.rendered = ->
  addTwitterWidget()

Template.AboutModal.rendered = ->
  addTwitterWidget()
