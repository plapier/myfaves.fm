# flashes provides an api for temporary flash messages stored in a
# client only collecion
@flash = @flash or {}
((argument) ->

  # Client only collection
  flash.Flashes = new Meteor.Collection(null)

  # create given a message and optional type creates a Flash message.
  flash.create = (source, message, type) ->
    type = (if (typeof type is "undefined") then "error" else type)

    # Store errors in the 'Errors' local collection
    flash.Flashes.insert
      message: message
      type: type
      show: true
      source: source
  # error is a helper function for creating error messages
  flash.error = (source, message) ->
    flash.create source, message, "error"
  # info is a helper function for creating info messages
  flash.info = (source, message) ->
    flash.create source, message, "info"
  # clear hides viewed message
  flash.clear = (source)->
    flash.Flashes.remove({source: source})
)()
