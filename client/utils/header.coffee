$(window).ready ->
  $('.mini-avatar').on "click", ->
    $userInfo = $('.user-info')
    if $userInfo.hasClass('show')
      $userInfo.removeClass('show').addClass('hide')
    else
      $userInfo.removeClass('hide').addClass('show')
