window.jumpTo = (ident, prefix='project-') ->
  top = $('.' + prefix + ident).offset().top
  obj = $ 'html, body'
  obj.stop()
  obj.animate {scrollTop: top - 100}, 1000, 'easeInOutQuart'

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

$ ->
  if 'ontouchstart' of document.documentElement
    $('.dot').removeClass 'dothover'

