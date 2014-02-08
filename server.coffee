if process.argv.length isnt 3
  console.log 'Usage: coffee server.coffee <port>'
  process.exit 1
port = parseInt process.argv[2]

express = require 'express'
mustache = require 'mustache'
fs = require 'fs'
sendmail = require('sendmail')()
{compile} = require 'coffee-script'

pages = []
pages.push
  enabled: true
  color: '#e74c3c'
  class: 'jitsik'
  url: 'http://jitsik.com'
  image: 'Jitsik.png'
  name: 'Jitsik'
  description: 'Jitsik is a software development team I started a couple of years ago. The team together has developed many great applications for everyday use. All Jitsik applications can be download for free by anyone.'
pages.push 
  enabled: true
  color: '#e67e22'
  class: 'macheads'
  url: 'http://macheads101.com'
  image: 'macheads101.png'
  name: 'Macheads101'
  description: 'Macheads101 is a youtube channel I created in 2008 to teach the world about computers. Since then Macheads101 has grown tremendously. Today Macheads101 has over 500 videos and ten thousand subscribers.'
pages.push
  enabled: false
  color: '#f1c40f'
  class: 'flowflake'
  url: 'http://flowflake.com'
  image: 'flowflake.png'
  name: 'Flow Flake'
  description: 'Flow Flake is the world’s first IRC social network. The site allows users to chat with people about the topics they care about. Users can post content into flakes as well as follow the flakes of other members on the site.'
pages.push
  enabled: false
  color: '#2ecc71'
  class: '1mage'
  url: 'http://1mage.us'
  image: '1mage.png'
  name: '1mage.us'
  description: 'Image upload could probably not be any easier than it is with 1mage. The website allows anyone to upload images online for free. Anyone can post view and share images without needing to create an account.'
pages.push 
  enabled: true
  color: '#3498db'
  class: 'mustachemash'
  image: 'mustachemash.png'
  name: 'Mustache Mash'
  url: 'http://mustachemash.com'
  description: 'The ideal website for procrastination, Mustache Mash allows you to compare your facebook friends with and without a mustache. Simply connect with your facebook and let the fun begin.'

app = express()
app.use express.static __dirname + '/assets'
app.use express.urlencoded()
app.use express.json()
app.get '/', (req, res) ->
  cb = (err, data) ->
    return res.send 'internal error' if err?
    year = '' + new Date().getFullYear()
    result = mustache.render data, pages: pages, year: year
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
