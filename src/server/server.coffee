"use strict"
express = require("express")
http = require("http")
path = require("path")

# init express
app = express()
app.set "port", process.env.PORT

paths =
  root: path.join __dirname, '../../'
  build: path.join __dirname, '../../build/'
  source: path.join __dirname, '../../src/'

if process.env.DEBUG
  app.use (req, res, next) ->
    console.log '%s %s', req.method, req.url
    next()


# mount static
switch process.env.NODE_ENV

  when 'dev'
    app.use '/', express.static "#{paths.build}/app"

    #mount for js.maps
    app.use '/src/app', express.static "#{paths.source}/app"

    app.get "/", (req, res) ->
      res.sendFile "#{paths.build}/app/index.html"

  when 'test'
    app.use '/', express.static "#{paths.build}"

    app.get "/", (req, res) ->
      res.sendFile "#{paths.build}/test/index.html"

    #mount for js.maps
    app.use '/src/app', express.static "#{paths.source}/app"
    app.use '/src/test', express.static "#{paths.source}/test"


    app.get "/*.js.map", (req, res) ->
      res.sendStatus 200

  when 'dist'
    app.use '/', express.static "#{paths.build}/dist"

# mount static libraries
app.use '/bower_components', express.static "#{paths.root}/bower_components"
app.use '/node_modules', express.static "#{paths.root}/node_modules"

# start server
http.createServer(app).listen app.get("port"), ->
  console.log "Express App started!"
  return
