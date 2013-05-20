Session.getNonReactive = (key) ->
  Deps.nonreactive ->
    Session.get key
