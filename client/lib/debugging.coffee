@logRenders = ->
  _.each Template, (template, name) ->
    oldRender = template.rendered
    counter = 0
    template.rendered = ->
      console.log name, "render count: ", ++counter
      oldRender and oldRender.apply(this, arguments)

@logFind = ->
  wrappedFind = Meteor.Collection::find
  Meteor.Collection::find = ->
    cursor = wrappedFind.apply(this, arguments)
    collectionName = @_name
    cursor.observeChanges
      added: (id, fields) ->
        console.log collectionName, "added", id, fields

      changed: (id, fields) ->
        console.log collectionName, "changed", id, fields

      movedBefore: (id, before) ->
        console.log collectionName, "movedBefore", id, before

      removed: (id) ->
        console.log collectionName, "removed", id
    cursor

# logRenders()
# logFind()
