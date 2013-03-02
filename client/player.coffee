@endSong = () ->
  $currentSong = $('.playing-track audio').get(0)
  endTime = $currentSong.duration - 10
  $currentSong.currentTime = endTime

@playNext = () ->
  currentTrack = $("#tracks").find(".playing-track")
  if ($(currentTrack).length is 0) or ($(currentTrack).next().length is 0)
    nextTrack = $('li:first-child')
    new PlaySong(nextTrack)
  else if $(currentTrack).length isnt 0
    nextTrack = $(currentTrack).next()
    new PlaySong(nextTrack)

@playPrev = (currentTrack) ->
  currentTrack = $("#tracks").find(".playing-track")
  unless $(currentTrack).prev().length is 0
    prevTrack = $(currentTrack).prev()
    new PlaySong(prevTrack)

@playOrPause = (audio) ->
  currentTrack = $("#tracks").find(".playing-track")
  unless audio
    audio = currentTrack.find("audio").get(0)
  if audio.paused
    currentTrack.removeClass("paused").addClass("playing")
    audio.play()
  else
    currentTrack.removeClass("playing").addClass("paused")
    audio.pause()

$(document).ready ->


class PlaySong
  @clickedTrack
  @audio
  @bufferNext

  constructor: (currentTrack) ->
    @setVars(currentTrack)
    @checkForErrors(@audio)
    @playTrack(@clickedTrack, @audio)
    playOrPause(@audio)
    @showCurrentBuffer(@clickedTrack, @audio)
    @showTrackProgress(@clickedTrack, @audio, @bufferNext)
    @pauseAllOtherTracks()
    @bufferNextTrack(@clickedTrack, @audio, @bufferNext)

  setVars: (track) ->
    @clickedTrack = $(track)
    @audio = @clickedTrack.find("audio").get(0)
    SC.initialize
      client_id: "dcfa20cb4e60440dbf3e8bb3c54b68a8"

  checkForErrors: (audio) ->
    url = audio.currentSrc

    if url.search("soundcloud") isnt -1
      urlArray = url.split("/")
      trackId = urlArray[4]
      url = "/tracks/#{trackId}"

      SC.get url, (track, error) ->
        console.log track
        if error
          console.log "soundcloud error"

    # audio.addEventListener "error", (->
      # console.log true
    # ), false

    # $(audio).on "loadstart", ->
      # console.log("loading")

    # m = "loadstart"
    # audio.addEventListener m, ((event) ->
      # console.log("#{m}. Skip Song")
    # ), false
    # m = "abort"
    # audio.addEventListener m, ((event) ->
      # console.log("#{m}. Skip Song")
    # ), false
    # m = "error"
    # audio.addEventListener m, ((event) ->
      # console.log("#{m}. Skip Song")
    # ), false

  playTrack: (track, audio) ->
    @bufferNext = false if typeof @bufferNext?

    # remove class from all currently playing tracks
    $('.playing-track').removeClass("playing-track").addClass("not-playing")

    # add playing-track to clicked track
    track.removeClass("not-playing").addClass("playing-track")

    $(audio).on("play", ->
      $(@).addClass "playing"
      $(track).removeClass "paused"
    ).on("pause", ->
      $(@).removeClass "playing"
      $(track).addClass "paused"
    ).on "ended", ->
      $(@).removeClass "playing"
      $("track").addClass("not-playing")
      @bufferNext = null
      playNext()

  pauseAllOtherTracks: () ->
    $('.not-playing audio').each ->
      @.pause()
      @.currentTime = 0 if @.currentTime > 0

  # Show loading Indicator
  showBuffer: (track, audio) ->
    loadingIndicator  = track.find('.buffer')
    if (audio.buffered isnt 'undefined')
      $(audio).on "progress", ->
        ## check if audio has started buffered
        if audio.buffered.length is 1
          loaded = parseInt(((audio.buffered.end(0) / audio.duration) * 100), 10)
          loadingIndicator.css width: loaded + "%"

  showCurrentBuffer: (track, audio) ->
    @showBuffer(track, audio)

  showTrackProgress: (track, audio, bufferNext) ->
    progressIndicator = track.find('.progress')
    $(audio).bind "timeupdate", bufferNext, ->
      progress = (audio.currentTime / audio.duration) * 100
      progressIndicator.css width: progress + "%"

  bufferNextTrack: (track, audio, bufferNext) ->
    $nextTrack = track.next()
    checkProgress = setInterval ( ->
      progress = (audio.currentTime / audio.duration) * 100
      if bufferNext? and progress > 75             #if track is 75% complete
        bufferNext = true
        $nextTrack.find('audio').attr('preload', 'metadata')
        clearInterval(checkProgress)
    ), 1000
    nextAudio = $nextTrack.find('audio').get(0)
    @showBuffer($nextTrack, nextAudio)
