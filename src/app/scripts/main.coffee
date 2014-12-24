require [
  'Application'
  'modules/main/MainModule'
  'i18n'
  'bootstrap'
], (
  Application
  MainModule
  i18n
) ->
  'use strict'

  App = new Application

  App.module 'MainModule', moduleClass: MainModule

  App.on 'start', ->
    Backbone.history.start()
    $ "a[href='##{Backbone.history.fragment}']"
    .parents 'li:last'
    .addClass 'active'

  i18n.init lng: 'en', ->
    App.start()

  $('.nav').on 'click', 'a', ->
    $ '.nav li'
      .removeClass 'active'

    $ @
      .parents 'li:last'
      .addClass 'active'

