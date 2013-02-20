soundcloud_id = "dcfa20cb4e60440dbf3e8bb3c54b68a8"
$.getJSON "http://ex.fm/api/v3/user/plapier/loved?&results=20", (data) ->
  objects = data

  $.each data.songs, (key) ->
    # check for soundcloud url and set client_ID
    if @.url.search("soundcloud") isnt -1
      soundcloudURL = @.url + '?client_id=' + soundcloud_id
      @.url = soundcloudURL

  $.each data.songs, (key) ->
    domTrack =  """
      <li class="track not-playing">
        <a href="#" id="#{ @.id }">
          <span class="playtoggle"/>
          <div class="title"><span class='artist'>#{ @.artist }</span> &ndash; <span class='title'>#{ @.title }</span></div>
        </a>
        <div class="progress"></div>
        <div class="buffer"></div>
        <audio preload="none">
          <source src="#{ @.url }"/>
        </audio>
      </li>
      """
    $("#tracks").append(domTrack)


