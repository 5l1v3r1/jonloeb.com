sendmail = require('sendmail')()

object =
  from: 'jon@jonloeb.com'
  to: 'jon.loeb@me.com, alexnichol@comcast.net'
  subject: 'test'
  content: 'This is a lame spam email'
sendmail object, console.log

setInterval (-> console.log 'hey'), 1000
