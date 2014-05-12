$(document).bind 'page:change', ->
  $.fancybox.init()
  $("#loading_div").hide()

ready = ->
  $('.gallery').fancybox()
  $('.fancybox_in_text').each ->
    imageurl = $(this).attr('src')
    $(this).wrap('<a href="' + imageurl + '" rel="gallery1" class="fancybox_link_in_text"></a>')

  $('a.fancybox_link_in_text').fancybox()

$(document).on 'page:fetch', ->
  $("#loading_div").show()

$(document).ready(ready)
$(document).on('page:load', ready)