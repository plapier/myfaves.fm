Future = Npm.require("fibers/future")

if Meteor.isServer
  Meteor.startup ->
    # we want to be able to inspect the root_url, so we know which environment were in
    # console.log JSON.stringify(process.env.ROOT_URL)

    # in case we want to inspect other process environment variables
    # console.log JSON.stringify(process.env)

  Meteor.methods getEnvironment: ->
    if process.env.ROOT_URL is "http://localhost:3000"
      "development"
      # "production"
    else if process.env.ROOT_URL is "http://beta.myfaves.fm"
      "staging"
    else if process.env.ROOT_URL is "http://myfaves.fm"
      "production"

  Meteor.methods parallelAsyncJob: (username) ->
    url = "http://hypem.com/playlist/loved/#{username}/json/1/data.js"

    future = new Future()
    onComplete = future.resolver()

    # Make async http call
    Meteor.http.get url, (error, result) ->
      if result.statusCode is 200
        result:
          statusCode: result.statusCode
          data: result.data
      onComplete error, result
    future.wait()
