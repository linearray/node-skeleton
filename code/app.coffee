#
#  Module dependencies.
#

express = require 'express'
routes = require './routes'
http = require 'http'
cons = require 'consolidate'
stylus = require 'stylus'
path = require 'path'

proxiedIp = ->
    (req, res, next) ->
      if req.headers['cf-connecting-ip']?
        req.ip_proxied = req.headers['cf-connecting-ip']
      else
      req.ip_proxied = req.ips[req.ips.length-1]
      next()

app = express()

app.set 'port', process.env.PORT || 31337
app.engine '.jade', cons.jade
app.set 'view engine', 'jade'
app.set 'views', __dirname + '/../views'
app.set 'trust proxy', true
app.use proxiedIp()
app.use express.favicon()

if app.settings.env == 'production'
    app.use express.logger()
else
  app.use express.logger 'dev'

app.use express.cookieParser "n0Ð3 1$ 4w3$0m3"
app.use express.session()
app.use express.bodyParser()
app.use express.methodOverride()

app.use stylus.middleware
  src: __dirname + '/../views'
  dest: __dirname + '/../public'
  compile: (str,path) ->
      stylus(str).set('filename',path).set('warn', true).set('compress',true)

app.use express.static path.join __dirname, '/../public'

app.use express.errorHandler
  dumpExceptions: true
  showStack: true

app.get '/', routes.index

(http.createServer app).listen (app.get 'port'), ->
    console.log "Express #{app.settings.env} server listening on port " + app.get 'port'
