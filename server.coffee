if process.argv.length isnt 3
  console.log 'Usage: coffee server.coffee <port>'
  process.exit 1
port = parseInt process.argv[2]

express = require 'express'
mustache = require 'mustache'
fs = require 'fs'
sendmail = require('sendmail')()
useragent = require 'express-useragent'
{compile} = require 'coffee-script'
pages = require './pages'

app = express()
app.use express.static __dirname + '/assets'
app.use express.urlencoded()
app.use express.json()
app.use useragent.express()
app.get '/', (req, res) ->
  cb = (err, data) ->
    return res.send 'internal error' if err?
    year = '' + new Date().getFullYear()
    mac = req.useragent.isMac and req.useragent.isDesktop
    result = mustache.render data, pages: pages, year: year, mac: mac
    res.send result
  fs.readFile __dirname + '/assets/index.mustache', 'utf8', cb
app.get '/script.js', (req, res) ->
  fs.readFile __dirname + '/script.coffee', 'utf8', (e, d) ->
    return res.send 'internal error' if e?
    res.send compile d
app.post '/mail', (req, res) ->
  if typeof req.body.name isnt 'string'
    return res.send '{"error": "invalid req"}'
  if typeof req.body.email isnt 'string'
    return res.send '{"error": "invalid req"}'
  if typeof req.body.message isnt 'string'
    return res.send '{"error": "invalid req"}'
  message = 'Email: ' + req.body.email + '\n\n' + req.body.message
  object =
    from: 'jon@jonloeb.com'
    to: 'jon.loeb@me.com, alexnichol@comcast.net'
    subject: 'Contact Form from ' + req.body.name
    content: message
  sendmail object, (err, resp) ->
    if err?
      return res.send '{"error": "failed to send"}'
    else return res.send '{}'
app.get '*', (req, res) -> res.redirect '/'

app.listen port
