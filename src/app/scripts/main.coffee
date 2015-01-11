require [
  'Application'
  'modules/main/MainModule'
  'i18next'
  'bootstrap'
], (
  Application
  MainModule
  i18next
) ->
  'use strict'

  rivets = require 'rivets'
  rivets.configure
    templateDelimiters: ['{{{{', '}}}}'],

  App = new Application

  App.module 'MainModule', moduleClass: MainModule

  App.on 'start', ->
    Backbone.history.start()
    $ "a[href='##{Backbone.history.fragment}']"
    .parents 'li:last'
    .addClass 'active'

  i18next.init lng: 'en', ->
    App.start()

  $('.nav').on 'click', 'a', ->
    $ '.nav li'
      .removeClass 'active'

    $ @
      .parents 'li:last'
      .addClass 'active'

