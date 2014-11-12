require [
  'Application'
  'modules/main/MainModule'
], (Application, MainModule) ->
  'use strict'

  App = new Application

  App.module 'MainModule', moduleClass: MainModule

  App.on 'start', ->
    Backbone.history.start()

  App.start()
