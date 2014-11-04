"use strict"
express = require("express")
http = require("http")
path = require("path")
async = require("async")
hbs = require("express-hbs")

# init express
app = express()
app.configure ->
  app.set "port", process.env.PORT or 3000
  app.set "view engine", "handlebars"
  app.set "views", __dirname + "../app/scripts/views"
  return

# set logging
app.use (req, res, next) ->
  console.log "%s %s", req.method, req.url
  next()
  return

# mount static
app.use '/', express.static(path.join(__dirname, "../build/app"))
app.use '/src/app', express.static path.join __dirname, '../../src/app'

# route index.html
app.get "/", (req, res) ->
  res.sendfile path.join(__dirname, "../../build/app/index.html")
  return

# start server
http.createServer(app).listen app.get("port"), ->
  console.log "Express App started!"
  return
