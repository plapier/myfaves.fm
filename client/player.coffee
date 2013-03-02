@endSong = () ->
  $currentSong = $('.playing audio').get(0)
  endTime = $currentSong.duration - 10
  $currentSong.currentTime = endTime

@playNext = () ->
  currentTrack = $("#tracks").find(".playing")
  if ($(currentTrack).length is 0) or ($(currentTrack).next().length is 0)
    nextTrack = $('li:first-child')
    new PlaySong(nextTrack)
  else if $(currentTrack).length isnt 0
    nextTrack = $(currentTrack).next()
    new PlaySong(nextTrack)

@playPrev = (currentTrack) ->
  currentTrack = $("#tracks").find(".playing")
  unless $(currentTrack).prev().length is 0
    prevTrack = $(currentTrack).prev()
    new PlaySong(prevTrack)

@playOrPause = (audio) ->
  currentTrack = $("#tracks").find(".playing")
  unless audio
    audio = currentTrack.find("audio").get(0)
  if audio.paused
    currentTrack.removeClass("paused")
    audio.play()
  else
    currentTrack.addClass("paused")
    audio.pause()


class PlaySong
  @clickedTrack
  @audio
  @bufferNext

  constructor: (currentTrack) ->
    @setVars(currentTrack)
    @checkForErrors(@clickedTrack, @audio)
    @playTrack(@clickedTrack, @audio)
    playOrPause(@audio)
    @showCurrentBuffer(@clickedTrack, @audio)
    @showTrackProgress(@clickedTrack, @audio, @bufferNext)
    @pauseAllOtherTracks()
    @scrollInView(@clickedTrack)
    @bufferNextTrack(@clickedTrack, @audio, @bufferNext)

  setVars: (track) ->
    @clickedTrack = $(track)
    @audio = @clickedTrack.find("audio").get(0)

  checkForErrors: (track, audio) ->
    audio.addEventListener "error", ((event) ->
      trackName = track.find('.title').text()
      console.log "Error: #{trackName}"
      track.addClass("error")
      playNext()
    ), true ## !useCapture must be set to true!

  playTrack: (track, audio) ->
    @bufferNext = false if typeof @bufferNext?

    # remove class from all currently playing tracks
    $('.playing').removeClass("playing").addClass("not-playing")

    # add playing to clicked track
    track.removeClass("not-playing").addClass("playing")

    $(audio).on("play", ->
      $(track).removeClass "paused"
    ).on("pause", ->
      $(track).addClass "paused"
    ).on "ended", ->
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

  scrollInView: (track) ->
    track.scrollIntoView()
