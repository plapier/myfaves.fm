@endSong = () ->
  $currentSong = $('.playing-track audio').get(0)
  endTime = $currentSong.duration - 5
  $currentSong.currentTime = endTime

# @currentTrack = []

# @playNext = () ->
  # currentTrack = $('li.playing-track')
  # nextTrack = currentTrack.next()
  # PlayTrack(nextTrack)

# @playPrev = (currentTrack) ->
  # nextTrack = currentTrack.prev()
  # PlayTrack(prevTrack)
  # currentTrack = $('li.track:first-child')
class PlaySong
  @clickedTrack
  @audio

  constructor: (currentTrack) ->
    @playTrack(currentTrack)
    @playOrPause(@audio)
    @showBuffer(@clickedTrack, @audio)
    @showTrackProgress(@clickedTrack, @audio)
    @pauseAllOtherTracks()

  playTrack: (newTrack) ->
    @clickedTrack = $(newTrack)
    @audio = @clickedTrack.find("audio").get(0)

    # remove class from all currently playing tracks
    $('.playing-track').removeClass("playing-track").addClass("not-playing")

    # add playing-track to clicked track
    @clickedTrack.removeClass("not-playing").addClass("playing-track")

    $(@audio).on("play", ->
      $(@).addClass "playing"
      $(@clickedTrack).removeClass "paused"
    ).on("pause", ->
      $(@).removeClass "playing"
      $(@clickedTrack).addClass "paused"
    ).on "ended", ->
      $(@).removeClass "playing"
      $(@clickedTrack).removeClass("playing-track").addClass("not-playing")
      @playNextTrack(@clickedTrack)


  playOrPause: (audio) ->
    if audio.paused
      audio.play()
    else
      audio.pause()

  pauseAllOtherTracks: () ->
    $('.not-playing audio').each ->
      @pause()
      @currentTime = 0 if @currentTime > 0

  # Show loading Indicator
  showBuffer: (track, audio) ->
    loadingIndicator  = track.find('.buffer')
    if (audio.buffered isnt 'undefined')
      $(audio).on "progress", ->
        loaded = parseInt(((audio.buffered.end(0) / audio.duration) * 100), 10)
        loadingIndicator.css width: loaded + "%"

  showTrackProgress: (track, audio) ->
    progressIndicator = track.find('.progress')
    $(audio).bind "timeupdate", ->
      pos = (audio.currentTime / audio.duration) * 100
      progressIndicator.css width: pos + "%"
      unless loaded
        loaded = true

$(window).load ->
  $("#tracks").on "click", "li.track", ->
    event.preventDefault()
    new PlaySong(@)


