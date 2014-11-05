"use strict"
express = require("express")
http = require("http")
path = require("path")

# init express
app = express()
app.set "port", process.env.PORT

paths =
  build: path.join __dirname, '../../build/'
  source: path.join __dirname, '../../src/'

# mount static
switch process.env.NODE_ENV

  when 'dev'
    app.use '/', express.static "#{paths.build}/app"
    app.use '/src/app', express.static "#{paths.source}/app"
    app.get "/", (req, res) ->
      res.sendfile "#{paths.build}/app/index.html"

  when 'test'
    app.use '/', express.static "#{paths.build}"
    app.use '/src/app', express.static "#{paths.src}/app"
    app.use '/scr/test', express.static "#{paths.src}/test"
    app.get "/", (req, res) ->
      res.sendfile "#{paths.build}/test/index.html"

  when 'dist'
    app.use '/', express.static "#{paths.build}/dist"


# start server
http.createServer(app).listen app.get("port"), ->
  console.log "Express App started!"
  return
