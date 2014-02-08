window.jumpTo = (ident, prefix='project-') ->
  top = $('.' + prefix + ident).offset().top
  obj = $ 'html, body'
  obj.stop()
  obj.animate {scrollTop: top - getBarHeight()}, 1000, 'easeInOutQuart'

window.sendMessage = ->
  name = $('#name').val()
  email = $('#email').val()
  message = $('#message').val()
  opts = distance: 5
  if message is ''
    $('#message').stop()
    return $('#message').effect 'shake', opts
  exp = /^[a-zA-Z0-9\.\-_]*@[a-zA-Z0-9\-\._]*$/
  unless exp.exec(email)
    $('#email').stop()
    return $('#email').effect 'shake', opts
  data = name: name, email: email, message: message
  $.ajax
    url: '/mail'
    type: 'post'
    contentType: 'application/json; charset=utf-8'
    data: JSON.stringify data
  document.getElementById('message-button').onclick = ->
  $('#message-button').animate {opacity: 0}, ->
    $('#message-button td').text 'MESSAGE SENT'
    $('#message-button').animate {opacity: 1}
  $('input, textarea').attr 'disabled', 'disabled'
  $('input, textarea').animate {opacity: 0.5}, 'slow'

getBarHeight = ->
  val = Math.round $(window).height() * 0.2
  return 30 if val <= 30
  return val if val <= 100
  return 100

setBarHeight = (height) ->
  $('#header').css height: height
  $('#header-icon').css
    width: height * 0.8
    height: height * 0.8
    top: height * 0.1
    left: height * 0.1
  dotSize = height * 0.3
  $('#header-dots').css height: dotSize
  $('.dot').css
    width: dotSize
    height: dotSize
    'border-radius': dotSize / 2
    'margin-left': dotSize / 2
  $('#pages').css 'margin-top': height

$ ->
  if 'ontouchstart' of document.documentElement
    $('.dot').removeClass 'dothover'
  $(window).resize -> setBarHeight getBarHeight()
