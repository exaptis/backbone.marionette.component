define [
  'modules/main/MainAppRouter'

], (
  MainAppRouter
) ->
  'use strict'

  class MainModule extends Backbone.Marionette.Module

    initialize: ->
      MainAppRouter.initialize(@)
