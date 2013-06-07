@endSong = () ->
  $currentSong = $('.playing audio').get(0)
  endTime = $currentSong.duration - 5
  $currentSong.currentTime = endTime

class @PlaySong
  @clickedTrack
  @audio
  @bufferNext

  constructor: (currentTrack) ->
    @setVars(currentTrack)
    @checkForErrors(@clickedTrack, @audio)
    @playTrack(@clickedTrack, @audio)
    @showCurrentBuffer(@clickedTrack, @audio)
    @showTrackProgress(@clickedTrack, @audio, @bufferNext)
    @pauseAllOtherTracks()
    @scrollInView(@clickedTrack)
    @bufferNextTrack(@clickedTrack, @audio, @bufferNext)
    @songEnd(@clickedTrack, @audio)

  setVars: (track) ->
    $('.playing').removeClass("playing").addClass("not-playing")
    track.removeClass("not-playing").addClass("playing")
    @clickedTrack = track
    @audio = @clickedTrack.find("audio").get(0)

  checkForErrors: (track, audio) ->
    audio.addEventListener "error", ((event) =>
      console.log @
      trackName = track.find('.title').text()
      console.log "Error: #{trackName}"
      track.addClass("error")
      new PlaySong(track.next())
    ), false ## useCapture must be set to true!

  playTrack: (track, audio) ->
    @bufferNext = false if typeof @bufferNext?

    if audio.paused
      audio.play()
    else
      audio.pause()

    $(audio).on("play", ->
      track.removeClass "paused"
    ).on "pause", ->
      track.addClass "paused"

  pauseAllOtherTracks: () ->
    $('.not-playing audio').each ->
      @.pause()
      @.currentTime = 0 if @.currentTime > 0

  showBuffer: (track, audio) ->
    loadingIndicator = track.find('.buffer')
    if audio.buffered isnt 'undefined'
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

  songEnd: (track, audio) ->
    $(audio).on "timeupdate", ->
      if audio.ended
        @bufferNext = null
        track.addClass("not-playing")
        new PlaySong(track.next())
